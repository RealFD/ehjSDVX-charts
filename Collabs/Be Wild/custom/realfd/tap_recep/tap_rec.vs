#version 330
#extension GL_ARB_separate_shader_objects : enable
layout(location=0) in vec3 inPos;
layout(location=1) in vec2 inTex;

out gl_PerVertex
{
	vec4 gl_Position;
};
layout(location=1) out vec2 fsTex;

uniform mat4 proj;
uniform mat4 world;
uniform mat4 camera;

uniform mat4 u_t;

void main()
{
	fsTex = inTex;
	gl_Position = proj * camera * world * u_t * vec4(inPos, 1);
}
