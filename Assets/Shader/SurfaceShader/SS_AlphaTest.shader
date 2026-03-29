Shader "Custom/SS_AlphaTest"
{
    Properties
    {
        _AlphaTest ("Alpha Test", Range(0,1)) = 0
        _MainTex ("Albedo", 2D) = "white" {}
    }
    SubShader
    {
        Tags {"Queue" = "AlphaTest"}

        CGPROGRAM
        
        #pragma surface surf Lambert alphatest:_AlphaTest addshadow

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
