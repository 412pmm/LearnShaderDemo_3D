Shader "Custom/SS_FinalColorModifier"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "White" {}
        _ColorTint ("Color Tint", color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert finalcolor:ModifyColor

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _ColorTint;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }

        void ModifyColor(Input IN, SurfaceOutput o, inout fixed4 color)
        {
            color *= _ColorTint;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
