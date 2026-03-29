Shader "Custom/US_Blinn_PhongSimplestShader"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1) // 物体漫反射颜色
        _SpecularColor ("Specular Color", Color) = (0,0,0,0) // 高光颜色
        _Shininess ("Shininess", Range(1, 100)) = 1 // 光泽度
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
                // 逐顶点计算
                // float4 pos : SV_POSITION;
                // fixed4 color : COLOR0;

                // 修改为逐像素计算
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;
                float4 vertex : TEXCOORD1;
            };

            fixed4 _MainColor;
            fixed4 _SpecularColor;
            half _Shininess;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.vertex = v.vertex;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // 计算公式中的变量
                float3 n = UnityObjectToWorldNormal(i.normal);
                n = normalize(n);
                fixed3 l = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 view = normalize(WorldSpaceViewDir(i.vertex));
                // 漫反射
                fixed ndotl = dot(n,l);
                fixed4 dif = _LightColor0 * _MainColor * saturate(ndotl);
                // 镜面反射
                float3 h = normalize(l + view);
                fixed ndoth = saturate(dot(n, h));
                fixed4 spec = _LightColor0 * _SpecularColor * pow(ndoth, _Shininess);
                return dif + spec + unity_AmbientSky;
            }
            ENDCG
        }
    }
}
