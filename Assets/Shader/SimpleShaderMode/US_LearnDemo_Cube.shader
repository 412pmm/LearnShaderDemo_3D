Shader "Custom/US_LearnDemo_Cube"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor ("MainColor", Color) = (1,1,1,1)

        _Cubemap ("Cubemap", Cube) = ""{}
        _Reflection ("Reflection", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            sampler _MainTex;
            float4 _MainTex_ST;
            float4 _MainColor;
            samplerCUBE _Cubemap;
            fixed _Reflection;

            void vert (in float4 vertex : POSITION,
                in float3 normal : NORMAL,
                in float4 uv : TEXCOORD0,
                out float4 position : SV_POSITION,
                out float4 worldPos : TEXCOORD0,
                out float3 worldNormal : TEXCOORD1,
                out float2 texcoord : TEXCOORD2)
            {
                position = UnityObjectToClipPos(vertex);
                worldPos = mul(unity_ObjectToWorld, vertex);
                worldNormal = mul(normal, (float3x3)unity_WorldToObject); // 法线计算：逆函数，右乘
                worldNormal = normalize(worldNormal);
                texcoord = uv*_MainTex_ST.xy + _MainTex_ST.zw;
            }

            void frag (in float4 position : SV_POSITION,
                in float4 worldPos : TEXCOORD0,
                in float3 worldNormal : TEXCOORD1,
                in float2 texcoord : TEXCOORD2,
                out fixed4 color : SV_Target)
            {
                fixed4 main = tex2D(_MainTex, texcoord)*_MainColor;
                // 从摄像机到顶点的方向向量
                float3 viewDir = worldPos.xyz - _WorldSpaceCameraPos;
                viewDir = normalize(viewDir);

                //计算反射向量
                float3 refDir = 2*dot(-viewDir, worldNormal)*worldNormal+viewDir;
                refDir = normalize(refDir);

                // 采样
                fixed4 reflection = texCUBE(_Cubemap, refDir);

                // 插值运算
                color = lerp(main, reflection, _Reflection);
            }

            ENDCG
        }
    }
}
