Shader "Samples/US_MatCap"
{
    Properties
    {
        [NoScaleOffset]_MainTex ("MatCap", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;

            v2f vert (appdata_base v)
            {
                v2f o;

                float4 normal = mul(UNITY_MATRIX_IT_MV, float4(v.normal, 0));
                o.uv = normalize(normal.xyz).xy;

                o.vertex = UnityObjectToClipPos(v.vertex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 texcoord = i.uv * 0.5 + 0.5;
                return tex2D(_MainTex, texcoord);
            }
            ENDCG
        }
    }
}
