// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Samples/Sequence Animation_ASE"
{
	Properties
	{
		_AnimationRate("Animation Rate", Float) = 1
		_Column("Column", Float) = 4
		_Row("Row", Float) = 4
		[NoScaleOffset]_SequenceImage("Sequence Image", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "DisableBatching"="True" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend OneMinusDstColor One
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_VERT_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _SequenceImage;
			uniform float _AnimationRate;
			uniform float _Column;
			uniform float _Row;
			uniform float4 _Tint;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				//Calculate new billboard vertex position and normal;
				float3 upCamVec = normalize ( UNITY_MATRIX_V._m10_m11_m12 );
				float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
				float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
				float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
				v.ase_normal = normalize( mul( float4( v.ase_normal , 0 ), rotationCamMatrix )).xyz;
				//This unfortunately must be made to take non-uniform scaling into account;
				//Transform to world coords, apply rotation and transform back to local;
				v.vertex = mul( v.vertex , unity_ObjectToWorld );
				v.vertex = mul( v.vertex , rotationCamMatrix );
				v.vertex = mul( v.vertex , unity_WorldToObject );
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = 0;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float mulTime3 = _Time.y * _AnimationRate;
				float Time7 = floor( mulTime3 );
				float fmodResult11 = frac(Time7/_Column)*_Column;
				float2 appendResult30 = (float2(( ( i.ase_texcoord1.xy.x + floor( fmodResult11 ) ) / _Column ) , ( ( ( i.ase_texcoord1.xy.y - 1.0 ) - floor( ( Time7 / _Column ) ) ) / _Row )));
				
				
				finalColor = ( tex2D( _SequenceImage, appendResult30 ) * _Tint );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18912
0;0;1536;843;288.4146;560.9571;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;2;-952.9755,-652.0447;Inherit;False;Property;_AnimationRate;Animation Rate;0;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;3;-786.5754,-647.245;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;6;-671.7752,-697.2449;Inherit;False;200;160.4;不需要中间过渡直接下一帧;1;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FloorOpNode;4;-621.7751,-647.2449;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-454.8302,-652.9981;Inherit;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;17;-1099.444,-535.4047;Inherit;False;882.4932;412.0129;列;7;8;9;11;15;16;14;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;19;-1094.636,-78.63215;Inherit;False;882.4932;412.0129;行;8;26;25;21;20;28;29;35;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;8;-1049.444,-340.6572;Inherit;False;7;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-1047.415,115.8195;Inherit;False;7;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1041.443,-239.0573;Inherit;False;Property;_Column;Column;1;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;35;-874.074,120.3317;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimplifiedFModOpNode;11;-871.8419,-335.8573;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;26;-910.0841,-43.27201;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-715.8166,4.136407;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;36;-699.3791,120.222;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;14;-776.893,-485.4046;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FloorOpNode;37;-679.9684,-335.8187;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;-525.0967,97.17636;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-546.9511,-358.7918;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-532.3405,218.2175;Inherit;False;Property;_Row;Row;2;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;25;-354.1427,198.7809;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;16;-369.3511,-257.1917;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-161.7858,-256.7204;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;31;-2.636292,-285.1588;Inherit;True;Property;_SequenceImage;Sequence Image;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;e6af2960a8003e843928b8f348b04a42;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;82.99374,-73.96854;Inherit;False;Property;_Tint;Tint;4;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1;476.7334,-474.5642;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;324.5937,-278.7685;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BillboardNode;34;356.4639,-8.147614;Inherit;False;Spherical;False;0;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;584.96,-279.7205;Float;False;True;-1;2;ASEMaterialInspector;100;1;Samples/Sequence Animation_ASE;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;5;4;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;3;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;DisableBatching=True=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
Node;AmplifyShaderEditor.CommentaryNode;38;-1097.415,65.8195;Inherit;False;548.0357;188.3122;row;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-1099.444,-390.6572;Inherit;False;569.4756;266.9999;column;0;;1,1,1,1;0;0
WireConnection;3;0;2;0
WireConnection;4;0;3;0
WireConnection;7;0;4;0
WireConnection;35;0;20;0
WireConnection;35;1;9;0
WireConnection;11;0;8;0
WireConnection;11;1;9;0
WireConnection;28;0;26;2
WireConnection;36;0;35;0
WireConnection;37;0;11;0
WireConnection;29;0;28;0
WireConnection;29;1;36;0
WireConnection;15;0;14;1
WireConnection;15;1;37;0
WireConnection;25;0;29;0
WireConnection;25;1;21;0
WireConnection;16;0;15;0
WireConnection;16;1;9;0
WireConnection;30;0;16;0
WireConnection;30;1;25;0
WireConnection;31;1;30;0
WireConnection;32;0;31;0
WireConnection;32;1;33;0
WireConnection;0;0;32;0
WireConnection;0;1;34;0
ASEEND*/
//CHKSM=2B7DBDF38FCE9602879C16E0B299DB5877D84CB7