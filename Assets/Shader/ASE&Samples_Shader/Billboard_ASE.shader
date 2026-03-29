// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Samples/Billboard_ASE"
{
	Properties
	{
		[KeywordEnum(Spherical,Cylindrical)] _Type("Type", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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

			#define ASE_ABSOLUTE_VERTEX_POS 1


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
			#pragma shader_feature_local _TYPE_SPHERICAL _TYPE_CYLINDRICAL


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
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

			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 worldToObj4 = mul( unity_WorldToObject, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
				float3 appendResult5 = (float3(worldToObj4.x , 0.0 , worldToObj4.z));
				#if defined(_TYPE_SPHERICAL)
				float3 staticSwitch6 = worldToObj4;
				#elif defined(_TYPE_CYLINDRICAL)
				float3 staticSwitch6 = appendResult5;
				#else
				float3 staticSwitch6 = worldToObj4;
				#endif
				float3 normalizeResult7 = normalize( staticSwitch6 );
				float3 Forward8 = normalizeResult7;
				float3 _Vector1 = float3(0,1,0);
				float3 ifLocalVar15 = 0;
				if( abs( (Forward8).y ) <= 0.999 )
				ifLocalVar15 = _Vector1;
				else
				ifLocalVar15 = float3(0,0,1);
				float3 normalizeResult18 = normalize( cross( Forward8 , ifLocalVar15 ) );
				float3 Right20 = normalizeResult18;
				float3 normalizeResult25 = normalize( cross( Right20 , Forward8 ) );
				float3 Up26 = normalizeResult25;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( ( (v.vertex.xyz).x * Right20 ) + ( (v.vertex.xyz).y * Up26 ) );
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
				float2 uv_TextureSample0 = i.ase_texcoord1.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float4 color39 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
				
				
				finalColor = ( tex2D( _TextureSample0, uv_TextureSample0 ) * color39 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18912
349.6;303.2;1230.4;670.2;62.72679;4.207039;1.3;True;True
Node;AmplifyShaderEditor.CommentaryNode;9;-1591.763,27.17543;Inherit;False;1318.564;298.3455;朝向摄像机方向的向量;6;3;4;5;6;7;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;3;-1541.763,83.82821;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;4;-1295.692,78.45668;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;5;-1058.842,168.321;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;6;-898.8416,77.92102;Inherit;False;Property;_Type;Type;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;Spherical;Cylindrical;Create;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;7;-652.3992,82.77545;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-497.9995,77.17545;Inherit;False;Forward;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;21;-1587.612,369.0281;Inherit;False;1319.479;538.6223;向前向量和（0，1，0）叉乘计算向右向量，正向下或者向上的时候，无法计算，所以叉乘计算的向量为（0，0，1）;9;17;16;15;14;13;12;18;10;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;10;-1537.612,419.0281;Inherit;False;8;Forward;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;12;-1342.535,486.8504;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;16;-1273.733,569.2505;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.AbsOpNode;13;-1145.734,491.6503;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;17;-1271.333,722.0504;Inherit;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ConditionalIfNode;15;-1017.733,491.6504;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0.999;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode;14;-816.1342,424.4504;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;18;-650.5325,424.4506;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-492.9328,419.6506;Inherit;False;Right;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;27;-1012.953,956.2975;Inherit;False;746.8012;250.9995;重新计算向上向量;5;24;23;22;25;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-960.5538,1091.896;Inherit;False;8;Forward;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-962.9534,1006.297;Inherit;False;20;Right;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode;24;-795.7535,1039.897;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;25;-644.5522,1039.896;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;28;48.16739,502.1188;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-490.952,1035.897;Inherit;False;Up;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;500.5885,618.715;Inherit;False;26;Up;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;31;261.3885,558.715;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;498.1885,517.1151;Inherit;False;20;Right;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;30;258.9885,457.1151;Inherit;False;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;428.1533,67.55296;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;39;515.5132,265.1528;Inherit;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;670.9886,461.9149;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;671.7886,563.5148;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;771.3531,246.433;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;803.7885,505.1151;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BillboardNode;2;966.8703,622.9291;Inherit;False;Cylindrical;False;0;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;948.4483,480.5533;Float;False;True;-1;2;ASEMaterialInspector;100;1;Samples/Billboard_ASE;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;5;4;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;3;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;DisableBatching=True=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;0;0;1;True;False;;False;0
WireConnection;4;0;3;0
WireConnection;5;0;4;1
WireConnection;5;2;4;3
WireConnection;6;1;4;0
WireConnection;6;0;5;0
WireConnection;7;0;6;0
WireConnection;8;0;7;0
WireConnection;12;0;10;0
WireConnection;13;0;12;0
WireConnection;15;0;13;0
WireConnection;15;2;16;0
WireConnection;15;3;17;0
WireConnection;15;4;17;0
WireConnection;14;0;10;0
WireConnection;14;1;15;0
WireConnection;18;0;14;0
WireConnection;20;0;18;0
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;25;0;24;0
WireConnection;26;0;25;0
WireConnection;31;0;28;0
WireConnection;30;0;28;0
WireConnection;32;0;30;0
WireConnection;32;1;33;0
WireConnection;35;0;31;0
WireConnection;35;1;34;0
WireConnection;40;0;37;0
WireConnection;40;1;39;0
WireConnection;36;0;32;0
WireConnection;36;1;35;0
WireConnection;1;0;40;0
WireConnection;1;1;36;0
ASEEND*/
//CHKSM=FC883B50F55D5D43A7D16A35A6964E37AC24812F