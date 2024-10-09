#version 330
#extension GL_ARB_separate_shader_objects : enable

layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;

uniform sampler2D u_cl;

void main()
{
	target = texture(u_cl,fsTex);
	target.a = 1.;
	return;
}
