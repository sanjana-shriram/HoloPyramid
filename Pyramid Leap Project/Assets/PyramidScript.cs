using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[RequireComponent(typeof(Camera))]

public class PyramidScript : MonoBehaviour
{
    public Camera CameraLeft;
    public Camera CameraRight;

    public Shader CustomShader;

    private RenderTexture m_renderTextureLeft;
    private RenderTexture m_renderTextureRight;

    [Range(-1.0f, 1.0f)]
    public float Strength = 0.0f;

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

        m_renderTextureLeft = CreateRenderTextureForCamera(CameraLeft);
        m_renderTextureRight = CreateRenderTextureForCamera(CameraRight);

        m_material.SetTexture("_CameraLeftTex", m_renderTextureLeft);
        m_material.SetTexture("_CameraRightTex", m_renderTextureRight);

        // Please edit this value to the size of your screen!!!
        Screen.SetResolution(2560, 1600, true);

        Debug.Log($"width={Camera.main.pixelWidth} x height={Camera.main.pixelHeight}");
    }

    // Update is called once per frame
    void Update()
    {
        m_material.SetFloat("_Strength", 1.0f + Strength);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (m_material == null) return;

        Graphics.Blit(source, destination, m_material);
    }
}
