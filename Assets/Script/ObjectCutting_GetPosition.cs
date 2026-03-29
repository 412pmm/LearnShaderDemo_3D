using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ObjectCutting_GetPosition : MonoBehaviour
{
    public GameObject CuttingPosition;
    private Material Material;
    private Vector3 Center = new Vector3(0, 0, 0);

    // Start is called before the first frame update
    void Start()
    {
        // 获取当前物体材质
        Material = this.GetComponent<Renderer>().sharedMaterial;
    }

    // Update is called once per frame
    void Update()
    {
        if(CuttingPosition)
        {
            // 获取 Cutting Position坐标并传递给 Shader
            Material.SetVector("_Position", CuttingPosition.transform.position);
        }
        else
        {
            Material.SetVector("_Positon", Center);
        }
    }
}
