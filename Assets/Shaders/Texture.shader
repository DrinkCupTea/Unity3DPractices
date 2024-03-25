Shader "Custom/Texture"
{
    properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex("Main Tex", 2D) = "white"{}
        _Specular("Specular Color", Color) = (1, 1, 1, 1)
        _Gloss("Gloss", Range(10, 200)) = 10
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
            sampler2D _MainTex;
            float4 _MainTex_ST;
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
                float4 worldVertex : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            v2f vert(a2v v)
            {
                v2f f;
                f.position = UnityObjectToClipPos(v.vertex);
                f.worldNormalDir = UnityObjectToWorldNormal(v.normal);
                f.worldVertex = mul(v.vertex, unity_WorldToObject);
                f.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return f;
            }

            fixed4 frag(v2f f) : SV_TARGET
            {
                fixed3 normalDir = normalize(f.worldNormalDir);
                fixed3 lightDir = normalize(WorldSpaceLightDir(f.worldVertex));
                fixed3 texColor = tex2D(_MainTex, f.uv.xy) * _Color.rgb;
                float halfLambert = dot(lightDir, normalDir) * 0.5 + 0.5;
                fixed3 diffuse = _LightColor0.rgb * halfLambert * texColor;

                fixed3 viewDir = normalize(WorldSpaceViewDir(f.worldVertex));
                fixed3 halfDir = normalize(lightDir + viewDir);

                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(dot(normalDir, halfDir), 0), _Gloss);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * texColor;

                return fixed4(diffuse + specular + ambient, 1);
            }
            ENDCG
        }
    }
    FallBack "Specular"
}
