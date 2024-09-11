#version 330
#extension GL_ARB_separate_shader_objects : enable

layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;

uniform sampler2D u_bg;

void main()
{
	vec3 col = texture(u_bg,fsTex).xyz;
	target = vec4(col,1.);
}
