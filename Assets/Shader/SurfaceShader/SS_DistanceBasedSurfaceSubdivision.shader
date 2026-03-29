Shader "Custom/SS_DistanceBasedSurfaceSubdivision"
{
    Properties
    {
        _MainTex ("Main Tex", 2D) = "white" {}

        _MinDistance ("Min Distance", Range(0, 50)) = 10
        _MaxDistance ("Max Distance", Range(0, 50)) = 25
        _Tessellation ("Tessellation", Range(1, 32)) = 1  // 当距离小于min distance 细分等级为 tessellation
        _HeightMap ("Height Map", 2D) = "gray" {} 
        _Height ("Height", Range(0, 1.0)) = 0 // 模型偏移距离

        _NormalMap ("Normal Map", 2D) = "bump" {}
        _Bumpiness ("Bumpiness", Range(0,1)) = 0.5 // 发现凹凸强度
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert tessellate:tessellateDistance vertex:height addshadow
        #include "Tessellation.cginc"
        // 曲面细分函数 tessellation 
        // 定点修改函数 height 
        // 顶点位置有修改，添加修正模型投影的阴影

        half _MinDistance;
        half _MaxDistance;
        half _Tessellation;

        float4 tessellateDistance (appdata_full v0, appdata_full v1, appdata_full v2)
        {
            return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, _MinDistance, _MaxDistance, _Tessellation);
        }

        sampler2D _HeightMap;
        float4 _HeightMap_ST;
        fixed _Height;

        void height (inout appdata_full v)
        {
            float2 texcoord = TRANSFORM_TEX(v.texcoord, _HeightMap);// 计算高度图的纹理坐标，
            float h = tex2Dlod(_HeightMap, float4(texcoord, 0, 0)).r * _Height; 
            // 对高度图进行采样  tex2D()只能在片段着色器使用，不能在顶点着色器使用，tex2Dlod均可使用
            v.vertex.xyz += v.normal * h;
        }

        struct Input{
            float2 uv_MainTex;
            float2 uv_NormalMap;
        };

        sampler2D _MainTex;
        sampler2D _NormalMap;
        fixed _Bumpiness;

        void surf (Input IN, inout SurfaceOutput o)
        {
            half4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;

            float3 n = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            n.xy *= fixed2(_Bumpiness, _Bumpiness);
            o.Normal = n;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
