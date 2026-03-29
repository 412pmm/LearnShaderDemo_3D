// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Samples/Object Cutting_ASE"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.001
		_Albedo("Albedo", 2D) = "white" {}
		_Specular_Smoothness("Specular_Smoothness", 2D) = "white" {}
		_Position("Position", Vector) = (0,0,0,0)
		[KeywordEnum(X,Y,Z)] _CuttingDirection("Cutting Direction", Float) = 0
		[Toggle]_InvertDirection("Invert Direction", Float) = 0
		_AmbientOcclusion("Ambient Occlusion", 2D) = "white" {}
		_InnerColor("Inner Color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_local _CUTTINGDIRECTION_X _CUTTINGDIRECTION_Y _CUTTINGDIRECTION_Z
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			half ASEVFace : VFACE;
			float3 worldPos;
		};

		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _InnerColor;
		uniform sampler2D _Specular_Smoothness;
		uniform float4 _Specular_Smoothness_ST;
		uniform sampler2D _AmbientOcclusion;
		uniform float4 _AmbientOcclusion_ST;
		uniform float _InvertDirection;
		uniform float3 _Position;
		uniform float _Cutoff = 0.001;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 switchResult2 = (((i.ASEVFace>0)?(tex2D( _Albedo, uv_Albedo )):(_InnerColor)));
			o.Albedo = switchResult2.rgb;
			float2 uv_Specular_Smoothness = i.uv_texcoord * _Specular_Smoothness_ST.xy + _Specular_Smoothness_ST.zw;
			float4 switchResult5 = (((i.ASEVFace>0)?(tex2D( _Specular_Smoothness, uv_Specular_Smoothness )):(float4( 0,0,0,0 ))));
			o.Specular = (switchResult5).rgb;
			o.Smoothness = (switchResult5).a;
			float2 uv_AmbientOcclusion = i.uv_texcoord * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
			o.Occlusion = tex2D( _AmbientOcclusion, uv_AmbientOcclusion ).r;
			o.Alpha = 1;
			#if defined(_CUTTINGDIRECTION_X)
				float staticSwitch11 = _Position.x;
			#elif defined(_CUTTINGDIRECTION_Y)
				float staticSwitch11 = _Position.y;
			#elif defined(_CUTTINGDIRECTION_Z)
				float staticSwitch11 = _Position.z;
			#else
				float staticSwitch11 = _Position.x;
			#endif
			float3 ase_worldPos = i.worldPos;
			#if defined(_CUTTINGDIRECTION_X)
				float staticSwitch12 = ase_worldPos.x;
			#elif defined(_CUTTINGDIRECTION_Y)
				float staticSwitch12 = ase_worldPos.y;
			#elif defined(_CUTTINGDIRECTION_Z)
				float staticSwitch12 = ase_worldPos.z;
			#else
				float staticSwitch12 = ase_worldPos.x;
			#endif
			float temp_output_13_0 = step( staticSwitch11 , staticSwitch12 );
			clip( (( _InvertDirection )?( ( 1.0 - temp_output_13_0 ) ):( temp_output_13_0 )) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
52;48;1409.6;751;1095.376;282.7776;1;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;10;-584.2351,767.1866;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;8;-581.8349,581.5867;Inherit;False;Property;_Position;Position;3;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;11;-352.2349,605.5863;Inherit;False;Property;_CuttingDirection;Cutting Direction;4;0;Create;True;0;0;0;False;0;False;1;0;0;True;;KeywordEnum;3;X;Y;Z;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;12;-350.6349,784.7866;Inherit;False;Property;_Keyword1;Keyword 0;4;0;Create;True;0;0;0;False;0;False;1;0;0;True;;KeywordEnum;3;X;Y;Z;Reference;11;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;13;-81.03491,609.5864;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-607.9998,256.9001;Inherit;True;Property;_Specular_Smoothness;Specular_Smoothness;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwitchByFaceNode;5;-270.3998,261.7001;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;14;81.36505,703.9865;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;195.0565,410.6128;Inherit;True;Property;_AmbientOcclusion;Ambient Occlusion;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;15;271.765,604.7866;Inherit;False;Property;_InvertDirection;Invert Direction;5;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;-320.3999,-27.5;Inherit;False;371.6;139.8;根据物体朝向摄像机的正反面而自动调整呈现的结果;1;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwizzleNode;7;-63.19983,351.3;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-614.3999,-147.1;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;20;-577.7758,39.62244;Inherit;False;Property;_InnerColor;Inner Color;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;6;-67.19983,256.9001;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2;-270.3999,22.5;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;17;558.977,338.338;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;16;755.4382,559.6446;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;19;660.31,385.8764;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;829.5506,18.64898;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Samples/Object Cutting_ASE;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.001;True;True;0;False;TransparentCutout;;AlphaTest;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;1;8;1
WireConnection;11;0;8;2
WireConnection;11;2;8;3
WireConnection;12;1;10;1
WireConnection;12;0;10;2
WireConnection;12;2;10;3
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;5;0;4;0
WireConnection;14;0;13;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;7;0;5;0
WireConnection;6;0;5;0
WireConnection;2;0;1;0
WireConnection;2;1;20;0
WireConnection;17;0;7;0
WireConnection;16;0;15;0
WireConnection;19;0;18;0
WireConnection;0;0;2;0
WireConnection;0;3;6;0
WireConnection;0;4;17;0
WireConnection;0;5;19;0
WireConnection;0;10;16;0
ASEEND*/
//CHKSM=F5A0CE653AFD44FBA0AF27C14192936F4F502FEE