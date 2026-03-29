using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))] // 没有摄像机生成一个摄像机
[ExecuteInEditMode]

public class PP_BrightnessSaturationContrast : MonoBehaviour
{
    // 关联后期处理Shader
    public Shader EffectShader;

    public float Brightness = 1f;
    public float Saturation = 1f;
    public float Contrast = 1f;

    // 后期处理材质
    private Material EffectMaterial;

    // 基于Shader生成Material
    // Start is called before the first frame update
    void Start()
    {
        EffectMaterial = new Material(EffectShader);
    }

    // 调用 Shader 进行后期处理
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // 判断有无关联的Shader文件，有则进行属性传递，没有则不做任何处理
        if(EffectShader)
        {
            // 将脚本中属性传递给Shader
            EffectMaterial.SetFloat("_Brightness", Brightness);
            EffectMaterial.SetFloat("_Saturation", Saturation);
            EffectMaterial.SetFloat("_Contrast", Contrast);

            Graphics.Blit(source, destination, EffectMaterial); 

        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    // Update is called once per frame
    void Update()
    {
        // 对开放参数进行范围控制
        Brightness = Mathf.Clamp(Brightness, 0f, 2f);
        Saturation = Mathf.Clamp(Saturation, 0f, 2f);
        Contrast = Mathf.Clamp(Contrast, 0f, 2f);
    }
}
