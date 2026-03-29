// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Surface/Standard Shader-ASE"
{
	Properties
	{
		_Tilling_X("Tilling_X", Float) = 1
		_Tilling_Y("Tilling_Y", Float) = 1
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_AlbedoColor("Albedo Color", Color) = (1,1,1,1)
		[NoScaleOffset]_Normal("Normal", 2D) = "white" {}
		[NoScaleOffset]_Emission("Emission", 2D) = "white" {}
		_EmissionColor("Emission Color", Color) = (0,0,0,0)
		[NoScaleOffset]_Specular("Specular", 2D) = "white" {}
		_SpecularColor("Specular Color", Color) = (0,0,0,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[NoScaleOffset]_AmbientOcclusion("Ambient Occlusion", 2D) = "white" {}
		_Ambient("Ambient", Range( 0 , 1)) = 0.1214054
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float _Tilling_X;
		uniform float _Tilling_Y;
		uniform sampler2D _Albedo;
		uniform float4 _AlbedoColor;
		uniform sampler2D _Emission;
		uniform float4 _EmissionColor;
		uniform sampler2D _Specular;
		uniform float4 _SpecularColor;
		uniform float _Smoothness;
		uniform sampler2D _AmbientOcclusion;
		uniform float _Ambient;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 appendResult28 = (float2(_Tilling_X , _Tilling_Y));
			float2 uv_TexCoord29 = i.uv_texcoord * appendResult28;
			o.Normal = tex2D( _Normal, uv_TexCoord29 ).rgb;
			o.Albedo = ( tex2D( _Albedo, uv_TexCoord29 ) * _AlbedoColor ).rgb;
			float4 tex2DNode10 = tex2D( _Emission, uv_TexCoord29 );
			o.Emission = ( ( tex2DNode10 * _EmissionColor ) * tex2DNode10.a ).rgb;
			float4 tex2DNode15 = tex2D( _Specular, uv_TexCoord29 );
			o.Specular = ( tex2DNode15 * _SpecularColor ).rgb;
			o.Smoothness = ( tex2DNode15.a * _Smoothness );
			float4 lerpResult22 = lerp( float4( 1,1,1,1 ) , tex2D( _AmbientOcclusion, uv_TexCoord29 ) , _Ambient);
			o.Occlusion = lerpResult22.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
36.8;51.2;1409.6;762.2;1123.73;-42.94113;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;26;-1778.594,23.574;Inherit;False;Property;_Tilling_X;Tilling_X;0;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1777.107,133.7613;Inherit;False;Property;_Tilling_Y;Tilling_Y;1;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1605.106,69.76138;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-1447.592,44.7732;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;24;-742.5691,1311.878;Inherit;False;588.993;358.8081;环境光遮罩;3;21;22;23;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;30;-1044.495,-369.2;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;31;-1160.357,1296.048;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;5;-747.8477,-559.4918;Inherit;False;565.2;453.4;Albedo;3;1;4;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;13;-715.0596,283.1816;Inherit;False;544.2302;496.8432;自发光;4;10;11;12;32;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;11;-641.3631,571.0249;Inherit;False;Property;_EmissionColor;Emission Color;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-665.0596,333.1816;Inherit;True;Property;_Emission;Emission;6;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;6fa58e1500b03bd4ea0ad428c43c9031;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;20;-927.9798,807.4438;Inherit;False;786.0007;479.0002;高光;5;15;19;18;16;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-678.093,1555.286;Inherit;False;Property;_Ambient;Ambient;12;0;Create;True;0;0;0;False;0;False;0.1214054;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-636.0214,-315.0918;Inherit;False;Property;_AlbedoColor;Albedo Color;3;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-697.8477,-509.4919;Inherit;True;Property;_Albedo;Albedo;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;2be1b98749bd06c498d6f33201c11ebf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-692.5691,1361.878;Inherit;True;Property;_AmbientOcclusion;Ambient Occlusion;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;0a334d8131d7c2f44a8e025b644af05a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-333.2298,337.3743;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;9;-837.8071,-54.68855;Inherit;False;673.1498;280;Normal;2;7;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-577.1791,1019.843;Inherit;False;Property;_Smoothness;Smoothness;10;0;Create;True;0;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-345.0477,-504.6919;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;17;-816.3795,1077.444;Inherit;False;Property;_SpecularColor;Specular Color;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-877.9798,857.4438;Inherit;True;Property;_Specular;Specular;8;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;7a6ac2f460e530c4ca6919723a511c45;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;22;-335.5762,1462.955;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;14;-59.35609,-426.5581;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-485.4572,-4.688549;Inherit;True;Property;_Normal;Normal;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;a20b74053750c5e42b652cab1bf2253c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-787.8071,41.97227;Float;False;Property;_Bumpiness;Bumpiness;5;0;Create;True;0;0;0;False;0;False;1;1.11;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-304.3791,956.6443;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-506.7797,862.2438;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;25;-0.2405777,1399.85;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-320.8986,504.2437;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;56.97269,793.4849;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Surface/Standard Shader-ASE;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;29;0;28;0
WireConnection;30;0;29;0
WireConnection;31;0;29;0
WireConnection;10;1;29;0
WireConnection;1;1;30;0
WireConnection;21;1;31;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;4;0;1;0
WireConnection;4;1;3;0
WireConnection;15;1;29;0
WireConnection;22;1;21;0
WireConnection;22;2;23;0
WireConnection;14;0;4;0
WireConnection;6;1;29;0
WireConnection;18;0;15;4
WireConnection;18;1;19;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;25;0;22;0
WireConnection;32;0;12;0
WireConnection;32;1;10;4
WireConnection;0;0;14;0
WireConnection;0;1;6;0
WireConnection;0;2;32;0
WireConnection;0;3;16;0
WireConnection;0;4;18;0
WireConnection;0;5;25;0
ASEEND*/
//CHKSM=D13AA7A622BB01E22043C008D60C5EC07EA99849