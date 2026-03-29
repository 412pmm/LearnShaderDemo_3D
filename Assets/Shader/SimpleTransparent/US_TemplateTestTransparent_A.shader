Shader "Custom/US_TemplateTestTransparent_A"
{
    SubShader
    {
        Tags { "Queue" = "Geometry-1" } //设置物体的渲染顺序，最先渲染

        Pass
        {
            //设置模板测试的状态
            Stencil
            {
                Ref 1 // 参照值设置为1
                Comp Always
                Pass Replace  // 参照值写入模板值中
            }

            //禁止绘制任何颜色
            ColorMask 0  // 不需要做渲染，屏幕所有颜色输出
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float4 vert (in float4 vertex : POSITION) : SV_POSITION
            {
                float4 pos = UnityObjectToClipPos(vertex);
                return pos;
            }

            void frag (out fixed4 color : SV_Target)
            {
                color = fixed4(0,0,0,0);
            }
            ENDCG
        }
    }
}
