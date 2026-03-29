Shader "Custom/US_HalfLambert"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)
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
            #include "UnityLightingCommon.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed4 dif : COLOR0;
            };

            fixed4 _MainColor;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                // ∑®
                float3 n = UnityObjectToWorldNormal(v.normal);
                n = normalize(n);
                // π‚
                fixed3 l = normalize(_WorldSpaceLightPos0.xyz);
                // º∆À„
                fixed ndotl = dot(n,l);
                o.dif = _LightColor0 * _MainColor * (0.5 * ndotl + 0.5);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return i.dif;
            }
            ENDCG
        }
    }
}
