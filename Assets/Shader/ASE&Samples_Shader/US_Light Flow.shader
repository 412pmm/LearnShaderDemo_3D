Shader "Samples/US_Light Flow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)

        // ¹Ø¼ü´ÊÃ¶¾Ù
        [KeywordEnum(X,Y)] _DIRECTION("Flow Direction", float) = 0
        _Speed("Flow Speed", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }

        Blend One One
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #pragma shader_feature _DIRECTION_X _DIRECTION_Y

            #include "UnityCG.cginc"

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _Speed;

            v2f vert (appdata_base v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 texcoord;
                #if _DIRECTION_X
                texcoord = float2(i.texcoord.x + _Time.x * _Speed, i.texcoord.y);
                #elif _DIRECTION_Y
                texcoord = float2(i.texcoord.x, i.texcoord.y + _Time.x * _Speed);
                #endif

                // sample the texture
                return tex2D(_MainTex, texcoord) * _Color;
            }
            ENDCG
        }
    }
}
