Shader "Custom/NormalMap"
{
    properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex("Main Tex", 2D) = "white"{}
        _NormalMap("Normal Map", 2D) = "bump"{}
        _BumpScale("Bump Scale", Float) = 1
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
            sampler2D _NormalMap;
            float4 _NormalMap_ST;
            float _BumpScale;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texcoord : TEXCOORD0;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float3 lightDir: TEXCOORD0;
                float4 worldVertex : TEXCOORD1;
                float4 uv : TEXCOORD2;
            };

            v2f vert(a2v v)
            {
                v2f f;
                f.position = UnityObjectToClipPos(v.vertex);
                f.worldVertex = mul(v.vertex, unity_WorldToObject);
                f.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                f.uv.zw = v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
                TANGENT_SPACE_ROTATION;
                f.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex));

                return f;
            }

            fixed4 frag(v2f f) : SV_TARGET
            {
                fixed4 normalColor = tex2D(_NormalMap, f.uv.zw);
                fixed3 tangentNormal = normalize(UnpackNormal(normalColor));
                tangentNormal.xy = tangentNormal.xy * _BumpScale;

                fixed3 lightDir = normalize(f.lightDir);
                fixed3 texColor = tex2D(_MainTex, f.uv.xy) * _Color.rgb;
                float halfLambert = dot(lightDir, tangentNormal) * 0.5 + 0.5;
                fixed3 diffuse = _LightColor0.rgb * halfLambert * texColor;

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * texColor;

                return fixed4(diffuse + ambient, 1);
            }
            ENDCG
        }
    }
    FallBack "Specular"
}
