Shader "Hidden/IES_BSC-HLSL"
{
    HLSLINCLUDE
        #include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
        // StdLib.hlsl , 里面预先定义了顶点着色器

        // 属性声明
        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex); // 宏定义：语句声明摄像机渲染的 Render Texture
        half _Brightness;
        half _Saturation;
        half _Contrast;

        float4 Frag(VaryingsDefault i) : SV_Target
        {
            // 采样 RenderTexture
            float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

            color.rgb *= _Brightness;

            float luminance = dot(color.rgb, float3(0.2126729, 0.7151522, 0.0721750));
            color.rgb = lerp(luminance, color.rgb, _Saturation);

            return color;
        }
    ENDHLSL

    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            HLSLPROGRAM
                #pragma vertex VertDefault;
                #pragma fragment Frag;
            ENDHLSL
        }
    }
}
