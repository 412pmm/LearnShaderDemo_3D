// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Samples/Dissolve_ASE"
{
	Properties
	{
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		[NoScaleOffset]_Normal("Normal", 2D) = "white" {}
		[NoScaleOffset]_Specular("Specular", 2D) = "white" {}
		[NoScaleOffset]_AO("AO", 2D) = "white" {}
		_DissolveNoise("Dissolve Noise", 2D) = "white" {}
		_Dissolve("Dissolve", Range( 0 , 1)) = 0.5369276
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_EdgeRange("Edge Range", Range( 2 , 100)) = 60.99403
		[NoScaleOffset]_EdgeGradient("Edge Gradient", 2D) = "white" {}
		_Brightness("Brightness", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _Albedo;
		uniform float _Brightness;
		uniform sampler2D _EdgeGradient;
		uniform sampler2D _DissolveNoise;
		uniform float4 _DissolveNoise_ST;
		uniform float _Dissolve;
		uniform float _EdgeRange;
		uniform sampler2D _Specular;
		uniform sampler2D _AO;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Normal11 = i.uv_texcoord;
			o.Normal = tex2D( _Normal, uv_Normal11 ).rgb;
			float2 uv_Albedo10 = i.uv_texcoord;
			o.Albedo = tex2D( _Albedo, uv_Albedo10 ).rgb;
			float2 uv_DissolveNoise = i.uv_texcoord * _DissolveNoise_ST.xy + _DissolveNoise_ST.zw;
			float ClipMask7 = saturate( ( tex2D( _DissolveNoise, uv_DissolveNoise ).r - (_Dissolve*2.0 + -1.0) ) );
			float2 temp_cast_2 = (saturate( (ClipMask7*_EdgeRange + ( _EdgeRange * -0.5 )) )).xx;
			o.Emission = ( _Brightness * tex2D( _EdgeGradient, temp_cast_2 ) ).rgb;
			float2 uv_Specular14 = i.uv_texcoord;
			float4 tex2DNode14 = tex2D( _Specular, uv_Specular14 );
			o.Specular = tex2DNode14.rgb;
			o.Smoothness = tex2DNode14.a;
			float2 uv_AO15 = i.uv_texcoord;
			o.Occlusion = tex2D( _AO, uv_AO15 ).r;
			o.Alpha = 1;
			clip( ClipMask7 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
52;48;1409.6;751;1490.831;-227.2233;1.777014;True;True
Node;AmplifyShaderEditor.CommentaryNode;9;-1036,-30.70001;Inherit;False;1151.081;472.8;消融的mask;5;6;1;2;3;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;6;-986,230.1;Inherit;False;555.6001;212;2*Dissolve-1;2;4;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-935.9999,280.1;Inherit;False;Property;_Dissolve;Dissolve;6;0;Create;True;0;0;0;False;0;False;0.5369276;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-765.6,19.29999;Inherit;True;Property;_DissolveNoise;Dissolve Noise;5;0;Create;True;0;0;0;False;0;False;-1;0a141686f948fe3459522bf0174d6ef6;0a141686f948fe3459522bf0174d6ef6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;5;-647.9999,284.9;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2;-424.7998,47.30003;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;21;-1275.102,1107.66;Inherit;False;874.0934;375.241;计算：对ClipMask的数值范围进行重新映射，使得白色区域和黑色区域增大，中间灰度的区域缩小：Input × Scale - 0.5 × Scale;4;20;19;18;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;3;-263.9997,45.70004;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-109.7191,41.06903;Inherit;True;ClipMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1225.102,1363.629;Inherit;False;Property;_EdgeRange;Edge Range;8;0;Create;True;0;0;0;False;0;False;60.99403;0;2;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-1212.187,1157.66;Inherit;True;7;ClipMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-931.3852,1368.861;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-319.1358,1112.467;Inherit;False;214.8;160.4;重新对范围进行限制;1;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;20;-759.009,1163.33;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;-269.1358,1162.467;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-647.3895,720.3951;Inherit;True;Property;_Specular;Specular;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;d7717e143ae46454bb707166f46451fe;d7717e143ae46454bb707166f46451fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;-90.56129,1133.451;Inherit;True;Property;_EdgeGradient;Edge Gradient;9;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;dd934530b723b604aafe881ee791afcd;dd934530b723b604aafe881ee791afcd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;32.96081,1036.7;Inherit;False;Property;_Brightness;Brightness;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1214.802,673.2321;Inherit;True;Property;_Normal;Normal;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;32e5f8fe8aacd7e449419c15d286f914;32e5f8fe8aacd7e449419c15d286f914;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-364.1426,763.5873;Inherit;True;Property;_AO;AO;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;553706526724bae4d82877f70f09f4f2;553706526724bae4d82877f70f09f4f2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;16;-28.84038,837.752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;8;11.10614,877.2101;Inherit;False;7;ClipMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-1491.601,647.632;Inherit;True;Property;_Albedo;Albedo;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;c13f3b20a52528e45840309e9005fe8e;c13f3b20a52528e45840309e9005fe8e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-931.0387,696.3179;Inherit;True;Property;_Emission;Emission;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;a2f47d388fd76f44b976e189dcc4d998;a2f47d388fd76f44b976e189dcc4d998;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;195.6315,1115.099;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;409.2386,647.9973;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Samples/Dissolve_ASE;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;7;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;4;0
WireConnection;2;0;1;1
WireConnection;2;1;5;0
WireConnection;3;0;2;0
WireConnection;7;0;3;0
WireConnection;18;0;17;0
WireConnection;20;0;19;0
WireConnection;20;1;17;0
WireConnection;20;2;18;0
WireConnection;22;0;20;0
WireConnection;24;1;22;0
WireConnection;16;0;14;4
WireConnection;26;0;25;0
WireConnection;26;1;24;0
WireConnection;0;0;10;0
WireConnection;0;1;11;0
WireConnection;0;2;26;0
WireConnection;0;3;14;0
WireConnection;0;4;16;0
WireConnection;0;5;15;0
WireConnection;0;10;8;0
ASEEND*/
//CHKSM=B868736F68FE7B9A8FAACA8687E2425CB8F661BF