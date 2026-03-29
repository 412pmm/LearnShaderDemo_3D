Shader "Custom/SS_BlendTransparent"
{
    Properties
    {
        _Color ("Color (RGB-A)", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
    }
    SubShader
    {
        Tags {"Queue" = "Transparent"}

        CGPROGRAM
        
        #pragma surface surf Lambert alpha

        sampler2D _MainTex;
        fixed4 _Color;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
