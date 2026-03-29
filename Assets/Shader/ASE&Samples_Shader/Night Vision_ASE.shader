// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/Night Vision_ASE"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Distortion("Distortion", Float) = 1
		_Scale("Scale", Float) = 0.3
		_Brightness("Brightness", Float) = 1
		_Tint("Tint", Color) = (0.6528301,0.6528301,0.6528301,0)
		_Saturation("Saturation", Float) = 1
		_Contrast("Contrast", Float) = 1
		_VignetteIntensity("VignetteIntensity", Float) = 1
		_VignetteFalloff("VignetteFalloff", Float) = 1
		_NoiseAmount("NoiseAmount", Float) = 0
		_NoiseMap("NoiseMap", 2D) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _NoiseMap;
			uniform float _NoiseAmount;
			uniform float _Contrast;
			uniform float _Distortion;
			uniform float _Scale;
			uniform float _Brightness;
			uniform float _Saturation;
			uniform float4 _Tint;
			uniform float _VignetteFalloff;
			uniform float _VignetteIntensity;
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 temp_output_51_0 = ( i.uv.xy * _NoiseAmount );
				float2 appendResult60 = (float2(( (temp_output_51_0).x + sin( 1.0 ) ) , ( (temp_output_51_0).y - sin( ( 1.0 + 1.0 ) ) )));
				float2 temp_output_3_0 = ( i.uv.xy - float2( 0.5,0.5 ) );
				float temp_output_8_0 = ( pow( (temp_output_3_0).x , 2.0 ) + pow( (temp_output_3_0).y , 2.0 ) );
				float distortion13 = ( ( sqrt( temp_output_8_0 ) * temp_output_8_0 * _Distortion ) + 1.0 );
				float4 ScreenWarp20 = tex2D( _MainTex, ( ( temp_output_3_0 * distortion13 * _Scale ) + float2( 0.5,0.5 ) ) );
				float4 temp_output_23_0 = ( ScreenWarp20 + _Brightness );
				float grayscale25 = Luminance(temp_output_23_0.rgb);
				float4 temp_cast_1 = (grayscale25).xxxx;
				float4 lerpResult26 = lerp( temp_cast_1 , temp_output_23_0 , _Saturation);
				float4 Image133 = ( CalculateContrast(_Contrast,lerpResult26) * _Tint );
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 Image247 = ( Image133 * pow( ( 1.0 - saturate( pow( distance( (ase_screenPosNorm).xy , float2( 0.5,0.5 ) ) , _VignetteFalloff ) ) ) , _VignetteIntensity ) );
				

				finalColor = ( tex2D( _NoiseMap, appendResult60 ) * Image247 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18912
560;51.2;1122.4;731;395.2695;-1363.699;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;14;-1118.92,-157.6183;Inherit;False;1999.861;531.3322;扭曲效果;12;13;12;10;11;9;8;2;3;7;5;6;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;2;-1080.327,-3.170959;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-858.1569,-3.024982;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;4;-570.3136,-107.6183;Inherit;False;FLOAT;0;1;2;3;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;5;-572.6052,122.6063;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;6;-411.1932,-102.8982;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;7;-414.285,126.7663;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-136.8701,-47.91514;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;9;131.1191,-103.3977;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;114.3191,21.40234;Inherit;False;Property;_Distortion;Distortion;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;278.854,-72.19764;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;492.0437,-72.10902;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;21;-873.71,395.7934;Inherit;False;1297.758;424.2346;screen 扭曲;7;1;19;15;16;17;18;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;636.8434,-77.70899;Inherit;True;distortion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-788.2682,667.2299;Inherit;False;Property;_Scale;Scale;1;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-823.71,584.59;Inherit;False;13;distortion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-610.9644,566.6281;Inherit;True;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-273.683,445.7934;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-386.3675,566.3511;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;19;-126.9751,538.6287;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;199.2479,539.3527;Inherit;False;ScreenWarp;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;30;-1107.459,925.743;Inherit;False;1030.225;298.6489;图像处理;8;27;26;25;24;23;22;28;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;48;-1146.209,1227.445;Inherit;False;1904.772;474.5946;暗角效果;12;47;44;43;42;40;41;37;39;38;36;35;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-1057.459,978.2482;Inherit;False;20;ScreenWarp;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1046.94,1052.081;Inherit;False;Property;_Brightness;Brightness;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-862.1398,1033.681;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;34;-1096.209,1349.012;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;25;-708.1713,975.743;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-667.3713,1094.143;Inherit;False;Property;_Saturation;Saturation;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;35;-884.4733,1349.566;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;36;-722.0724,1354.368;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-460.4343,1108.992;Inherit;False;Property;_Contrast;Contrast;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-708.9428,1586.639;Inherit;False;Property;_VignetteFalloff;VignetteFalloff;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;-479.3712,978.9431;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;28;-290.0342,978.5918;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;32;-48.9982,1102.785;Inherit;False;Property;_Tint;Tint;3;0;Create;True;0;0;0;False;0;False;0.6528301,0.6528301,0.6528301,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;38;-492.9425,1353.163;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1075.403,2056.134;Inherit;False;Constant;_RandomValue;Random Value;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1081.385,1939.791;Inherit;False;Property;_NoiseAmount;NoiseAmount;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;49;-1093.386,1794.99;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;211.0019,979.5853;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;39;-310.5425,1352.364;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;37;-151.3426,1351.564;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;399.0018,973.9854;Inherit;False;Image1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-173.7305,1570.794;Inherit;False;Property;_VignetteIntensity;VignetteIntensity;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-862.9858,1794.991;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-865.6465,2148.582;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;41;58.26953,1351.594;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;68.0275,1277.445;Inherit;False;33;Image1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;52;-695.8339,1789.429;Inherit;False;FLOAT;0;1;2;3;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;53;-691.034,1920.629;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;57;-705.6465,2164.582;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;55;-707.2466,2060.582;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-492.0459,1795.782;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;295.2275,1327.845;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;59;-492.8459,1924.581;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;60;-348.127,1840.875;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;514.4276,1322.244;Inherit;True;Image2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;61;-196.9269,1812.876;Inherit;True;Property;_NoiseMap;NoiseMap;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;63;-76.92688,2021.676;Inherit;False;47;Image2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;130.2731,1818.475;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;312.901,1819.593;Float;False;True;-1;2;ASEMaterialInspector;0;2;Hidden/Night Vision_ASE;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;3;0;2;0
WireConnection;4;0;3;0
WireConnection;5;0;3;0
WireConnection;6;0;4;0
WireConnection;7;0;5;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;9;0;8;0
WireConnection;10;0;9;0
WireConnection;10;1;8;0
WireConnection;10;2;11;0
WireConnection;12;0;10;0
WireConnection;13;0;12;0
WireConnection;15;0;3;0
WireConnection;15;1;16;0
WireConnection;15;2;17;0
WireConnection;18;0;15;0
WireConnection;19;0;1;0
WireConnection;19;1;18;0
WireConnection;20;0;19;0
WireConnection;23;0;22;0
WireConnection;23;1;24;0
WireConnection;25;0;23;0
WireConnection;35;0;34;0
WireConnection;36;0;35;0
WireConnection;26;0;25;0
WireConnection;26;1;23;0
WireConnection;26;2;27;0
WireConnection;28;1;26;0
WireConnection;28;0;29;0
WireConnection;38;0;36;0
WireConnection;38;1;40;0
WireConnection;31;0;28;0
WireConnection;31;1;32;0
WireConnection;39;0;38;0
WireConnection;37;0;39;0
WireConnection;33;0;31;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;56;0;54;0
WireConnection;41;0;37;0
WireConnection;41;1;42;0
WireConnection;52;0;51;0
WireConnection;53;0;51;0
WireConnection;57;0;56;0
WireConnection;55;0;54;0
WireConnection;58;0;52;0
WireConnection;58;1;55;0
WireConnection;44;0;43;0
WireConnection;44;1;41;0
WireConnection;59;0;53;0
WireConnection;59;1;57;0
WireConnection;60;0;58;0
WireConnection;60;1;59;0
WireConnection;47;0;44;0
WireConnection;61;1;60;0
WireConnection;62;0;61;0
WireConnection;62;1;63;0
WireConnection;0;0;62;0
ASEEND*/
//CHKSM=A310E79E208655B4747EC6E6D2BFCEA0677F1463