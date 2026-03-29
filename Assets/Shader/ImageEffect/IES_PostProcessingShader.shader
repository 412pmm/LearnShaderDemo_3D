Shader "Hidden/IES_PostProcessingShader"
{
// 调整亮度/饱和度/对比度
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}  // 用于接收摄像机渲染的 Render Teexture
        _Brightness("Brightness", float) = 1
        _Saturation("Saturation", float) = 1
        _Contrast("Contrast", float) = 1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always // 避免后期处理的面片对场景中已存在的物体产生影响

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img 
            // 后期处理不需要对顶点着色器进行操作，因此可以直接声明使用Unity内置的vert_img顶点着色器
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            half _Brightness;
            half _Saturation;
            half _Contrast;

            half4 frag (v2f_img i) : SV_Target
            {
                // 使用 v2f_img 结构体内纹理坐标对 RenderTexture 采样
                half4 renderTex = tex2D(_MainTex, i.uv);
                
                // 亮度
                half3 finalColor = renderTex.rgb * _Brightness;

                // 饱和度
                half luminance = Luminance(finalColor); // 灰度图
                finalColor = lerp(luminance, finalColor, _Saturation); // 插值计算

                // 对比度
                half3 grayColor = half3(0.5, 0.5, 0.5);
                finalColor = lerp(grayColor, finalColor, _Contrast);

                return half4(finalColor, 1);
            }
            ENDCG
        }
    }
}
