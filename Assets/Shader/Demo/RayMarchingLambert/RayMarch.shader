Shader "Custom/RayMarch"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

            #define MAX_ITERATION 100
            #define MAX_DISTANCE 100
            #define MIN_DISTANCE 1e-3

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 ro : TEXCOORD1;
                float3 hitPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Tiling;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.ro = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)); // 转换到模型空间
                o.hitPos = v.vertex; // 模型上点坐标
                return o;
            }

            float GetDistance(float3 p)
            {
                float d = (length(p-float3(0,0,0)) - .5);
                d = length(float2(length(p.xz) - .5, p.y)) - .1;
                return d;
            }

            float3 GetNormal(float3 p)
            {
                float2 offset = float2(1e-2, 0);
                float3 n = float3(GetDistance(p + offset.xyy) - GetDistance(p - offset.xyy),
                GetDistance(p + offset.yxy) - GetDistance(p - offset.yxy),
                GetDistance(p + offset.yyx) - GetDistance(p - offset.yyx));
                return normalize(n);
            }


            float RayMarching(float3 ro, float3 rd)
            {
                float traveled = 0;
                float dis = 0;
                for (int i = 0; i < MAX_ITERATION; i++)
                {   
                    if (traveled > MAX_DISTANCE)
                    {
                        break; // 没有碰到物体
                    }

                    float3 newPos = ro + rd * traveled;
                    dis = GetDistance(newPos);
                    if (dis < MIN_DISTANCE)
                    {
                        break; // 击中物体
                    }
                    traveled += dis;
                }
                return traveled;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = 1;

                // raymarching 
                float3 ro = i.ro; // float3(0,0,-3);
                float3 rd = normalize(i.hitPos - ro); // normalize(float3(uv.x, uv.y, 1));
                float d = RayMarching(ro, rd); // 模型空间

                if(d >= MAX_DISTANCE)
                {
                    discard;
                }
                else
                {
                    float3 p = ro + rd * d;
                    float3 n = GetNormal(p);
                    // col.rgb = n;
                    // 纹理可以用 TriPlanar

                    // float3 worldPos = mul(unity_ObjectToWorld, float4(p, 1));
                    float3 texcoord = p;
                    fixed4 colXY = tex2D(_MainTex, texcoord.xy);
                    fixed4 colYZ = tex2D(_MainTex, texcoord.yz);
                    fixed4 colXZ = tex2D(_MainTex, texcoord.xz);

                    // 法线权重

                    // 效果很怪，下面这个
                    //// float3 worldNormal = mul(unity_ObjectToWorld, float4(n, 1));
                    //float3 weight = abs(n);
                    //fixed weightX = saturate(dot(n, fixed3(1,0,0)));
                    //fixed weightY = saturate(dot(n, fixed3(0,1,0)));
                    //// 混合
                    //col = lerp(colXY, colYZ, weightX);
                    //col = lerp(col, colXZ, weightY);

                    float3 weight = abs(n);
                    weight = weight / (weight.x + weight.y + weight.z);
                    col = colXY * weight.z + colXZ * weight.y + colYZ * weight.x;
                }
                
                return col;
            }
            ENDCG
        }
    }
}
