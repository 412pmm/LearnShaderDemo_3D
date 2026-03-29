Shader "Samples/US_X_Ray"
{
    Properties
    {
        // 被遮挡部分的显示效果
        [Header(The Blocked Part)]
        [Space(10)]
        _Color ("X-Ray Color", Color) = (0, 1, 1, 1)
        _Width ("X-Ray Width", Range(1, 2)) = 1
        _Brightness ("X-Ray Brightness", Range(0, 2)) = 1

        // 正常显示效果
        [Header(The Normal Part)]
        [Space(10)]
        _Albedo ("Albedo", 2D) = "white" {}
        [NoScaleOffset]_Specular ("Specular (RGB-A)", 2D) = "black" {}
        [NoScaleOffset]_Normal ("Normal", 2D) = "bump" {}
        [NoScaleOffset]_AO ("AO", 2D) = "white" {}
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry"} // 被遮挡物体需要显示，但是不需要显示其后面的物体, 所以渲染顺序没必要设置为 "Transparent"

        Pass
        {
            ZTest Greater // > 通过测试
            ZWrite Off // 为了不改变深度缓存中的深度值

            Blend SrcAlpha OneMinusSrcAlpha // 混合——显示半透明效果

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertexPos : SV_POSITION;
                float3 viewDir : TEXCOORD0;
                float3 worldNor : TEXCOORD1;
            };
            // 菲尼尔效果计算：法线，摄像机在世界坐标的视角方向
            // 亮度，宽度

            sampler2D _Albedo;
            float4 _MainTex_ST;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertexPos = UnityObjectToClipPos(v.vertex);
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                o.worldNor = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 _Color;
            fixed _Width;
            half _Brightness;

            fixed4 frag (v2f i) : SV_Target
            {
                // fresnel 计算
                half NDotV = saturate(dot(i.worldNor, i.viewDir));
                NDotV = pow(1 - NDotV, _Width) * _Brightness;
                
                fixed4 color;
                color.rgb = _Color.rgb;
                color.a = NDotV;
                return color;
            }
            ENDCG
        }

        // 正常显示
        CGPROGRAM
        #pragma surface surf StandardSpecular
        #pragma target 3.0
        struct Input
        {
            float2 uv_Albedo;
        };

        sampler2D _Albedo;
        sampler2D _Specular;
        sampler2D _Normal;
        sampler2D _AO;

        void surf(Input IN, inout SurfaceOutputStandardSpecular o)
        {
            o.Albedo = tex2D(_Albedo, IN.uv_Albedo).rgb;
            fixed4 specular = tex2D(_Specular, IN.uv_Albedo);
            o.Specular = specular.rgb;
            o.Smoothness = specular.a;

            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Albedo));
        }
        ENDCG
    }
}
