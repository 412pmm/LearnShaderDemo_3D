Shader "Samples/SS_class"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "black" {}
        _MainTex2 ("Texture2", 2D) = "black" {}
        _MaskTex ("_MaskTex", 2D) = "black" {}
		_MatCap01Pow("_MatCap01Pow",Float)=1
		_refract("_refract",Float) =1
		[HDR]_refacColor("_refacColor",Color)=(0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent"  "Queue" = "Transparent"}

        Pass
        {
			Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
				half3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				half3 normalWS : TEXCOORD1;		
                float4 pos : SV_POSITION;
				float4 posWS : TEXCOORD2;
				float4 vPOS : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;	   
			sampler2D _MainTex2;
            float4 _MainTex2_ST;  
			sampler2D _MaskTex;
            float4 _MaskTex_ST;

			float _MatCap01Pow;
			float _refract;
			float4 _refacColor;


            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); // 剪裁空间坐标
				o.posWS = mul(unity_ObjectToWorld,v.vertex); // 世界空间坐标
				o.normalWS = UnityObjectToWorldNormal(v.normal); // 世界空间法线
                o.uv = v.texcoord;
				o.vPOS = o.posWS - v.vertex; // 偏移
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // 标准化
				half3 viewDir = normalize(UnityWorldSpaceViewDir(i.posWS));
				half3 normalVS = normalize(mul(UNITY_MATRIX_V,i.normalWS));
				//改进版matCapUV
				float3 posVS = normalize(mul(UNITY_MATRIX_V,i.posWS));
				normalVS = cross(posVS,normalVS);
				normalVS.y = - normalVS.y;

				half thickMask = tex2D (_MaskTex,i.uv).g;
				half NdotV = abs(dot(i.normalWS,viewDir));
				half fresnel = smoothstep(1,0,NdotV);
				fresnel = fresnel+thickMask; // 菲尼尔和遮罩效果

				float uvOffset = fresnel*_refract;

				float2 matCapUV = normalVS.yx*0.5+0.5;
				float2 matCapUV2 = uvOffset+matCapUV;
				
				half4 matCap01 = tex2D(_MainTex,matCapUV)*_MatCap01Pow;


				half4 matCap02 = tex2D(_MainTex2,matCapUV2);

				matCap02 = lerp (_refacColor*0.5,_refacColor*matCap02,clamp(0,1,uvOffset));
				float alpha = saturate(max(matCap01.r,fresnel*fresnel));

				half4 col = matCap01+ matCap02;

                return float4(col.rgb,alpha);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
