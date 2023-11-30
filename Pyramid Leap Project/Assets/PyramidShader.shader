Shader "Custom/PyramidShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LeftCameraTex ("Texture", 2D) = "white" {}
        _RightCameraTex ("Texture", 2D) = "white" {}
        _FrontCameraTex ("Texture", 2D) = "white" {}
        _BackCameraTex ("Texture", 2D) = "white" {}
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
            sampler2D _LeftCameraTex;
            sampler2D _RightCameraTex;
            sampler2D _FrontCameraTex;
            sampler2D _BackCameraTex;

            float _Strength;

            uniform float4 _MainTex_TexelSize;

            fixed4 frag (v2f input) : SV_Target
            {
                int width = _MainTex_TexelSize.z;
                int height = _MainTex_TexelSize.w;

                float2 uv = input.uv;

                uint pixel_x = uint(floor(uv.x * width));
                uint pixel_y = uint(floor(uv.y * height));

                fixed4 frontView = tex2D(_FrontCameraTex, uv + float2(0, 0));
                fixed4 leftView = tex2D(_LeftCameraTex, uv + float2(0, 0));
                fixed4 rightView = tex2D(_RightCameraTex, uv + float2(0, 0));
                fixed4 backView = tex2D(_BackCameraTex, uv + float2(0, 0));
                fixed4 blank = fixed4(0, 0, 0, 0);

                fixed4 final = fixed4(0, 0, 0, 0);
                int count = 0;

                if (uv.y >= 0.25 && uv.y <= 0.75) {
                    count++;
                    if (uv.x <= 0.5) { //Left
                        //x 0.00 to 0.50 maps to 0.00 1.00
                        //y 0.25 to 0.75 maps to 0.00 1.00
                        float2 left_coord;
                        left_coord.x = uv.x * 2;
                        left_coord.y = (0.75 - uv.y) * 2;
                        final += tex2D(_LeftCameraTex, left_coord);
                    } else { //Right
                        //x 0.50 to 1.00 maps to 0.00 1.00
                        //y 0.25 to 0.75 maps to
                        float2 right_coord;
                        right_coord.x = 2 * (uv.x - 0.5);
                        right_coord.y = (0.75 - uv.y) * 2;
                        final += tex2D(_RightCameraTex, right_coord);
                    }
                }

                if (uv.x >= 0.25 && uv.x <= 0.75) {
                    count++;
                    if (uv.y <= 0.5) {
                        //x 0.25 to 0.75 maps to 0.00 1.00
                        //y 0.00 to 0.50 maps to 0.00 1.00
                        float2 front_coord;
                        front_coord.x = (0.75 - uv.x) * 2;
                        front_coord.y = uv.y * 2;
                        final += tex2D(_FrontCameraTex, front_coord);
                    } else {
                        float2 back_coord;
                        //x 0.25 to 0.75 maps to 0.00 1.00
                        //y 0.50 to 1.00 maps to 1.00 0.00
                        back_coord.x = 2 * (0.75 - uv.x);
                        back_coord.y = 1 - (2 * (uv.y - 0.5));
                        final += tex2D(_FrontCameraTex, back_coord);
                    }
                }
                if (count == 0) {
                    return blank;
                }
                else if (count == 2) {
                    return final/2;
                }
                return final;

                



 
                // colorR = tex2D(_RightCameraTex, uv + float2(0, 0));
                // colorL = tex2D(_LeftCameraTex, uv + float2(0, 0));

                // colorR.r /= 2;
                // colorR.b *= 2;
                // colorR.a = 0.5;
                
                // colorL.r *= 2;
                // colorL.b /= 2;
                // colorL.a = 0.5;

                // fixed4 final = (colorR + colorL)/2;
                // fixed4 final = 
                
                // return _Strength * final;
                // return colorL;
            }
            ENDCG
        }
    }
}
