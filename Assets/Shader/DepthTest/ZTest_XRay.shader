Shader "Samples/ZTest_XRay"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _XRayColor("XRay Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        CGINCLUDE
        #include "UnityCG.cginc"
        fixed4 _XRayColor;

        struct v2f
        {
            float4 pos : SV_POSITION;
            float3 normal : NORMAL;
            float3 viewDir : TEXCOORD0;
            float4 clr : COLOR;
        };

        // XRay 部分的着色器
        // XRay 顶点着色器
        v2f vertXRay(appdata_base v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.viewDir = ObjSpaceViewDir(v.vertex); // 模型空间的视线方向
            o.normal = v.normal;

            // 模型空间上的计算
            float3 normal = normalize(v.normal);
            float3 viewDir = normalize(o.viewDir);
            float rim = 1 - dot(normal, viewDir);

            o.clr = _XRayColor * rim;
            return o;
        }

        fixed4 fragXRay(v2f i) : SV_TARGET
        {
            return i.clr;
        }

        sampler2D _MainTex;
        float4 _MainTex_ST;

        struct v2f2
        {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
        };

        v2f2 vertNormal(appdata_base v)
        {
            v2f2 o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
            return o;
        }

        fixed4 fragNormal(v2f2 i) : SV_TARGET 
        {
            return tex2D(_MainTex, i.uv);
        }
        ENDCG

        // 两次渲染pass
        // XRay 渲染 ‘透明’
        Pass
        {
            Tags{"RenderType" = "Transparent" "Queue"="Transparent"}
            Blend SrcAlpha One 
            ZTest Greater
            ZWrite Off 
            Cull Back 

            CGPROGRAM
            #pragma vertex vertXRay
            #pragma fragment fragXRay
            ENDCG
        }

        // 正常渲染
        Pass 
        {
            Tags{"RenderType" = "Opaque"}
            // 默认
            ZTest LEqual
            ZWrite On

            CGPROGRAM
            #pragma vertex vertNormal
            #pragma fragment fragNormal
            ENDCG
        }
    }
}
