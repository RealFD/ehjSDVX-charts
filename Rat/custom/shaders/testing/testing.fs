#ifdef EMBEDDED
varying vec2 fsTex;
#else
#extension GL_ARB_separate_shader_objects : enable
layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;
#endif

void main()
{
	float x = fsTex.x;
	float y = fsTex.y;

	target = vec4(x,y,1.0,1.0);
}