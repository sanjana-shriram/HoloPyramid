using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[RequireComponent(typeof(Camera))]

public class PyramidScript : MonoBehaviour
{
    public Camera FrontCamera;
    public Camera LeftCamera;
    public Camera RightCamera;
    public Camera BackCamera;
    public Shader CustomShader;

    private RenderTexture m_renderTextureFront;
    private RenderTexture m_renderTextureLeft;
    private RenderTexture m_renderTextureRight;
    private RenderTexture m_renderTextureBack;

    private Material m_material;

    private RenderTexture CreateRenderTextureForCamera(Camera cam)
    {
        RenderTexture rt = new RenderTexture(Camera.main.pixelWidth, Camera.main.pixelHeight, 24)
        {
            antiAliasing = 1
        };
        rt.Create();

        cam.targetTexture = rt;
        cam.aspect = GetComponent<Camera>().aspect;

        return rt;
    }

    // Start is called before the first frame update
    void Start()
    {
        if (CustomShader == null) return;

        m_material = new Material(CustomShader);

        m_renderTextureLeft = CreateRenderTextureForCamera(LeftCamera);
        m_renderTextureRight = CreateRenderTextureForCamera(RightCamera);
        m_renderTextureFront = CreateRenderTextureForCamera(FrontCamera);
        m_renderTextureBack = CreateRenderTextureForCamera(BackCamera);

        m_material.SetTexture("_LeftCameraTex", m_renderTextureLeft);
        m_material.SetTexture("_RightCameraTex", m_renderTextureRight);
        m_material.SetTexture("_FrontCameraTex", m_renderTextureFront);
        m_material.SetTexture("_BackCameraTex", m_renderTextureBack);

        // Please edit this value to the size of your screen!!!
        Screen.SetResolution(2560, 1600, true);

        Debug.Log($"width={Camera.main.pixelWidth} x height={Camera.main.pixelHeight}");
    }

    // Update is called once per frame
    void Update()
    {

    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (m_material == null) return;

        Graphics.Blit(source, destination, m_material);
    }


}
