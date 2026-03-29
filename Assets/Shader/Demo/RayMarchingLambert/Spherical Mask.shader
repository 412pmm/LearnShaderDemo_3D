Shader "PeerPlay/Spherical Mask"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        // Spherical Mask
        [Header(SphericalMask)]
        _MaskPosition ("Mask Position", vector) = (0, 0, 0)
        _MaskRadius ("Mask Radius", float) = 0
        _ColorStrength ("Color Strength", Range(1, 4)) = 1
        _MaskSmoothness ("Mask Smoothness", Range(0,1)) = 0

        [Header(EmissionColor)]
        _EmissionColor ("Emission Color", Color) = (1,1,1,1)
        _EmissionTex ("Emission Texture", 2D) = "white" {}
        _EmissionStrength ("Emission Strength", Range(0, 4)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_EmissionTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Spherical Mask
        half4 _MaskPosition;
        half _MaskRadius;
        half _ColorStrength;
        half _MaskSmoothness;

        // Emission COLOR
        sampler2D _EmissionTex;
        fixed4 _EmissionColor;
        half _EmissionStrength;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            // grayScale
            fixed gray_graduration = c.r * 0.299 + c.g * 0.587 + c.b * 0.114;
            fixed3 c_g = (gray_graduration, gray_graduration, gray_graduration);

            // SphericalMask
            half d = distance(_MaskPosition, IN.worldPos);
            
            /*
            half r_c = _MaskRadius * (1 - _MaskSmoothness);
            half c_step = smoothstep(r_c, _MaskRadius, d);
            o.Albedo = c_step * fixed4(c_g, c.w) + (1 - c_step) * c;
            */
            
            half sum = saturate((d - _MaskRadius) / -_MaskSmoothness);
            fixed4 lerpColor = lerp(fixed4(c_g, c.w), c * _ColorStrength, sum);

            // emissionColor
            fixed4 emissionColor =  tex2D(_EmissionTex, IN.uv_EmissionTex) * _EmissionColor * _EmissionStrength;
            emissionColor = lerp(fixed4(0,0,0,emissionColor.w), emissionColor, sum);

            o.Albedo = lerpColor;
            o.Emission = emissionColor.xyz;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
