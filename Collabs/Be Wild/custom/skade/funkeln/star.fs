#version 330
#extension GL_ARB_separate_shader_objects : enable

layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;

uniform float u_time;

float ndot(vec2 a, vec2 b ) { return a.x*b.x - a.y*b.y; }

// thx iq
float sdRhombus( in vec2 p, in vec2 b ) 
{
	p =	abs(p);
	float h	= clamp( ndot(b-2.0*p,b)/dot(b,b), -1.0, 1.0 );
	float d	= length( p-0.5*b*vec2(1.0-h,1.0+h)	);
	return d * sign( p.x*b.y + p.y*b.x - b.x*b.y );
}

void main(void)
{
	vec2 uv = fsTex;
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
	target = vec4(col.xyz, 1.0);
}
