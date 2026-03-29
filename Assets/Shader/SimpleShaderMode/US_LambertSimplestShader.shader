Shader "Custom/US_LambertSimplestShader"
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
            // 声明包含灯光变量的文件
            #include "UnityLightingCommon.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed4 dif : COLOR0;
            };

            fixed4 _MainColor;

            void vert (in appdata_base v, out v2f o)
            {
                
                o.pos = UnityObjectToClipPos(v.vertex);
                
                // 法相向量
                float3 n = UnityObjectToWorldNormal(v.normal);
                n = normalize(n);

                // 灯光方向
                fixed3 l = normalize(_WorldSpaceLightPos0.xyz);

                // 计算
                fixed ndotl = dot(n,l);
                o.dif = _LightColor0 * _MainColor * saturate(ndotl);
                
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return i.dif;
            }
            ENDCG
        }
    }
}
