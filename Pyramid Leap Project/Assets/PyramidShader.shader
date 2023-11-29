Shader "Custom/PyramidShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _CameraLeftTex ("Texture", 2D) = "white" {}
        _CameraRightTex ("Texture", 2D) = "white" {}
        _Strength ("Float", float) = 0.0
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

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _CameraLeftTex;
            sampler2D _CameraRightTex;

            float _Strength;

            uniform float4 _MainTex_TexelSize;

            fixed4 frag (v2f input) : SV_Target
            {
                int width = _MainTex_TexelSize.z;
                int height = _MainTex_TexelSize.w;

                float2 uv = input.uv;

                fixed4 colorL;
                fixed4 colorR;
                colorR = tex2D(_CameraRightTex, uv + float2(0, 0));
                colorL = tex2D(_CameraLeftTex, uv + float2(0, 0));

                colorR.r /= 2;
                colorR.b *= 2;
                colorR.a = 0.5;
                
                colorL.r *= 2;
                colorL.b /= 2;
                colorL.a = 0.5;

                fixed4 final = (colorR + colorL)/2;
                return _Strength * final;
                // return colorL;
            }
            ENDCG
        }
    }
}
