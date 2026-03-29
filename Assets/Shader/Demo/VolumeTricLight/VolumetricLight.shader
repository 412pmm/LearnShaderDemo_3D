Shader "Custom/VolumetricLight"
{
    Properties
    {
    }
    SubShader
    {
        // 光束渲染（体积光），————透明，添加体积雾
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="true"}
        LOD 100

        Pass
        {
            // 关闭深度写入
            zwrite Off
            blend SrcAlpha One
            ColorMask rgb
            // 开启RGB通道，关闭Alpha通道

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // make fog work
            #pragma multi_compile_fog
            // 生成雾
            #pragma multi_compile __ USE_COOKLE
            // 编译shader时生成多个不同的变体，其中包含了使用COOKIE的选项。
            #pragma multi_compile VOLUMETRIC_LIGHT_QUALITY_LOW VOLUMETRIC_LIGHT_QUALITY_MIDDLE VOLUMETRIC_LIGHT_QUALITY_HIGH
            // 在编译时同时生成三种不同质量等级的体积光。

            #include "UnityCG.cginc"

            #if VOLUMETRIC_LIGHT_QUALITY_LOW
                #define RAY_STEP 16
            #elif VOLUMETRIC_LIGHT_QUALITY_MIDDLE
                #define RAY_STEP 32
            #elif VOLUMETRIC_LIGHT_QUALITY_HIGH
                #define RAY_STEP 64
            #endif

            struct appdata
            {
                float4 vertex : POSITION;
                float3 color : COLOR;
            };

            struct v2f
            {
                UNITY_FOG_COORDS(0)
                float4 vertex : SV_POSITION;
                float4 viewPos : TEXCOORD1;
                float4 viewCamPos : TEXCOORD2;
                float3 vcol : COLOR;
            };

            uniform float4 internalWolrdLightColor;
            uniform float4 internalWorldLightPos;
            
            sampler2D internalShadowMap;
            #ifdef USE_COOKLE
            sampler2D internalCookie;
            #endif

            float4x4 internalWorldLightVP;
            float4x4 internalWorldLightMV;

            float4 internalProjectionParams;

            float4 m_InternalLightPosID;

            float4 _phaseParams;

            float d;

            sampler3D _noise3d;
            float m_noise_speed;

            // 将裁剪空间的Z坐标转换为摄像机空间Z坐标
            float LinearLightEyeDepth(float z)
            {
                // 参数 w以及常量0.01分别是我们之前设置深度摄像机的远近裁剪距离
                float oz = (-z*(1/internalProjectionParams.w - 0.01) + 1/internalProjectionParams.w + 0.01) / 2;
                return oz;
            }

            // Henyey-Greenstein函数 计算光源散射,计算光照强度
            // 参数为 定点视线与光源方向的点积（具体表现为逆光方向上散射强度较大） 和 可控参数g（光的散射系数）——g越大散射越少，光线越亮
            float hg(float a, float g)
            {
                float g2 = g*g;
                return (1-g2)/(4*3.1415*pow(1+g2-2*g*(a), 1.5));
            }

            float phase(float a){
                float hgBlend = hg(a, _phaseParams.x);
                return hgBlend * _phaseParams.w;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                UNITY_TRANSFER_FOG(o,o.vertex);

                o.viewPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1));
                o.viewCamPos = float4(_WorldSpaceCameraPos.xyz, 1);

                o.vcol = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float delta = 2.0/64;
                float col = 0;

                // 起始点坐标确定
                float4 beginPjPos = mul(internalWorldLightMV, i.viewPos);
                beginPjPos = mul(internalWorldLightVP, beginPjPos);
                beginPjPos /= beginPjPos.w;

                float4 pjCamPos = mul(internalWorldLightMV, i.viewCamPos);
                pjCamPos = mul(internalWorldLightVP, pjCamPos);
                pjCamPos /= pjCamPos.w;

                float3 pjViewDir = normalize(beginPjPos.xyz - pjCamPos.xyz);

                float4 pjLightPos = mul(internalWorldLightMV, internalWorldLightPos);
                pjLightPos = mul(internalWorldLightVP, pjLightPos);

                float cosAngle = dot(pjViewDir, pjLightPos.xyz);
                float phaseVal = phase(cosAngle);

                float speedShape = _Time.y * m_noise_speed;

                // 
                for(float k=0; k<64; k++){
                    float4 curpos = beginPjPos;
                    float3 vdir = pjViewDir.xyz*k*delta;
                    curpos.xyz += vdir;

                    // 传入负值得到正值
                    half cdep = LinearLightEyeDepth(-curpos.z);  // 转换为摄像机空间下的Z坐标
                    curpos = ComputeScreenPos(curpos); // 内置函数——返回屏幕坐标值
                    half2 pjuv = curpos.xy / curpos.w; // 对纹理进行采样的UV计算
                    pjuv.y = 1-pjuv.y;
                    // 从内部阴影贴图internalShadowMap中解码深度信息，得到dep
                    half dep = DecodeFloatRGBA(tex2D(internalShadowMap, pjuv))/internalProjectionParams.w;
                    float shadow = step(cdep, dep) * (1-saturate(cdep*internalProjectionParams.w));

                    col += delta * shadow * phaseVal;

                    float4 uvwShape = curpos + float4(speedShape, speedShape * 0.2, 0, 0);
                    // 从_noise3d纹理中获取shapeNoise，然后计算出noise
                    float4 shapeNoise = tex3Dlod(_noise3d, uvwShape);
                    float noise = shapeNoise.r * d;
                    col *= exp(-noise * cdep * internalProjectionParams.w);
                }

                return fixed4(col,col,col,1);
            }
            ENDCG
        }
    }
}
