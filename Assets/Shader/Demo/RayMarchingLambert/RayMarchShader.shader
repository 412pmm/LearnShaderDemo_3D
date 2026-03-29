Shader "Custom/RayMarchShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            #include "DistanceFunctions.cginc"

            sampler2D _MainTex;
            // uniform float4 _CamWorldSpace; // 世界空间相机位置
            uniform float4x4 _CamFrustum, _CamToWorld; // 相机视锥体

            // SDF setup
            uniform int _MaxIteration;
            uniform float _Accuracy;
            uniform float _maxDistance;
            // SDF
            //uniform float3 _modInterval;
            //uniform float4 _sphere1, _sphere2;
            //uniform float4 _box1;
            //uniform float _box1round;
            //uniform float _boxSphereSmooth, _sphereIntersectSmooth;
            //------------------------
            uniform int _spheresNum;
            uniform float4 _spheres[100]; //pos 和 scale
            uniform float _sphereSmooth;
            uniform float3 _worldPos;

            // Light
            uniform float3 _LightDir;
            uniform float _LightIntensity;
            uniform float3 _LightCol;
            
            // diffuse Color
            uniform fixed4 _GroundColor;
            uniform fixed4 _SphereColor[100]; //颜色
            uniform float _ColorIntensity;

            // 深度图 (场景中已有物体)
            uniform sampler2D _CameraDepthTexture;

            // shadow
            uniform float2 _ShadowDistance;
            uniform float _ShadowIntensity, _ShadowPenumbra;

            // AO 
            uniform float _AoStepSize, _AoItensity;
            uniform int _AoIterations;

            // reflect
            uniform int _ReflectionCount;
            uniform float _ReflectionIntensity;
            uniform float _EnvReflIntensity;
            uniform samplerCUBE _ReflectionCube;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 ray : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                half index = v.vertex.z; // 为什么拿点的 z 坐标当 index ？？
                v.vertex.z = 0; // z坐标为0
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                // ??? 确定射线方向（在片元着色器中插值计算）
                o.ray = _CamFrustum[(int)index].xyz; // index = v.vertex.z
                o.ray /= abs(o.ray.z); 
                o.ray = mul(_CamToWorld, o.ray); // 切换到世界空间

                return o;
            }

            //float BoxSphere(float3 p)
            //{
            //    float Sphere1 = sdSphere(p - _sphere1.xyz, _sphere1.w);
            //    float Box1 = sdRoundBox(p - _box1.xyz, _box1.www, _box1round);
            //    float combine1 = opSS(Sphere1, Box1, _boxSphereSmooth);
            //    float Sphere2 = sdSphere(p - _sphere2.xyz, _sphere2.w);
            //    float combine2 = opIS(Sphere2, combine1, _sphereIntersectSmooth);
            //    return combine2;
            //}

            float3 RotateY(float3 v, float degree)
            {
                float rad = 0.0174532925 * degree;
                float cosY = cos(rad);
                float sinY = sin(rad);
                return float3(cosY * v.x - sinY * v.z, v.y, sinY * v.x + cosY * v.z);

            }

            float worldSpaceSDF(float3 pos, float3 worldPos)
            {
                return length(pos - worldPos);
            }

            // float4(color.rgb, distance)
            float4 distanceField(float3 p)
            {
                //重复
                //float modX = pMod1(p.x, _modInterval.x);
                //float modY = pMod1(p.y, _modInterval.y);
                //float modZ = pMod1(p.z, _modInterval.z);

                // 固定角度旋转的融球
                //float4 ground = float4(_GroundColor.rgb ,sdPlane(p, float4(0,1,0,0)));

                //float4 sphere = float4(_SphereColor[0].rgb, sdSphere(p - _sphere.xyz, _sphere.w));
                //for (int i=1; i<8; i++)
                //{
                //    float4 sphereAdd = float4(_SphereColor[i].rgb, sdSphere(RotateY(p, _degreeRotate * i) - _sphere.xyz, _sphere.w));
                //    sphere = opUS(sphere, sphereAdd, _sphereSmooth);
                //}
                //return opUS(sphere, ground, _sphereSmooth);

                float4 ground = float4(_GroundColor.rgb ,sdPlane(p, float4(0,1,0,0)));
                float4 sphere = float4(_SphereColor[0].rgb, sdSphere(p-_spheres[0].xyz, _spheres[0].w));
                for(int i=1; i<_spheresNum; i++)
                {
                    float4 sphere1 = float4(_SphereColor[i].rgb, sdSphere(p-_spheres[i].xyz, _spheres[i].w));
                    sphere = opUS(sphere, sphere1, _sphereSmooth);
                }

                float4 shape1 = opUS(sphere, ground, _sphereSmooth);
                // return shape1;

                float worldSDF = worldSpaceSDF(p, _worldPos);
                float opUSShape = smin(worldSDF, shape1.w,  _sphereSmooth);

                return float4(shape1.rgb, opUSShape);
                // return worldShape;
            }

            float3 getNormal(float3 p)
            {
                const float2 offset = float2(0.001, 0.0);
                float3 n = float3(
                    distanceField(p + offset.xyy).w - distanceField(p - offset.xyy).w,
                    distanceField(p + offset.yxy).w - distanceField(p - offset.yxy).w,
                    distanceField(p + offset.yyx).w - distanceField(p - offset.yyx).w
                );
                return normalize(n);
            }

            float hardShadow(float3 ro, float3 rd, float mint, float maxt)
            {
                for(float t = mint; t<maxt;)
                {
                    float h = distanceField(ro + rd*t).w;
                    if(h<0.001)
                    {
                        return 0.0; // 光线在这个位置遇到了物体，因此该点位于阴影中，函数返回0.0，表示完全不亮。
                    }
                    t += h;
                }
                return 1.0; // 循环结束都没有找到遮挡物，那么该点不在阴影中，函数返回1.0，表示完全亮。
            }
            //只考虑了光线是否被遮挡，而没有考虑遮挡的程度，所以产生的阴影边缘是非常硬的，没有过渡区域。

            float softShadow(float3 ro, float3 rd, float mint, float maxt, float k)
            {
                float result = 1.0;
                for(float t = mint; t<maxt;)
                {
                    float h = distanceField(ro + rd*t).w;
                    if(h<0.001)
                    {
                        return 0.0; // 光线在这个位置遇到了物体，因此该点位于阴影中，函数返回0.0，表示完全不亮。
                    }
                    result = min(result, k*h/t); // 最大为1，完全处于光照下
                    t += h;
                }
                return result; // 循环结束都没有找到遮挡物，那么该点不在阴影中，函数返回1.0，表示完全亮。
            }

            // 环境光
            float AmbientOcclusion(float3 p, float3 n)
            {
                float ao = 0.0;
                float step = _AoStepSize;
                float dist;
                for(int i=1; i<=_AoIterations;i++)
                {
                    dist = step * i;
                    ao += max(0.0, (dist - distanceField(p + n * dist).w)/ dist);
                }
                // 遮蔽判断：
                // 使用 distanceField 函数来计算点 p 在当前迭代距离上的最近表面距离。
                // 如果这个距离小于迭代步长 dist，则意味着有遮蔽发生。
                return (1.0 - ao * _AoItensity);
            }

            float3 Shading(float3 p, float n, fixed3 c) // p 为 hitPosition
            {
                float3 result;
                // diffuse
                float3 color = c.rgb * _ColorIntensity;
                // 直射光
                float3 light = (_LightCol * dot(-_LightDir, n) * 0.5 + 0.5) * _LightIntensity;

                // shadows
                float shadow = softShadow(p, -_LightDir, _ShadowDistance.x, _ShadowDistance.y, _ShadowPenumbra) * 0.5 + 0.5;
                shadow = max(0.0, pow(shadow, _ShadowIntensity));

                // ao
                float ao = AmbientOcclusion(p, n);

                result = shadow * light * color * ao;

                return result;
            }

            bool raymarching(float3 ro, float3 rd, float depth, float maxDistance, int maxIteration, inout float3 p, inout fixed3 dColor)
            {
                bool hit;
                float t = 0;
                
                for(int i=0; i<maxIteration; i++)
                {
                    if(t > maxDistance || t >= depth)
                    {
                        // 环境
                        hit = false;
                        break;
                    }
                    p = ro + rd * t;
                    // 检查是否击中
                    float4 d = distanceField(p);
                    if(d.w < _Accuracy)
                    {
                        // 碰到了再融合？？？
                        dColor = d.rgb;
                        hit = true;
                        break;
                    }
                    t += d.w;
                }
                return hit;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float depth = LinearEyeDepth(tex2D(_CameraDepthTexture, i.uv).r);
                depth *= length(i.ray); //该点在世界坐标中的实际距离

                fixed3 col = tex2D(_MainTex, i.uv);

                float3 rayDirection = normalize(i.ray.xyz); // 在片元着色器中利用插值进行计算
                float3 rayOrigin = _WorldSpaceCameraPos;

                // 重建世界坐标系
                _worldPos = rayOrigin + depth * rayDirection;
                // return fixed4(_worldPos,1);

                fixed4 result;
                float3 hitPosition;
                fixed3 dColor;

                bool hit = raymarching(rayOrigin, rayDirection, depth, _maxDistance, _MaxIteration, hitPosition, dColor);

                if(hit){
                    // shading
                    float3 n = getNormal(hitPosition);
                    float3 s = Shading(hitPosition, n, dColor);
                    result = fixed4(s,1);
                    result += fixed4(texCUBE(_ReflectionCube, n).rgb * _EnvReflIntensity * _ReflectionIntensity, 0);

                    // Reflection
                    if (_ReflectionCount > 0)
                    {
                        rayDirection = normalize(reflect(rayDirection, n));
                        rayOrigin = hitPosition + (rayDirection * 0.01);
                        hit = raymarching(rayOrigin, rayDirection, _maxDistance, _maxDistance * 0.5, _MaxIteration / 2, hitPosition, dColor);
                        if(hit)
                        {
                            float3 n = getNormal(hitPosition);
                            float3 s = Shading(hitPosition, n, dColor);
                            result += fixed4(s * _ReflectionIntensity, 0);
                            if(_ReflectionCount > 1)
                            {
                                rayDirection = normalize(reflect(rayDirection, n));
                                rayOrigin = hitPosition + (rayDirection * 0.01);
                                hit = raymarching(rayOrigin, rayDirection, _maxDistance, _maxDistance * 0.25, _MaxIteration / 4, hitPosition, dColor);
                                if(hit)
                                {
                                    float3 n = getNormal(hitPosition);
                                    float3 s = Shading(hitPosition, n, dColor);
                                    result += fixed4(s * _ReflectionIntensity * 0.5, 0);
                                }
                            }
                        }
                    }
                }
                else{
                    result = fixed4(0,0,0,0);
                }

                return fixed4(col * (1.0 - result.w) + result.xyz * result.w ,1.0);
            }
            ENDCG
        }
    }
}
