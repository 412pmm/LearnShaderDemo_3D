Shader "Custom/SS_ExpandAlongNormal"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _Expansion ("Expansion", Range(0, 0.1)) = 0
    }
    SubShader
    {
        CGPROGRAM
        // 添加自定义顶点修改函数vert 
        #pragma surface surf Lambert vertex:vert 
        // 编译指令，surface函数surf，光照模式Lambert

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        fixed4 _Color;
        fixed _Expansion;

        void vert(inout appdata_full v)
        {
            v.vertex.xyz += v.normal * _Expansion;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
