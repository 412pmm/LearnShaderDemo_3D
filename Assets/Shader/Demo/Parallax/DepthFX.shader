// https://gist.github.com/bozzin/5895d97130e148e66b88ff4c92535b59

// requires DepthFX.cs script to send mouseposition

Shader "Custom/DepthFX"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DepthTex ("Depth Texture", 2D) = "white" {}
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _DepthTex;
            float4 _MainTex_ST;

            float4 _MousePos;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float parallaxMult = tex2D(_DepthTex, i.uv);
                // 视觉偏差
                float2 parallax = _MousePos.xy*parallaxMult;
                // 在代码中将鼠标位置与深度值相乘的做法可能是为了实现一种动态的视差效果，使得用户可以通过移动鼠标来调整视差的强度或位置，从而在实时渲染中产生不同的立体感效果
                fixed4 c = tex2D(_MainTex, i.uv+ parallax);

                return c;
            }
            ENDCG
        }
    }
}
