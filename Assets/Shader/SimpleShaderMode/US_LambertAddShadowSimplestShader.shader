Shader "Custom/US_LambertAddShadowSimplestShader"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        //平行光投影（还包括逐顶点或SH的灯光渲染）
        Pass
        {   
            Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct v2f
            {   
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;
                float4 vertex : TEXCOORD1;
                SHADOW_COORDS(2) //使用预定义宏保存阴影坐标
            };

            fixed4 _MainColor;
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.vertex = v.vertex;
                TRANSFER_SHADOW(o) //将阴影纹理坐标装入结构体
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {   
                //世界空间法向量、光照方向、顶点坐标
                float3 n = UnityObjectToWorldNormal(i.normal);
                n = normalize(n);
                float3 l = WorldSpaceLightDir(i.vertex); //使用WorldSpaceLightDir计算光照方向而不用WorldSpaceLightPos（只计算平行光）
                l = normalize(l);
                float4 worldPos = mul(unity_ObjectToWorld,i.vertex);

                //Lambert光照
                fixed ndotl = saturate(dot(n, l));
                fixed4 color = _LightColor0 * _MainColor * ndotl;

                //点光源的光照
                color.rgb += Shade4PointLights(
                unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,
                unity_LightColor[0].rgb, unity_LightColor[1].rgb,
                unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                unity_4LightAtten0, worldPos.rgb, n) * _MainColor;
                
                //环境光照
                color += unity_AmbientSky;

                //计算阴影系数
                UNITY_LIGHT_ATTENUATION(shadowmask,i,worldPos.rgb);

                //阴影合成
                color.rgb *= shadowmask;
                return color;
            }
            ENDCG
        }
        // 其他逐像素灯光投影
        Pass
        {
            Tags{"LightMode" = "ForwardAdd"}
            //使用相加混合，与上个Pass融合
            Blend One One 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd_fullshadows
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct v2f
            {   
                
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;
                float4 vertex : TEXCOORD1;
                SHADOW_COORDS(2) //使用预定义宏保存阴影坐标
            };

            fixed4 _MainColor;
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.vertex = v.vertex;
                TRANSFER_SHADOW(o) //将阴影纹理坐标装入结构体
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {   
                //世界空间法向量、光照方向、顶点坐标
                float3 n = UnityObjectToWorldNormal(i.normal);
                n = normalize(n);
                float3 l = WorldSpaceLightDir(i.vertex); //使用WorldSpaceLightDir计算光照方向而不用WorldSpaceLightPos（只计算平行光）
                l = normalize(l);
                float4 worldPos = mul(unity_ObjectToWorld,i.vertex);

                //Lambert光照
                fixed ndotl = saturate(dot(n, l));
                fixed4 color = _LightColor0 * _MainColor * ndotl;

                //点光源的光照
                color.rgb += Shade4PointLights(
                    unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,
                    unity_LightColor[0].rgb, unity_LightColor[1].rgb,
                    unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                    unity_4LightAtten0, worldPos.rgb,n) * _MainColor;
                
                //环境光照不再计算 上个Pass已做
                //color += unity_AmbientSky;

                //计算阴影系数
                UNITY_LIGHT_ATTENUATION(shadowmask,i,worldPos.rgb);

                //阴影合成
                color.rgb *= shadowmask;
                return color;
            }

            ENDCG
        }
    }
    FallBack "Diffuse" //使用Difuuse中的阴影投射Pass
}

