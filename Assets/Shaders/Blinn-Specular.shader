Shader "Custom/Blinn-Specular"
{
    properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _Specular("Specular Color", Color) = (1, 1, 1, 1)
        _Gloss("Gloss", Range(8, 200)) = 10
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

            fixed4 _Color;
            fixed4 _Specular;
            half _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float3 worldNormalDir : TEXCOORD0;
                float3 worldVertex : TEXCOORD1;
            };

            v2f vert(a2v v)
            {
                v2f f;
                f.position = UnityObjectToClipPos(v.vertex);
                f.worldNormalDir = mul(v.normal, (float3x3)unity_WorldToObject);
                f.worldVertex = mul(v.vertex, unity_WorldToObject).xyz;
                return f;
            }

            fixed4 frag(v2f f) : SV_TARGET
            {
                fixed3 normalDir = normalize(f.worldNormalDir);
                fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float halfLambert = dot(lightDir, normalDir) * 0.5 + 0.5;
                fixed3 diffuse = _LightColor0.rgb * halfLambert * _Color.rgb ;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                fixed3 reflectDir = normalize(reflect(-lightDir, normalDir));
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - f.worldVertex);

                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(dot(reflectDir, viewDir), 0), _Gloss);

                return fixed4(diffuse + ambient + specular, 1);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}

