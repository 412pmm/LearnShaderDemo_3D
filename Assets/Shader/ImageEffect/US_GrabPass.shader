Shader "Custom/US_GrabPass"
{
    Properties
    {
        _GrayScale ("Gray Scale", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }

        // 调用GrabPass 定义抓取的图像名字
        GrabPass{"_ScreenTex"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 grabPos : TEXCOORD0;
            };


            v2f vert (float4 vertex : POSITION)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                // 计算抓取图像在屏幕上的位置
                o.grabPos = ComputeGrabScreenPos(o.pos);
                return o;
            }

            fixed _GrayScale;
            // 声明抓取的图像
            sampler2D _ScreenTex;

            fixed4 frag (v2f i) : SV_TARGET
            {
                // 采样抓取的图像
                // tex2Dproj函数用于在Shader中对纹理进行投影采样。
                // 这个函数可以根据传入的投影矩阵，对纹理进行采样并进行透视校正，通常用于在屏幕空间中进行纹理采样。
                half4 src = tex2Dproj(_ScreenTex, i.grabPos);
                // Luminance()函数来计算 像素(每个) 的亮度值。这个函数会将像素的RGB值转换为亮度值，通常是通过加权计算得到的。
                half grayscale = Luminance(src.rgb);
                half4 dst = half4(grayscale, grayscale, grayscale, 1);
                // 插值计算
                return lerp(src, dst, _GrayScale);
            }
            ENDCG
        }
    }
}
