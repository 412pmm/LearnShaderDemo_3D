using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent (typeof(Camera))]
public class PP_NightVision : MonoBehaviour
{
    // 开放属性
    public Shader EffectShader;

    [Header("Basic Properties")]
    // 扭曲
    [Range(-2, 2)] public float Distortion = 0.5f;
    [Range(0.01f, 1)] public float Scale = 0.5f;

    // 亮度，饱和度，对比度
    [Range(-1, 1)] public float Brightness = 0;
    [Range(0, 2)] public float Saturation = 1;
    [Range(0, 2)] public float Contrast = 1;

    public Color Tint = Color.black;

    [Header("Advanced Properties")]
    [Range(0, 10)] public float VignetteFalloff = 1;
    [Range(0, 100)] public float VignetteIntensity = 1;

    public Texture2D Noise;
    [Range(0, 10)] public float NoiseAmount = 1;
    private float RandomValue;

    // 材质, 通过shader生成材质
    private Material currentMaterial;

    Material EffectMaterial
    {
        get
        {
            if(currentMaterial == null)
            {
                currentMaterial = new Material(EffectShader)
                {
                    hideFlags = HideFlags.HideAndDontSave,
                };
            }
            return currentMaterial;
        }
    }

    // 往材质中传递参数
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if(EffectMaterial != null)
        {
            EffectMaterial.SetFloat("_Distortion", Distortion);
            EffectMaterial.SetFloat("_Scale", Scale);
            
            EffectMaterial.SetFloat("_Brightness", Brightness);
            EffectMaterial.SetFloat("_Saturation", Saturation);
            EffectMaterial.SetFloat("_Contrast", Contrast);

            EffectMaterial.SetColor("_Tint", Tint);

            EffectMaterial.SetFloat("_VignetteFalloff", VignetteFalloff);
            EffectMaterial.SetFloat("_VignetteIntensity", VignetteIntensity);

            if(Noise != null)
            {
                EffectMaterial.SetTexture("_Noise", Noise);
                EffectMaterial.SetFloat("_NoiseAmount", NoiseAmount);
                EffectMaterial.SetFloat("_RandomValue", RandomValue);
            }

            Graphics.Blit(source, destination, EffectMaterial);
        }
        else Graphics.Blit(source, destination);
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        RandomValue = Random.Range(-3.14f, 3.14f);
    }
}
