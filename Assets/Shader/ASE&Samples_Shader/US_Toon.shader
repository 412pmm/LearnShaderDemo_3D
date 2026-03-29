Shader "Samples/US_Toon"
{
    Properties
    {
        // outline 
        [Header(Outline)] [Space(10)]
        _OutlineColor ("Outline Color", Color) = (1,0,0,1)
        _OutlineWidth ("Outline width", float) = 0.01

        // DIFFUSE 
        [Header(Diffuse)] [Space(10)]
        [NoScaleOffset]_Ramp ("Toon Ramp", 2D) = "white" {}
        [NoScaleOffset]_Albedo ("Albedo", 2D) = "white" {}

        // SPECULAR
        [Header(Specular)] [Space(10)]
        _RimWidth ("Rim Width", Range(0, 1)) = 0.3
        _RimFalloff ("Rim Falloff", Range(0.01, 10)) = 2
        _RimColor ("Rim Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }

        // Outline
        pass
        {
            Cull Front
            // 正面剔除，
            // 描边测试具有深度值并且参与深度测试 -> 达到只要有重叠就会描边的效果

            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 _OutlineColor;
            half _OutlineWidth;

            float4 vert (appdata_base v) : SV_POSITION
            {
                v.vertex.xyz += v.normal * _OutlineWidth;
                return UnityObjectToClipPos(v.vertex);
            }

            float4 frag() : SV_Target
            {
                return _OutlineColor;
            }

            ENDCG
        }

        // 表面着色器
        CGPROGRAM
        #pragma surface surf Toon 
        // 定义了新的光照模型为Toon

        sampler2D _Albedo;

        // 输入结构体
        struct Input 
        {
            float2 uv_Albedo;
            // 自定义光照函数中会使用到 法线向量和摄像机方向向量
            float3 worldNormal;
            float3 viewDir;
        };

        // 自定义表面函数  输出结构体
        // 自定义的光照模型需要用到其他一些变量，内置的SurfaceOutput等一系列结构体已经无法存储这些数据了
        // 因此需要重新定义光照函数的输入结构体————也就是表面函数的输出结构体————SurfaceOutputToon
        struct SurfaceOutputToon
        {
            half3 Albedo;
            half3 Normal;
            half3 Emission;
            fixed Alpha;
            // 以上为必须的四个变量
            
            // Input结构体
            Input SurfaceInput;
            // 内置的全局照明结构
            UnityGIInput GIdata;
        };

        // 表面函数
        void surf(Input i, inout SurfaceOutputToon o)
        {
            o.SurfaceInput = i;
            // 在光照函数中才会用到 worldNormal 和 viewDir ，因此需要将Input结构体原封不动提供给 SurfaceOutputToon 结构体中 SurfaceInput
            o.Albedo = tex2D(_Albedo, i.uv_Albedo);

            // 其他变量会自动填充
        }

        // 名称 "Lighting" + 光照模型名字 + "_GI" 
        void LightingToon_GI (inout SurfaceOutputToon s, UnityGIInput GIdata, UnityGI gi)
        {
            s.GIdata = GIdata;  // 传递数据 GIdata 
        }

        sampler2D _Ramp;
        half4 _RimColor;
        fixed _RimWidth;
        half _RimFalloff;

        // 自定义光照函数
        half4 LightingToon (SurfaceOutputToon s, UnityGI gi)
        {
            UnityGIInput GIdata = s.GIdata;
            Input i = s.SurfaceInput;
            // 进行赋值，方便调取变量

            gi = UnityGI_Base(GIdata, GIdata.ambient, i.worldNormal);

            fixed NdotL = dot(i.worldNormal, gi.light.dir);
            fixed2 rampTexcoord = NdotL * 0.5 + 0.5; // float2(NdotL * 0.5 + 0.5, NdotL * 0.5 + 0.5);
            fixed3 ramp = tex2D(_Ramp, rampTexcoord).rgb;

            half3 diffuse = s.Albedo * ramp * (_LightColor0.rgb * (GIdata.atten + gi.indirect.diffuse));

            // 计算边缘高光
            fixed NdotV = dot(i.worldNormal, i.viewDir);
            fixed rimMask = pow((1.0 - saturate((NdotV + _RimWidth))), _RimFalloff);
            half3 rim = saturate(rimMask * NdotL) * _RimColor * _LightColor0.rgb * GIdata.atten;

            return half4(diffuse + rim, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
