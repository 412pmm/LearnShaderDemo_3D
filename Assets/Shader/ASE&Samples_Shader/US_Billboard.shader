Shader "Samples/US_Billboard"
{
    Properties
    {
        [NoScaleOffset]_MainTex ("Texture", 2D) = "white" {}
        _Tint ("Tine", Color) = (1,1,1,1)

        [KeywordEnum(Spherical, Cylindrical)] _Type ("Type", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "DisableBatching"="True" } 
        // 不实现面的批处理，以防止点的位置计算错误
        LOD 100

        Blend OneMinusDstColor One
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature _TYPE_SPHERICAL _TYPE_CYLINDRICAL

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            fixed4 _Tint;

            v2f vert (appdata v)
            {
                v2f o;
                // 计算面片朝向摄像机的前向方向
                float3 forward = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)).xyz;
                // 使用空间变换矩阵将摄像机从世界空间变换到模型空间

                // 判断Billboard类型
                #if _TYPE_CYLINDRICAL
                forward.y = 0;
                #endif

                forward = normalize(forward);

                float3 up = abs(forward.y) > 0.999 ? float3(0,0,1) : float3(0,1,0);
                // 保证叉乘有效，摄像机视角不出现正上或者正下方

                float3 right = normalize(cross(forward, up));
                // 利用一个临时的向上的向量计算向右的向量
                up = normalize(cross(right, forward));
                // 利用计算出的向右向量重新计算向上的向量

                float3 vertex = v.vertex.x * right + v.vertex.y * up;
                // 因为面片没有厚度可以不用计算 v.vertex.z * forward

                o.vertex = UnityObjectToClipPos(vertex);
                // 模型点坐标从模型空间到裁剪空间
                o.uv = v.uv;


                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv) * _Tint;
            }
            ENDCG
        }
    }
}
