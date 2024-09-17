#define core 300

uniform vec2 u_resolution;
uniform float u_time;

float ndot(vec2 a, vec2 b ) { return a.x*b.x - a.y*b.y; }
float sdRhombus( in vec2 p, in vec2 b ) 
{
    p = abs(p);
    float h = clamp( ndot(b-2.0*p,b)/dot(b,b), -1.0, 1.0 );
    float d = length( p-0.5*b*vec2(1.0-h,1.0+h) );
    return d * sign( p.x*b.y + p.y*b.x - b.x*b.y );
}

vec2 viewIndepUV() {
	vec2 uv = gl_FragCoord.xy/u_resolution.xy;
	float aspect = u_resolution.x/u_resolution.y;
	uv.x *= aspect;
	uv.x -= (aspect-1.0)*0.5;
	return uv;
}

void main(void)
{
	vec2 uv = viewIndepUV();
	vec2 ndc = uv * 2.0 - vec2(1.0);
	vec4 col = vec4(1.);
	ndc = ndc*1.02;
	vec2 q = abs(ndc)+.01;
	vec2 q2 = pow(q,vec2(.7));
	col.xyz = sdRhombus(q2,vec2(1.)) < 0. ? vec3(.5) : vec3(0.);
	if (sdRhombus(q2,vec2(1.))+.05 < 0.)
		col.xyz = vec3(0.);
	vec2 q1 = pow(q,vec2(abs(sin(u_time))*.7));
	col.xyz += sdRhombus(q1,vec2(1.)) < 0. ? vec3(1.) : vec3(0.);
	gl_FragColor = vec4(col.xyz, 1.0);
	//gl_FragColor = vec4(vec3(q,0.), 1.0);
}
