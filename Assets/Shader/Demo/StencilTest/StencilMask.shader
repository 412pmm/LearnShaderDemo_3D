Shader "Stencil/StencilMask"
{
    Properties
    {
        // Stencil Mask的模板值
        _ID("Mask ID", Int) = 1
    }
    SubShader
    {
        LOD 100

        // 将渲染顺序安排在正常物体之后
        Tags { "RenderType"="Opaque" "Queue"="Geometry+1" }

        // 不输出（透明）
        ColorMask 0

        // 避免后面的物体全部被裁剪不显示
        ZWrite off 

        Stencil{
            Ref[_ID] // 参考值
            Comp always // 默认为always
            Pass replace // 通过的像素的模板值将被替换为_ID（默认为keep）
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return half4(1,1,1,1);
            }
            ENDCG
        }
    }
}
