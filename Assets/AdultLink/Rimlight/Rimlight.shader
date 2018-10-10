// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/Rimlight"
{
	Properties
	{
		_Maintiling("Maintiling", Vector) = (1,1,0,0)
		_Mainoffset("Mainoffset", Vector) = (0,0,0,0)
		_Albedo("Albedo", 2D) = "white" {}
		[HDR]_Albedotintcolor("Albedo tint color", Color) = (1,1,1,1)
		_Normal("Normal", 2D) = "bump" {}
		[Toggle]_Enableemission("Enable emission", Range( 0 , 1)) = 0
		_Emission("Emission", 2D) = "white" {}
		[HDR]_Emissiontintcolor("Emission tint color", Color) = (0,0,0,1)
		_Specular("Specular", 2D) = "black" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Occlusion("Occlusion", 2D) = "white" {}
		[Toggle]_Enablerimlight("Enable rimlight", Float) = 1
		[HDR]_Rimlightcolor("Rimlight color", Color) = (0,0.8344827,1,1)
		_Rimlightpower("Rimlight power", Float) = 3.5
		_Rimlightscale("Rimlight scale", Float) = 1
		_Rimlightbias("Rimlight bias", Float) = 0
		_Rimlightopacity("Rimlight opacity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Normal;
		uniform float2 _Maintiling;
		uniform float2 _Mainoffset;
		uniform float4 _Albedotintcolor;
		uniform sampler2D _Albedo;
		uniform float _Enablerimlight;
		uniform float4 _Rimlightcolor;
		uniform float _Rimlightbias;
		uniform float _Rimlightscale;
		uniform float _Rimlightpower;
		uniform float _Rimlightopacity;
		uniform float _Enableemission;
		uniform float4 _Emissiontintcolor;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform sampler2D _Specular;
		uniform float _Smoothness;
		uniform sampler2D _Occlusion;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_TexCoord288 = i.uv_texcoord * _Maintiling + _Mainoffset;
			float2 UVTilingOffset290 = uv_TexCoord288;
			float3 Normal265 = UnpackNormal( tex2D( _Normal, UVTilingOffset290 ) );
			o.Normal = Normal265;
			float4 Albedo262 = ( _Albedotintcolor * tex2D( _Albedo, UVTilingOffset290 ) );
			o.Albedo = Albedo262.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV94 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode94 = ( _Rimlightbias + _Rimlightscale * pow( 1.0 - fresnelNdotV94, _Rimlightpower ) );
			float4 Rimlight167 = ( _Enablerimlight * ( _Rimlightcolor * fresnelNode94 * _Rimlightopacity ) );
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 Emission126 = ( _Enableemission * _Emissiontintcolor * tex2D( _Emission, uv_Emission ) );
			o.Emission = ( Rimlight167 + Emission126 ).rgb;
			float4 Specular270 = tex2D( _Specular, UVTilingOffset290 );
			float4 temp_output_271_0 = Specular270;
			o.Specular = temp_output_271_0.rgb;
			o.Smoothness = ( _Smoothness * Specular270.a );
			float4 Occlusion274 = tex2D( _Occlusion, UVTilingOffset290 );
			o.Occlusion = Occlusion274.r;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
653;92;862;603;2077.967;2071.577;5.294938;True;False
Node;AmplifyShaderEditor.CommentaryNode;291;-1530.754,-1466.53;Float;False;701.6356;359.3447;Main UV Tiling & offset;4;287;288;289;290;Main UV Tiling & offset;0.8088235,0.8259634,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;166;-1504.746,-881.5418;Float;False;1378.005;580.1563;Rim light;10;167;239;95;240;94;297;97;238;234;237;Rim light;0.9720081,1,0.4926471,1;0;0
Node;AmplifyShaderEditor.Vector2Node;289;-1478.867,-1268.186;Float;False;Property;_Mainoffset;Mainoffset;1;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;287;-1480.754,-1395.551;Float;False;Property;_Maintiling;Maintiling;0;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;234;-1446.563,-644.5555;Float;False;Property;_Rimlightbias;Rimlight bias;15;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;238;-1459.563,-500.5555;Float;False;Property;_Rimlightpower;Rimlight power;13;0;Create;True;0;0;False;0;3.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-1454.563,-572.5555;Float;False;Property;_Rimlightscale;Rimlight scale;14;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;288;-1300.573,-1413.308;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;269;1274.382,-304.6945;Float;False;818.3302;294.9999;Specular;3;294;270;251;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.FresnelNode;94;-1261.643,-636.9075;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;3.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;261;1288.441,-1395.078;Float;False;968.9102;457.4636;Comment;5;262;299;298;231;292;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;1290.287,-217.3098;Float;False;290;UVTilingOffset;0;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;145;247.0254,-1583.385;Float;False;754.7207;549.2288;Emission;5;296;40;126;282;47;Emission;0.4705882,0.7371198,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;290;-1075.119,-1416.53;Float;False;UVTilingOffset;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;97;-1211.47,-807.4888;Float;False;Property;_Rimlightcolor;Rimlight color;12;1;[HDR];Create;True;0;0;False;0;0,0.8344827,1,1;0.5882352,0.7614604,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;297;-1480.661,-412.0538;Float;False;Property;_Rimlightopacity;Rimlight opacity;16;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;292;1311.849,-1145.466;Float;False;290;UVTilingOffset;0;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;251;1524.204,-240.0635;Float;True;Property;_Specular;Specular;8;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;282;283.7171,-1518.581;Float;False;Property;_Enableemission;Enable emission;5;1;[Toggle];Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;296;279.2042,-1242.633;Float;True;Property;_Emission;Emission;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;40;288.1651,-1432.93;Float;False;Property;_Emissiontintcolor;Emission tint color;7;1;[HDR];Create;True;0;0;False;0;0,0,0,1;0.375,0.6637931,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;240;-762.5621,-689.5555;Float;False;Property;_Enablerimlight;Enable rimlight;11;1;[Toggle];Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;264;1280.738,-789.5121;Float;False;837.7743;333.1628;Normal;3;293;265;252;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-779.9338,-607.2547;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;275;1277.005,195.5377;Float;False;873.6523;286.9999;Occlusion;3;295;274;253;Occlusion;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;231;1535.985,-1167.328;Float;True;Property;_Albedo;Albedo;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;298;1616.386,-1343.675;Float;False;Property;_Albedotintcolor;Albedo tint color;3;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;642.5339,-1295.894;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;295;1299.62,266.1338;Float;False;290;UVTilingOffset;0;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;271;-3.723843,-584.6944;Float;False;270;Specular;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;270;1843.184,-241.5315;Float;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;293;1289.031,-698.5121;Float;False;290;UVTilingOffset;0;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;239;-527.5624,-629.5555;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;253;1548.667,245.5377;Float;True;Property;_Occlusion;Occlusion;10;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;252;1527.794,-720.504;Float;True;Property;_Normal;Normal;4;0;Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;1876.971,-1185.477;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;780.9026,-1299.741;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;272;185.7562,-504.4598;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;127;204.6704,-667.2292;Float;False;126;Emission;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;-392.926,-633.4815;Float;False;Rimlight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;259;425.6232,-465.0107;Float;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;205.9431,-767.6918;Float;False;167;Rimlight;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;263;395.3937,-890.154;Float;False;262;Albedo;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;260;710.6946,-460.0623;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;274;1863.678,256.6417;Float;False;Occlusion;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;1850.886,-721.3351;Float;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;394.0508,-722.4039;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;262;2020.573,-1189.576;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;266;393.7202,-805.6969;Float;False;265;Normal;0;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;276;684.3846,-356.9693;Float;False;274;Occlusion;0;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;927.8253,-766.2856;Float;False;True;2;Float;ASEMaterialInspector;0;0;StandardSpecular;AdultLink/Rimlight;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;288;0;287;0
WireConnection;288;1;289;0
WireConnection;94;1;234;0
WireConnection;94;2;237;0
WireConnection;94;3;238;0
WireConnection;290;0;288;0
WireConnection;251;1;294;0
WireConnection;95;0;97;0
WireConnection;95;1;94;0
WireConnection;95;2;297;0
WireConnection;231;1;292;0
WireConnection;47;0;282;0
WireConnection;47;1;40;0
WireConnection;47;2;296;0
WireConnection;270;0;251;0
WireConnection;239;0;240;0
WireConnection;239;1;95;0
WireConnection;253;1;295;0
WireConnection;252;1;293;0
WireConnection;299;0;298;0
WireConnection;299;1;231;0
WireConnection;126;0;47;0
WireConnection;272;0;271;0
WireConnection;167;0;239;0
WireConnection;260;0;259;0
WireConnection;260;1;272;3
WireConnection;274;0;253;0
WireConnection;265;0;252;0
WireConnection;49;0;168;0
WireConnection;49;1;127;0
WireConnection;262;0;299;0
WireConnection;0;0;263;0
WireConnection;0;1;266;0
WireConnection;0;2;49;0
WireConnection;0;3;271;0
WireConnection;0;4;260;0
WireConnection;0;5;276;0
ASEEND*/
//CHKSM=3E64B3FA635E9AC81CA8DB1540E9B10C7A55EE72