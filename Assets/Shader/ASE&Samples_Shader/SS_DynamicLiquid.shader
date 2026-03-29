Shader "Samples/SS_DynamicLiquid"
{
    Properties
    {
        //   液体颜色
        _Color ("Color", Color) = (1,1,1,1)
        _Specular ("Specular_Smoothness", Color) = (0,0,0,0)
        
        _Level ("Liquid Level", float) = 0
        _RippleSpeed ("Ripple Speed", float) = 1
        _RippleHeight ("Ripple Height", float) = 0.005

        [KeywordEnum(X,Z)] _Direction("Ripple Direction", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Blend DstColor SrcColor
        ZWrite Off

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf StandardSpecular noshadow

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        #pragma shader_feature _DIRECTION_X _DIRECTION_Z

        struct Input
        {
            float3 worldPos;
        };

        fixed4 _Color;
        fixed4 _Specular;
        half _Level;
        half _RippleSpeed;
        half _RippleHeight;

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            // 液面
            float3 pivot = mul(unity_ObjectToWorld, float4(0,0,0,1)); // 模型中心点
            float3 liquid = pivot.y - IN.worldPos.y + _Level*0.01; // 在中心点上面的为负，下面为正

            float3 ripple = sin(_Time.y * _RippleSpeed) * _RippleHeight * IN.worldPos;

            #if _DIRECTION_X
            liquid += ripple.x;
            #else
            liquid += ripple.z;
            #endif

            // 像素剔除
            liquid = step(0, liquid);
            clip(liquid - 0.001);

            o.Albedo = _Color.rgb;
            o.Specular = _Specular.rgb;
            o.Smoothness = _Specular.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
