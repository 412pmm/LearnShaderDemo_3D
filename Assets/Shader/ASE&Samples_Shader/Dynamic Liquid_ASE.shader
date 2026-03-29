// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Samples/Dynamic Liquid_ASE"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.01
		_LiquidLevel("Liquid Level", Float) = 1
		_RIppleSpeed("RIpple Speed", Float) = 1
		[KeywordEnum(X,Z)] _RippleDirection("Ripple Direction", Float) = 1
		_RippleHeight("Ripple Height", Float) = 0.5
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		ZWrite Off
		Blend DstColor SrcColor
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _RIPPLEDIRECTION_X _RIPPLEDIRECTION_Z
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _LiquidLevel;
		uniform float _RIppleSpeed;
		uniform float _RippleHeight;
		uniform float _Cutoff = 0.01;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float4 color24 = IsGammaSpace() ? float4(0.435849,0.8137912,1,0) : float4(0.159393,0.6274674,1,0);
			o.Albedo = color24.rgb;
			o.Alpha = 1;
			float4 transform1 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_worldPos = i.worldPos;
			float Liquid7 = ( ( transform1.y - ase_worldPos.y ) + ( _LiquidLevel / 100.0 ) );
			float mulTime9 = _Time.y * _RIppleSpeed;
			float3 Ripple15 = ( ase_worldPos * ( sin( mulTime9 ) * _RippleHeight ) );
			float3 temp_output_18_0 = ( Liquid7 + Ripple15 );
			#if defined(_RIPPLEDIRECTION_X)
				float staticSwitch22 = (temp_output_18_0).x;
			#elif defined(_RIPPLEDIRECTION_Z)
				float staticSwitch22 = (temp_output_18_0).z;
			#else
				float staticSwitch22 = (temp_output_18_0).z;
			#endif
			clip( step( 0.0 , staticSwitch22 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
78.4;41.6;1409.6;751;1997.359;-42.90607;2.239307;True;True
Node;AmplifyShaderEditor.RangedFloatNode;8;-1565.833,369.2695;Inherit;False;Property;_RIppleSpeed;RIpple Speed;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-1373.833,373.2694;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1207.458,33.93299;Inherit;False;Property;_LiquidLevel;Liquid Level;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-1217.858,-151.667;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;12;-1253.037,449.9679;Inherit;False;Property;_RippleHeight;Ripple Height;4;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;1;-1221.858,-344.467;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;10;-1202.632,373.2695;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;13;-1117.836,226.7681;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1081.036,432.3679;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;6;-961.8583,40.33302;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2;-997.858,-231.667;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-752.2581,-133.267;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-904.2365,408.3679;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-625.0582,-138.067;Inherit;True;Liquid;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-678.3545,403.1945;Inherit;False;Ripple;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-1244.113,803.6963;Inherit;False;7;Liquid;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-1242.622,911.481;Inherit;False;15;Ripple;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-1054.621,893.0811;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;19;-889.8202,707.4812;Inherit;True;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;21;-883.4202,956.2811;Inherit;True;False;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;22;-592.2191,837.8811;Inherit;False;Property;_RippleDirection;Ripple Direction;3;0;Create;True;0;0;0;False;0;False;0;1;1;True;;KeywordEnum;2;X;Z;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-64.98856,576.4409;Inherit;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;0;False;0;False;0.435849,0.8137912,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;26;-201.4255,338.8647;Inherit;True;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;25;-424.6255,338.0647;Inherit;True;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;27;22.57452,338.8647;Inherit;True;False;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;23;52.58115,816.2813;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;280.6309,582.2695;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Samples/Dynamic Liquid_ASE;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.01;True;True;0;True;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;7;2;False;-1;3;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;8;0
WireConnection;10;0;9;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;6;0;5;0
WireConnection;2;0;1;2
WireConnection;2;1;3;2
WireConnection;4;0;2;0
WireConnection;4;1;6;0
WireConnection;14;0;13;0
WireConnection;14;1;11;0
WireConnection;7;0;4;0
WireConnection;15;0;14;0
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;19;0;18;0
WireConnection;21;0;18;0
WireConnection;22;1;19;0
WireConnection;22;0;21;0
WireConnection;26;0;15;0
WireConnection;25;0;15;0
WireConnection;27;0;15;0
WireConnection;23;1;22;0
WireConnection;0;0;24;0
WireConnection;0;10;23;0
ASEEND*/
//CHKSM=2F124623A95561475047DDD2F2748DEA12051E4F