Shader "Samples/US_SequenceAnimation"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Sequence Animation", 2D) = "white" {}
        _Tint ("Tint", Color) = (1,1,1,0)

        _Row ("Row", float) = 4
        _Column ("Column", float) = 4
        _Rate ("Rate", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "DisableBatching"="True" }
        LOD 100

        Blend OneMinusDstColor One
        ZWrite Off

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
            fixed4 _Tint;
            float _Row;
            float _Column;
            float _Rate;

            v2f vert (appdata v)
            {
                v2f o;
                // Billboard
                float3 forward = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos,1)).xyz;
                forward.y = 0;
                forward = normalize(forward);
                float3 up = abs(forward.y) > 0.999 ? float3(0,0,1) : float3(0,1,0);
                float3 right = normalize(cross(forward, up));
                up = normalize(cross(right, forward));
                float3 vertex = v.vertex.x * right + v.vertex.y * up;
                o.vertex = UnityObjectToClipPos(vertex);

                // 帧序列
                float time = floor(_Time.y * _Rate);
                // 行变的比列慢->从左到右，从上到下
                float row = floor(time/_Column);
                float column = fmod(time, _Column);

                float texcoordU = (v.uv.x + column) / _Column;
                float texcoordV = (v.uv.y - 1 - row) / _Row;
                o.uv = float2(texcoordU,texcoordV);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv) * _Tint;
            }
            ENDCG
        }
    }
}
