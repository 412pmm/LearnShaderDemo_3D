Shader "Samples/SS_Dissolve"
{
    Properties
    {
        [Header(PBS Textures)]
        [Space(10)]
        [NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
        [NoScaleOffset]_Specular("Specular", 2D) = "balck" {}
        [NoScaleOffset]_Normal("Normal", 2D) = "bump" {}
        [NoScaleOffset]_AO("AO", 2D) = "white" {}

        [Header(Dissolve Properties)]
        [Space(10)]
        _Noise("Dissolve Noise", 2D) = "white" {}
        _Dissolve("Dissolve", Range(0, 1)) = 0
        [NoScaleOffset]_Gradient("Edge Gradient", 2D) = "balck" {}
        _Range("Edge Range", Range(2, 100)) = 6
        _Brightness("Brightness", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf StandardSpecular addshadow fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_Albedo;
            float2 uv_Noise;
        };

        sampler2D _Albedo;
        sampler2D _Specular;
        sampler2D _Normal;
        sampler2D _AO;

        sampler2D _Noise;
        fixed _Dissolve;
        sampler2D _Gradient;
        float _Range;
        float _Brightness;

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            // ClipMask
            fixed noise = tex2D(_Noise, IN.uv_Albedo).r; // 灰度图
            fixed dissolve = _Dissolve * 2 - 1;  // [-1, 1]  使得原先的灰度值可以全部是0或者全部是1
            fixed mask = saturate(noise - dissolve);
            clip(mask - 0.5); // 默认的是和0.5比较，进行像素

            // burn
            fixed texcoord = saturate(mask*_Range - 0.5*_Range); // 拉伸火焰颜色的尺度
            o.Emission = tex2D(_Gradient, fixed2(texcoord, 0.5)) * _Brightness;

            fixed4 c = tex2D(_Albedo, IN.uv_Albedo);
            o.Albedo = c.rgb;

            fixed4 specular = tex2D(_Specular, IN.uv_Albedo);
            o.Specular = specular.rgb;
            o.Smoothness = specular.a;

            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Albedo));
            o.Occlusion = tex2D(_AO, IN.uv_Albedo);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
