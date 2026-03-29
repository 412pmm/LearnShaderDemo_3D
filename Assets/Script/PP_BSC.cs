using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable] // 使得脚本能够序列化进行
[PostProcess(typeof(BSCRenderer), PostProcessEvent.AfterStack, "Custom/PP_BSC")]
// PostProcess()函数告诉“Unity”接下来要用一个名称为“PP_BSC”的类，也就是脚本的文件名称，后期处理的所有属性
// 第一个参数，typeof(BSCRenderer)用于关联脚本第二个模块——渲染模块
// 第二个参数 PostProcessEvent用于确认后期处理操作所应用的对象类型或所处时间阶段

// 设置模块
// 用于保存后期处理所有属性的类，类的名称一定要和C#文件名一样
// sealed 修饰符可阻止其他类继承自该类
public sealed class PP_BSC : PostProcessEffectSettings
{
    [Range(0f, 2f), Tooltip("Brightness effect intensity.")] // 添加一个tooltip属性可以在instpector面板上提示注释
    public FloatParameter Brightness = new FloatParameter { value = 1f };

    [Range(0f, 2f), Tooltip("Saturation effect intensity.")]
    public FloatParameter Saturation = new FloatParameter { value = 1f };

    [Range(0f, 2f), Tooltip("Contrast effect intensity.")]
    public FloatParameter Contrast = new FloatParameter { value = 1f };
}

// 渲染模块
public sealed class BSCRenderer : PostProcessEffectRenderer<PP_BSC>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/IES_BSC-HLSL"));
        // 查找后期处理Shader IES_BSC-HLSL ,

        sheet.properties.SetFloat("_Brightness", settings.Brightness);
        sheet.properties.SetFloat("_Saturation", settings.Saturation);
        sheet.properties.SetFloat("_Contrast", settings.Contrast);

        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}