using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VolumetricLight : MonoBehaviour
{
    public enum Quality
    {
        High,
        Middle,
        Low,
    }

    /// <summary>
    /// 是否是平行光
    /// </summary>
    public bool directional
    {
        get { return this.m_Directional; }
        set { ResetDirectional(value); }
    }

    /// <summary>
    /// 阴影Bias
    /// </summary>
    public float shadowBias
    {
        get { return this.m_ShadowBias; }
        set { ResetShadowBias(value); }
    }

    /// <summary>
    /// 物体密度
    /// </summary>
    public float D
    {
        get { return this.D; }
        set { D = value; }
    }

    /// <summary>
    /// 渲染范围
    /// </summary>
    public float range
    {
        get { return this.m_Range; }
        set { ResetRange(value); }
    }

    /// <summary>
    /// 灯光夹角
    /// </summary>
    public float angle
    {
        get { return this.m_Angle; }
        set { ResetAngle(value); }
    }

    /// <summary>
    /// 跟光区域大小
    /// </summary>
    public float size
    {
        get { return this.m_Size; }
        set { ResetSize(value); }
    }

    public float aspect
    {
        get { return this.m_Aspect; }
        set { ResetAspect(value); }
    }

    /// <summary>
    /// 灯光颜色
    /// </summary>
    public Color color
    {
        get { return this.m_Color; }
        set { ResetColor(value, m_Intensity); }
    }

    /// <summary>
    /// 灯光强度
    /// </summary>
    public float intensity
    {
        get { return m_Intensity; }
        set { ResetColor(m_Color, value); }
    }

    public Texture2D cookie
    {
        get { return m_Cookie; }
        set { ResetCookie(value); }
    }

    public Texture3D noise3d
    {
        get { return _noise3; }
        set { ResetNoise3D(value); }
    }

    public LayerMask cullingMask
    {
        get { return m_CullingMask; }
        set { ResetCullingMask(value); }
    }

    public Quality quality
    {
        get { return this.m_Quality; }
    }

    public bool vertexBased
    {
        get { return m_VertexBased; }
    }

    public Vector4 _PhaseParams
    {
        get { return _phaseParams; }
        set { _phaseParams = value;}
    }

    public float _NoiseSpeed
    {
        get { return _noiseSpeed; }
        set { _noiseSpeed = value; }
    }

    [SerializeField]  // 强制 Unity 对私有字段进行序列化。
    private bool m_Directional;
    [SerializeField]
    private float m_ShadowBias;
    [SerializeField]
    private float m_Range;
    [SerializeField]
    private float m_Angle;
    [SerializeField]
    private float m_Size;
    [SerializeField]
    private float m_Aspect;
    [SerializeField]
    private Color m_Color = new Color32(255, 247, 216, 255);
    [SerializeField]
    private float m_Intensity;
    [SerializeField]
    private Texture2D m_Cookie;
    [SerializeField]
    private LayerMask m_CullingMask;
    [SerializeField]
    private Quality m_Quality;
    [SerializeField]
    private bool m_VertexBased;
    [SerializeField]
    private float m_Subdivision = 0.7f;
    [SerializeField]
    private Vector4 _phaseParams;

    [SerializeField]
    private Texture3D _noise3;
    [SerializeField]
    private float d;

    [SerializeField]
    private float _noiseSpeed;

    //private VolumetricLightDepthCamera m_DepthCamera;

    private int m_InternalWorldLightVPID;
    private int m_InternalWorldLightMVID;
    private int m_InternalProjectionParams;
    private int m_InternalBiasID;
    private int m_InternalCookieID;
    private int m_InternalLightPosID;
    private int m_InternalLightPosID2;
    private int m_InternalLightColorID;
    private int m_PhaseParamsPosID;
    private int m_DID;
    private int m_NoiseDID;
    private int m_NoiseSpeedDID;

    private Matrix4x4 m_Projection;
    private Matrix4x4 m_WorldToCam;
    private Vector4 m_LightPos;

    private bool m_IsInitialized;

    // Start is called before the first frame update
    void Start()
    {
        //m_DepthCamera = new VolumetricLightDepthCamera();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void ResetDirectional(bool directional)
    {
        if (m_Directional == directional) { return; }
        m_Directional = directional;
        
    }

    private void ResetShadowBias(float shadowBias)
    {
        if (m_ShadowBias == shadowBias) { return; }
        m_ShadowBias = shadowBias;
        
    }

    private void ResetRange(float range)
    {
        if(m_Range == range) { return; }
        m_Range = range;

    }

    private void ResetAngle(float angle)
    {
        if(m_Angle == angle) { return; }
        m_Angle = angle;
        
    }

    private void ResetSize(float size)
    {
        if(m_Size == size) { return; }
        m_Size = size;

    }

    private void ResetAspect(float aspect)
    {
        if(m_Aspect == aspect) { return; }
        m_Aspect = aspect;

    }

    private void ResetColor(Color color, float intensity)
    {
        if (m_Color == color && m_Intensity == intensity ) { return; }
        m_Color = color;
        m_Intensity = intensity;

    }

    private void ResetCookie(Texture2D cookie)
    {
        if(m_Cookie == cookie) { return; }
        if (m_VertexBased) return;
        m_Cookie = cookie;

    }

    private void ResetNoise3D(Texture3D noise3d)
    {
        if(_noise3 == noise3d) { return; }
        _noise3 = noise3d;

    }

    private void ResetCullingMask(LayerMask cullingMask)
    {
        if(m_CullingMask == cullingMask) { return; }
        m_CullingMask = cullingMask;

    }

    private void ResetQuality(bool low, bool middle, bool high)
    {
        if (low)
            Shader.EnableKeyword("VOLUMETRIC_LIGHT_QUALITY_LOW");
        else
            Shader.DisableKeyword("VOLUMETRIC_LIGHT_QUALITY_LOW");
        if (middle)
            Shader.EnableKeyword("VOLUMETRIC_LIGHT_QUALITY_MIDDLE");
        else
            Shader.DisableKeyword("VOLUMETRIC_LIGHT_QUALITY_MIDDLE");
        if (high)
            Shader.EnableKeyword("VOLUMETRIC_LIGHT_QUALITY_HIGH");
        else
            Shader.DisableKeyword("VOLUMETRIC_LIGHT_QUALITY_HIGH");
    }
}
