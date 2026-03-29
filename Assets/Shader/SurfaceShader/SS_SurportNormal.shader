Shader "Custom/SS_SurportNormal"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _Normal ("Normal Map", 2D) = "bump" {}
        _Bumpiness ("Bumpiness", Range(0,1)) = 0
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert 
        // 编译指令，surface函数surf，光照模式Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Normal;
        };

        fixed4 _Color;
        sampler2D _Normal;
        fixed _Bumpiness;

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

            // 采样法线贴图并解包
            // 打包：将（-1，1）映射到（0，1），解包相反
            fixed3 n = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
            n *= float3(_Bumpiness, _Bumpiness, 1);
            o.Normal = n;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
