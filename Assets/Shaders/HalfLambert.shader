Shader "Custom/HalfLambert"
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
                fixed3 worldNormalDir: COLOR0;
            };

            v2f vert(a2v v)
            {
                v2f f;
                f.position = UnityObjectToClipPos(v.vertex);
                f.worldNormalDir = mul(v.normal, (float3x3)unity_ObjectToWorld);
                return f;
            }

            fixed4 frag(v2f f) : SV_TARGET
            {
                fixed3 normalDir = normalize(f.worldNormalDir);
                fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float halfLambert = dot(lightDir, normalDir) * 0.5 + 0.5;
                fixed3 diffuse = _LightColor0.rgb * halfLambert * _Color.rgb ;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
                return fixed4(diffuse + ambient, 1);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}

