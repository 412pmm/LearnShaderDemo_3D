// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "flowMap_01"
{
	Properties
	{
		_Emission("Emission", 2D) = "white" {}
		[HDR]_EmissionColor("EmissionColor", Color) = (1,1,1,0)
		_EmissionIntensity("EmissionIntensity", Float) = 1
		_FlowMap("FlowMap", 2D) = "white" {}
		_Speed("Speed", Float) = 0.3
		_Tilling("Tilling", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Emission;
		uniform sampler2D _FlowMap;
		uniform float4 _FlowMap_ST;
		uniform float _Speed;
		uniform float _Tilling;
		uniform float4 _EmissionColor;
		uniform float _EmissionIntensity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float2 blendOpSrc19 = i.uv_texcoord;
			float2 blendOpDest19 = (tex2D( _FlowMap, uv_FlowMap )).rg;
			float2 temp_output_19_0 = ( saturate( (( blendOpDest19 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest19 ) * ( 1.0 - blendOpSrc19 ) ) : ( 2.0 * blendOpDest19 * blendOpSrc19 ) ) ));
			float temp_output_12_0 = ( _Time.y * _Speed );
			float temp_output_1_0_g3 = temp_output_12_0;
			float temp_output_17_0 = (0.0 + (( ( temp_output_1_0_g3 - floor( ( temp_output_1_0_g3 + 0.5 ) ) ) * 2 ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float TimeA20 = -temp_output_17_0;
			float2 lerpResult22 = lerp( i.uv_texcoord , temp_output_19_0 , TimeA20);
			float2 temp_cast_0 = (_Tilling).xx;
			float2 uv_TexCoord25 = i.uv_texcoord * temp_cast_0;
			float2 DiffuseTilling26 = uv_TexCoord25;
			float2 FlowA29 = ( lerpResult22 + DiffuseTilling26 );
			float temp_output_1_0_g2 = (temp_output_12_0*1.0 + 0.5);
			float TimeB36 = -(0.0 + (( ( temp_output_1_0_g2 - floor( ( temp_output_1_0_g2 + 0.5 ) ) ) * 2 ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float2 lerpResult40 = lerp( i.uv_texcoord , temp_output_19_0 , TimeB36);
			float2 FlowB43 = ( lerpResult40 + DiffuseTilling26 );
			float BlendTime51 = saturate( abs( ( 1.0 - ( temp_output_17_0 / 0.5 ) ) ) );
			float4 lerpResult70 = lerp( ( tex2D( _Emission, FlowA29 ) * _EmissionColor ) , ( tex2D( _Emission, FlowB43 ) * _EmissionColor ) , BlendTime51);
			float4 Emission71 = ( lerpResult70 * _EmissionIntensity );
			o.Emission = Emission71.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
116;93.6;1122.4;723;-931.5467;-367.71;1.681805;True;True
Node;AmplifyShaderEditor.CommentaryNode;14;-1422.588,656.3519;Inherit;False;2022.243;1099.511;Time;17;50;49;48;47;36;35;38;37;39;17;13;20;18;12;11;4;51;Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1353.936,826.0435;Inherit;False;Property;_Speed;Speed;6;0;Create;True;0;0;0;False;0;False;0.3;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-1372.588,706.3519;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1149.602,807.457;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;39;-970.6447,1109.348;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;37;-671.2863,1108.809;Inherit;True;Sawtooth Wave;-1;;2;289adb816c3ac6d489f255fc3caf5016;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;13;-991.8425,807.6132;Inherit;True;Sawtooth Wave;-1;;3;289adb816c3ac6d489f255fc3caf5016;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;17;-749.973,808.4227;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;38;-403.1378,1108.012;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;27;-971.9597,-543.9445;Inherit;False;801.4979;208.8;;3;24;26;25;Diffuse Tilling;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;23;-1434.62,-218.6585;Inherit;False;1601.675;749.3577;方向;13;29;22;19;21;6;2;1;28;31;40;41;42;43;UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1;-1384.62,299.3689;Inherit;True;Property;_FlowMap;FlowMap;5;0;Create;True;0;0;0;False;0;False;-1;54aa3d24650f2184cbc68fff4e7f208a;54aa3d24650f2184cbc68fff4e7f208a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-893.9598,-469.8784;Inherit;False;Property;_Tilling;Tilling;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;35;-207.1381,1107.212;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;18;-561.9734,808.4227;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-654.4617,-489.1445;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1035.527,-168.6586;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-408.1638,802.4863;Inherit;False;TimeA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;2;-1079.853,300.7132;Inherit;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-40.52854,1102.875;Inherit;False;TimeB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-676.9625,328.7665;Inherit;False;36;TimeB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-395.2616,-493.9445;Inherit;False;DiffuseTilling;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-681.7308,-123.6455;Inherit;False;20;TimeA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;19;-739.5286,23.80951;Inherit;True;Overlay;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;22;-452.6902,-167.5446;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;47;-375.8993,1435.128;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-409.3766,110.7305;Inherit;False;26;DiffuseTilling;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;40;-448.6346,285.4699;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-169.0453,-167.3968;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;48;-221.7617,1435.49;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-166.782,283.7495;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-21.20721,278.6289;Inherit;False;FlowB;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-22.04133,-172.4992;Inherit;False;FlowA;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;63;729.9092,374.0774;Inherit;False;1773.521;1256.863;Comment;13;71;76;70;75;69;67;68;64;65;66;79;80;81;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;49;-38.56165,1435.49;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;828.3116,942.6265;Inherit;True;43;FlowB;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;50;142.2383,1435.491;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;822.6395,639.5225;Inherit;True;29;FlowA;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;66;779.9092,424.0775;Inherit;True;Property;_Emission;Emission;2;0;Create;True;0;0;0;False;0;False;fc7723e35c4fec2428390a404cb7557a;fc7723e35c4fec2428390a404cb7557a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;67;1103.523,615.3785;Inherit;True;Property;_Diffuse2;Diffuse;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;68;1100.422,915.6244;Inherit;True;Property;_TextureSample2;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;79;1429.806,774.0276;Inherit;False;Property;_EmissionColor;EmissionColor;3;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;349.3441,1430.159;Inherit;False;BlendTime;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;1588.456,1021.936;Inherit;False;51;BlendTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;1668.768,859.2043;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;1647.969,669.604;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;75;1824.264,1030.656;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;70;1813.382,753.9025;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;2073.551,752.045;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;34;335.9157,-1995.649;Inherit;False;1545.116;987.5146;Comment;8;45;44;9;32;30;46;52;73;Diffuse;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;53;352.6138,-813.9238;Inherit;False;1545.116;987.5146;Comment;8;61;60;59;58;57;56;55;54;Normaks;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;2294.278,746.9039;Inherit;True;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;1158.401,-166.0647;Inherit;False;51;BlendTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;1366.628,-1615.824;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;2245.043,-433.1055;Inherit;False;61;Normal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;1638.662,-1622.757;Inherit;True;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;1655.361,-441.0314;Inherit;True;Normal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;2244.165,-346.7032;Inherit;False;71;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;60;1383.327,-434.0984;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;2240.563,-512.9888;Inherit;False;32;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;1141.702,-1347.79;Inherit;False;51;BlendTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;709.5298,-1754.348;Inherit;True;Property;_Diffuse;Diffuse;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;44;706.4291,-1454.102;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;57;726.2277,-572.6227;Inherit;True;Property;_Diffuse1;Diffuse;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;45;434.3181,-1427.1;Inherit;True;43;FlowB;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;73;416.3088,-1944.11;Inherit;True;Property;_diffuse;diffuse;0;0;Create;True;0;0;0;False;0;False;c1909b6ec0b074d48915c35530d005d3;c1909b6ec0b074d48915c35530d005d3;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;55;445.3441,-548.4787;Inherit;True;29;FlowA;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;428.646,-1730.204;Inherit;True;29;FlowA;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;451.0162,-245.3745;Inherit;True;43;FlowB;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;56;402.6138,-763.9238;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;c42ebc96632ab144fa59a03d3ac2e58b;c42ebc96632ab144fa59a03d3ac2e58b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;58;723.127,-272.3765;Inherit;True;Property;_TextureSample1;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2511.62,-508.2416;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;flowMap_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;0
WireConnection;12;1;4;0
WireConnection;39;0;12;0
WireConnection;37;1;39;0
WireConnection;13;1;12;0
WireConnection;17;0;13;0
WireConnection;38;0;37;0
WireConnection;35;0;38;0
WireConnection;18;0;17;0
WireConnection;25;0;24;0
WireConnection;20;0;18;0
WireConnection;2;0;1;0
WireConnection;36;0;35;0
WireConnection;26;0;25;0
WireConnection;19;0;6;0
WireConnection;19;1;2;0
WireConnection;22;0;6;0
WireConnection;22;1;19;0
WireConnection;22;2;21;0
WireConnection;47;0;17;0
WireConnection;40;0;6;0
WireConnection;40;1;19;0
WireConnection;40;2;41;0
WireConnection;28;0;22;0
WireConnection;28;1;31;0
WireConnection;48;0;47;0
WireConnection;42;0;40;0
WireConnection;42;1;31;0
WireConnection;43;0;42;0
WireConnection;29;0;28;0
WireConnection;49;0;48;0
WireConnection;50;0;49;0
WireConnection;67;0;66;0
WireConnection;67;1;65;0
WireConnection;68;0;66;0
WireConnection;68;1;64;0
WireConnection;51;0;50;0
WireConnection;81;0;68;0
WireConnection;81;1;79;0
WireConnection;80;0;67;0
WireConnection;80;1;79;0
WireConnection;70;0;80;0
WireConnection;70;1;81;0
WireConnection;70;2;69;0
WireConnection;76;0;70;0
WireConnection;76;1;75;0
WireConnection;71;0;76;0
WireConnection;46;0;9;0
WireConnection;46;1;44;0
WireConnection;46;2;52;0
WireConnection;32;0;46;0
WireConnection;61;0;60;0
WireConnection;60;0;57;0
WireConnection;60;1;58;0
WireConnection;60;2;59;0
WireConnection;9;0;73;0
WireConnection;9;1;30;0
WireConnection;44;0;73;0
WireConnection;44;1;45;0
WireConnection;57;0;56;0
WireConnection;57;1;55;0
WireConnection;58;0;56;0
WireConnection;58;1;54;0
WireConnection;0;2;72;0
ASEEND*/
//CHKSM=9623994DA0966E085D1950BE2337CF75B4258758