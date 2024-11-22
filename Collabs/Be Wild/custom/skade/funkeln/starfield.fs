#version 330
#extension GL_ARB_separate_shader_objects : enable

layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;

uniform float u_time;
uniform sampler2D u_tex;
uniform float u_i;

void main(void)
{
	target = vec4(texture(u_tex,fsTex*(u_i)).xyz,1.);
}
