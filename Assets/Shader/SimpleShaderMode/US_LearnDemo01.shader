Shader "Custom/US_LearnDemo01"
{
    Properties
    {
        _MainColor ("MainColor", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag
            
            // struct appdata // 顶点着色器输入
            // {
            //     float4 vertex : POSITION;
            //     float2 uv : TEXCOORD0;
            // };

            // struct v2f // 顶点着色器输出
            // {
            //     float4 position : SV_POSITION;
            //     float2 texcoord : TEXCOORD0; 
            // };
            // 使用文件包含的结构体 appdata_img ,  v2f_img

            fixed4 _MainColor;
            // 声明纹理属性变量以及ST变量
            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            v2f_img vert(appdata_img v)
            {
                v2f_img o;
                o.pos = UnityObjectToClipPos(v.vertex);

                // o.texcoord = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                // 使用包含文件中的宏计算纹理坐标
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag(v2f_img i) : SV_TARGET
            {
                return tex2D(_MainTex, i.uv) * _MainColor;
            }

            ENDCG
        }
    }
}
