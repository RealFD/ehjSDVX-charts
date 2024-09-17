#version 330
#extension GL_ARB_separate_shader_objects : enable

layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;

uniform sampler2D u_cl;
uniform float u_opacity;
uniform vec3 u_col;

void main()
{
	target = texture(u_cl,fsTex);
	target.xyz *= u_col;
	target.xyz *= target.a*1.25;
	target.xyz *= u_opacity;
	return;
}
