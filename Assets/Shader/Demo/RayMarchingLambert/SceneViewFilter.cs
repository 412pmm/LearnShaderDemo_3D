using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

/// <summary>
/// 确保主摄像机和视图场景中的过滤器始终保持同步
/// </summary>

public class SceneViewFilter : MonoBehaviour
{
#if UNITY_EDITOR  // 这个脚本只在Unity编辑器中有效
    bool hasChanged = false;

    public virtual void OnValidate()
    {
        hasChanged = true;
    }
    // OnValidate()是一个回调方法，当脚本被加载或者Inspector窗口中的值被修改时，该方法会被调用

    static SceneViewFilter()
    {
        SceneView.duringSceneGui += CheckMe;
    }
    // 静态构造函数，在加载类或者创建类的实例的时候被调用
    // 将 CheckMe() 方法添加到 SceneView.onSceneGUIDelegate 委托， 每次场景中视图的GUI事件发生时， CheckMe 方法都会被调用

    static void CheckMe(SceneView sv)
    {
        if (Event.current.type != EventType.Layout)
            return;
        if (!Camera.main)
            return;

        // Get a list of everything on the main camera that should be synced.
        SceneViewFilter[] cameraFilters = Camera.main.GetComponents<SceneViewFilter>();
        SceneViewFilter[] sceneFilters = sv.camera.GetComponents<SceneViewFilter>();
        // 获取主摄像机上所有的SceneViewFilter组件，并将它们存储在一个SceneViewFilter类型的数组中

        // Let's see if the lists are different lengths or something like that. 
        // If so, we simply destroy all scene filters and recreate from maincame
        if (cameraFilters.Length != sceneFilters.Length) // 过滤器数量比较
        {
            Recreate(sv);  // 重新创建场景视图中的过滤器
            return;
        }
        for (int i = 0; i < cameraFilters.Length; i++)
        {
            if (cameraFilters[i].GetType() != sceneFilters[i].GetType())  // 比较类型
            {
                Recreate(sv);
                return;
            }
        }

        // Ok, WHICH filters, or their order hasn't changed.
        // Let's copy all settings for any filter that has changed.
        for (int i = 0; i < cameraFilters.Length; i++)
            if (cameraFilters[i].hasChanged || sceneFilters[i].enabled != cameraFilters[i].enabled)
            {
                EditorUtility.CopySerialized(cameraFilters[i], sceneFilters[i]);
                cameraFilters[i].hasChanged = false;
            }
    }

    static void Recreate(SceneView sv)
    {
        SceneViewFilter filter;
        while (filter = sv.camera.GetComponent<SceneViewFilter>())
            DestroyImmediate(filter);  // 先删除场景中所有过滤器

        foreach (SceneViewFilter f in Camera.main.GetComponents<SceneViewFilter>())
        {
            SceneViewFilter newFilter = sv.camera.gameObject.AddComponent(f.GetType()) as SceneViewFilter;
            EditorUtility.CopySerialized(f, newFilter);
            // 复制主摄像机的组件
        }
    }
#endif
}