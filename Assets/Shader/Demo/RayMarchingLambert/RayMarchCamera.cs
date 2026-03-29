using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.Rendering.PostProcessing.HableCurve;

[RequireComponent(typeof(Camera))]
[ExecuteInEditMode]
public class RayMarchCamera : SceneViewFilter
{
    [SerializeField]
    private Shader _shader;

    public Material _raymarchMaterial
    {
        get
        {
            if (!_raymarchMat && _shader)
            {
                _raymarchMat = new Material(_shader);
                _raymarchMat.hideFlags = HideFlags.HideAndDontSave;
            }
            return _raymarchMat;
        }
    }

    private Material _raymarchMat;

    public Camera _camera
    {
        get
        {
            if(!_cam)
            {
                _cam = GetComponent<Camera>();
            }
            return _cam;
        }
    }

    private Camera _cam;
    
    public float _maxDistance;

    [Header("GroundColor")]
    public Color _GroundColor;
    // public Gradient _SphereGradient;
    // private Color[] _SphereColor = new Color[8];
    [Range(0, 4)]
    public float _ColorIntensity;

    [Header("Directional Light")]
    public Transform _directionalLight;
    public Color _LightCol;
    public float _LightIntensity;

    [Header("SDF")]
    [Range(1, 300)]
    public int _MaxIteration;
    [Range(0.001f, 0.1f)]
    public float _Accuracy;

    [Header("Spheres(Pos,Color,Scale)")]
    public Transform[] _spheres;
    public float _sphereSmooth;
    // public float _degreeRotate;


    [Header("Shadow")]
    [Range(0,4)]
    public float _ShadowIntensity;
    public Vector2 _ShadowDistance;
    [Range(1, 128)]
    public float _ShadowPenumbra;

    [Header("AO")]
    [Range(0.01f, 10.0f)]
    public float _AoStepSize;
    [Range(0.0f, 1.0f)]
    public float _AoItensity;
    [Range (1,5)]
    public int _AoIterations;

    // reflect
    [Header("Reflect")]
    [Range(0, 2)]  // 没有反射，反射次数
    public int _ReflectionCount;
    [Range(0, 1)]    
    public float _ReflectionIntensity;
    [Range(0, 1)]
    public float _EnvReflIntensity;
    public Cubemap _ReflectionCube;

    Vector4[] Rigis; // pos scale
    Vector4[] Colors; //color.rgb
    private void Start()
    {
        Rigis = new Vector4[_spheres.Length]; // 创建同等多个Vector4用于存储数据
        Colors = new Vector4[_spheres.Length]; // 创建同等多个数值存储颜色
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if(!_raymarchMaterial)
        {
            Graphics.Blit(source, destination);
            return;
        }

        for(int i=0; i< _spheres.Length; i++)
        {
            // gradients颜色赋值
            // _SphereColor[i] = _SphereGradient.Evaluate((1f / 8) * i);
            Rigis[i] = new Vector4(_spheres[i].position.x, _spheres[i].position.y, _spheres[i].position.z, _spheres[i].localScale.x);
            Colors[i] = new Vector4(_spheres[i].rotation.x, _spheres[i].rotation.y, _spheres[i].rotation.z, 0);
        }

        // _raymarchMaterial.SetVector("_CamWorldSpace", _camera.transform.position);
        _raymarchMaterial.SetMatrix("_CamFrustum", CamFrustum(_camera));
        _raymarchMaterial.SetMatrix("_CamToWorld", _camera.cameraToWorldMatrix);
        _raymarchMaterial.SetFloat("_maxDistance", _maxDistance);
        _raymarchMaterial.SetInt("_MaxIteration", _MaxIteration);
        _raymarchMaterial.SetFloat("_Accuracy", _Accuracy);

        // color
        _raymarchMaterial.SetColor("_GroundColor", _GroundColor);
        _raymarchMaterial.SetFloat("_ColorIntensity", _ColorIntensity);
        _raymarchMaterial.SetVectorArray("_SphereColor", Colors);

        _raymarchMaterial.SetColor("_LightCol", _LightCol);

        _raymarchMaterial.SetFloat("_LightIntensity", _LightIntensity);
        _raymarchMaterial.SetFloat("_ShadowIntensity", _ShadowIntensity);
        _raymarchMaterial.SetFloat("_ShadowPenumbra", _ShadowPenumbra);
        _raymarchMaterial.SetVector("_ShadowDistance", _ShadowDistance);
        _raymarchMaterial.SetVector("_LightDir", _directionalLight ? _directionalLight.forward : Vector3.down);

        _raymarchMaterial.SetFloat("_AoStepSize", _AoStepSize);
        _raymarchMaterial.SetFloat("_AoItensity", _AoItensity);
        _raymarchMaterial.SetInt("_AoIterations", _AoIterations);

        // 塑形
        _raymarchMaterial.SetInt("_spheresNum", _spheres.Length);
        _raymarchMaterial.SetVectorArray("_spheres", Rigis);
        _raymarchMaterial.SetFloat("_sphereSmooth", _sphereSmooth);
        // _raymarchMaterial.SetFloat("_degreeRotate", _degreeRotate);

        _raymarchMaterial.SetInt("_ReflectionCount", _ReflectionCount);
        _raymarchMaterial.SetFloat("_ReflectionIntensity", _ReflectionIntensity);
        _raymarchMaterial.SetFloat("_EnvReflIntensity", _EnvReflIntensity);
        _raymarchMaterial.SetTexture("_ReflectionCube", _ReflectionCube);

        //目的是在destination纹理上绘制一个四边形，并使用_raymarchMaterial的着色器进行渲染

        RenderTexture.active = destination;

        _raymarchMaterial.SetTexture("_MainTex", source);

        // 渲染目标设置为destination，这意味着接下来的渲染操作将会在这个纹理上进行
        GL.PushMatrix();
        // GL.PushMatrix();：保存当前的模型视图矩阵
        GL.LoadOrtho();
        // 加载一个正交投影矩阵，这将设置一个2D渲染环境。
        _raymarchMaterial.SetPass(0);
        // 设置着色器pass，这将决定如何渲染接下来的图形。
        GL.Begin(GL.QUADS);

        // BL
        GL.MultiTexCoord2(0, 0.0f, 0.0f);
        GL.Vertex3(0.0f, 0.0f, 3.0f);  // 最后一个值为索引值

        // BR
        GL.MultiTexCoord2(0, 1.0f, 0.0f);
        GL.Vertex3(1.0f, 0.0f, 2.0f);

        // TR
        GL.MultiTexCoord2(0, 1.0f, 1.0f);
        GL.Vertex3(1.0f, 1.0f, 1.0f);

        // TL
        GL.MultiTexCoord2(0, 0.0f, 1.0f);
        GL.Vertex3(0.0f, 1.0f, 0.0f);

        GL.End();
        GL.PopMatrix();
        // 恢复之前保存的模型视图矩阵。
    }

    private Matrix4x4 CamFrustum(Camera cam)
    {
        Matrix4x4 frustom = Matrix4x4.identity;
        float fov = Mathf.Tan((cam.fieldOfView * 0.5f) * Mathf.Deg2Rad);
        
        Vector3 goUp = Vector3.up * fov;
        Vector3 goRight = Vector3.right * fov * cam.aspect;

        Vector3 TL = (-Vector3.forward - goRight + goUp);
        Vector3 TR = (-Vector3.forward + goRight + goUp);
        Vector3 BR = (-Vector3.forward + goRight - goUp);
        Vector3 BL = (-Vector3.forward - goRight - goUp);
        /*
        https://docs.unity3d.com/ScriptReference/Camera-cameraToWorldMatrix.html
        Note that camera space matches OpenGL convention: camera's forward is the negative Z axis. This is different from Unity's convention, where forward is the positive Z axis.
请注意，相机空间符合 OpenGL 约定：相机的前向是负 Z 轴。这与 Unity 的约定不同，Unity 中向前是 Z 轴正方向。
        */

        frustom.SetRow(0, TL);
        frustom.SetRow(1, TR);
        frustom.SetRow(2, BR);
        frustom.SetRow(3, BL);

        return frustom;
    }

}
