Shader "Samples/SS_Object Cutting"
{
    Properties
    {
        [header(Texture)] [Space(10)]
        [NoScaleOffset] _Albedo ("Albedo", 2D) = "white"
        [NoScaleOffset] _Reflection ("Specular_Smoothness", 2D) = "black" {}
        [NoScaleOffset] _Normal ("Normal", 2D) = "bump" {}
        [NoScaleOffset] _Occulusion ("Ambient Occlusion", 2D) = "white" {}

        [Header(Cutting)] [Space(10)]
        [KeywordEnum(X,Y,Z)] _Direction ("Cutting Direction", Float) = 1
        [Toggle] _Invert ("Invert Direction", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="TransparentCutout" "Queue" = "AlphaTest"}
        Cull Off

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf StandardSpecular addshadow fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        #pragma multi_compile _DIRECTION_X _DIRECTION_Y _DIRECTION_Z

        sampler2D _Albedo;
        float3 _Position;

        struct Input
        {
            float2 uv_Albedo;
            float3 worldPos;
            fixed face : VFACE; // 当渲染的物体为单面模型的时候，会经常表现正反不同的效果
            // VFACE 语义保存着物体表面朝向的信息，在片段着色器的输入结构体中使用；
            // 当正面朝向摄像机的时候返回正值，背面朝向的时候返回负值，这个特性只有当shader model 为3.0以上时才可使用
        };

        sampler2D _Reflection;
        sampler2D _Normal;
        sampler2D _Occulusion;

        fixed _Invert;

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            fixed4 col = tex2D(_Albedo, IN.uv_Albedo);
            o.Albedo = IN.face > 0 ? col.rgb : fixed3(0,0,0);

            // 判断切割方向
            #if _DIRECTION_X
                col.a = step(_Position.x, IN.worldPos.x);
            #elif _DIRECTION_Y
                col.a = step(_Position.y, IN.worldPos.y);
            #else 
                col.a = step(_Position.z, IN.worldPos.z);
            #endif
            // 使用step()函数进行比较，当_Position的分量>worldPos的时候输出为0，反之则为1

            col.a = _Invert? 1-col.a : col.a;

            clip(col.a - 0.001);

            fixed4 reflection = tex2D(_Reflection, IN.uv_Albedo);
            o.Specular = IN.face > 0 ? reflection.rgb : fixed3(0,0,0);
            o.Smoothness = IN.face>0 ? reflection.a : 0;

            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Albedo));

            o.Occlusion = tex2D(_Occulusion, IN.uv_Albedo);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
