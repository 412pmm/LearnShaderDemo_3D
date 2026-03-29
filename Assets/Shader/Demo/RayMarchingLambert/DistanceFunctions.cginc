// Sphere
// s: radius
float sdSphere(float3 p, float s)
{
	return length(p) - s;
}

// Box
// b: size of box in x/y/z
float sdBox(float3 p, float3 b)
{
	float3 d = abs(p) - b;
	return min(max(d.x, max(d.y, d.z)), 0.0) + length(max(d, 0.0));
}

float sdRoundBox(float3 p, float3 b, float r)
{
	float3 d = abs(p) - b + r;
	return length(max(d, 0.0)) + min(max(d.x, max(d.y, d.z)), 0.0) - r;
}

float sdPlane(float3 p, float4 n)
{
	// 法线n一定要进行归一化
	return dot(p, n.xyz) + n.w;
}

float smin( float a, float b, float k )
{
	k *= 1.0/(1.0-sqrt(0.5));
	float h = max( k-abs(a-b), 0.0 )/k;
	return min(a,b) - k*0.5*(1.0+h-sqrt(1.0-h*(h-2.0)));
}

// BOOLEAN OPERATORS //

// Union
//float opU(float d1, float d2)
//{
//	return min(d1, d2);
//}
float4 opU(float4 d1, float4 d2)
{
	return (d1.w<d2.w) ? d1 : d2;
}

// Subtraction
float opS(float d1, float d2)
{
	return max(-d1, d2);
}

// Intersection
float opI(float d1, float d2)
{
	return max(d1, d2);
}

float4 opUS( float4 d1, float4 d2, float k ) 
{
    float h = clamp( 0.5 + 0.5*(d2.w-d1.w)/k, 0.0, 1.0 );
	float3 color = lerp(d2.rgb, d1.rgb, h);
    float dist = lerp( d2.w, d1.w, h ) - k*h*(1.0-h); 
	return float4(color,dist);
}

// 以上的 opUS 多个小球累计叠加的平滑效果并不理想， 下面两个均可
//float disOpUS（float d1，float d2，float k）
//{
//    float res = exp（-k * d1）+ exp（-k * d2）;
//    return - log（res）/ k;
//}

float disOpUS(float d1, float d2, float k)
{
    float h = max(k - abs(d1 - d2), 0) / k;
    float d = min(d1, d2) - h * h * h * k * 1 / 6.0;
    return d;
}

float opSS( float d1, float d2, float k ) 
{
    float h = clamp( 0.5 - 0.5*(d2+d1)/k, 0.0, 1.0 );
    return lerp( d2, -d1, h ) + k*h*(1.0-h); 
}

float opIS( float d1, float d2, float k ) 
{
    float h = clamp( 0.5 - 0.5*(d2-d1)/k, 0.0, 1.0 );
    return lerp( d2, d1, h ) + k*h*(1.0-h); 
}

// Mod Position Axis
float pMod1 (inout float p, float size)
{
	float halfsize = size * 0.5;
	float c = floor((p+halfsize)/size);
	p = fmod(p+halfsize,size)-halfsize;
	p = fmod(-p+halfsize,size)-halfsize;
	return c;
}