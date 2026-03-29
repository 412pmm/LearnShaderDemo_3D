Shader "Custom/US_Transparent_twoSide"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor("MainColor(RGB_A)", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { 
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }

        // 分两个pass ，分别渲染正面/反面
        Pass
        {
            Tags{"LightMode"="ForwardBase"}

            // 开启正面剔除
            Cull Front
            // 设置渲染状态
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha  //简单的透明效果

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 worldPos : TEXCOORD0;
                float2 texcoord : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;

            v2f vert (appdata_base v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldNormal = normalize(worldNormal);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 worldLight = UnityWorldSpaceLightDir(i.worldPos.xyz);
                worldLight = normalize(worldLight);

                fixed NdotL = saturate(dot(i.worldNormal, worldLight));
                fixed4 color = tex2D(_MainTex, i.texcoord);
                
                color.rgb *= _MainColor.rgb * NdotL * _LightColor0;
                color.rgb += unity_AmbientSky;
                // Lambert光照模型

                color.a *= _MainColor.a; //

                return color;
            }
            ENDCG
        }

        // 第二个pass 渲染正面
        Pass
        {
            Tags{"LightMode"="ForwardBase"}

            // 剔除背面
            Cull Back
            // 设置渲染状态
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha  //简单的透明效果

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 worldPos : TEXCOORD0;
                float2 texcoord : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;

            v2f vert (appdata_base v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldNormal = normalize(worldNormal);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 worldLight = UnityWorldSpaceLightDir(i.worldPos.xyz);
                worldLight = normalize(worldLight);

                fixed NdotL = saturate(dot(i.worldNormal, worldLight));
                fixed4 color = tex2D(_MainTex, i.texcoord);
                
                color.rgb *= _MainColor.rgb * NdotL * _LightColor0;
                color.rgb += unity_AmbientSky;
                // Lambert光照模型

                color.a *= _MainColor.a; //

                return color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
