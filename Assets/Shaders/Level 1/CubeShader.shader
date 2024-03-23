Shader "Custom/CubeShader"
{
    properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
#include "Lighting.cginc"
#pragma vertex vert
#pragma fragment frag

            float4 _Color;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
            };

            v2f vert(a2v v)
            {
                v2f f;
                f.position = UnityObjectToClipPos(v.vertex);
                return f;
            }

            float4 frag(v2f f) : SV_TARGET
            {
                return _Color;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}

