#extension GL_ARB_separate_shader_objects : enable

layout(location=0) in vec3 inPos;
layout(location=1) in vec2 inTex;


out gl_PerVertex
{
    vec4 gl_Position;
};
layout(location=1) out vec2 fsTex;

out vec3 posVS;

uniform mat4 proj;
uniform mat4 camera;
uniform mat4 world;
uniform mat4 u_cam;

void main()
{
    fsTex = inTex;
    vec4 pos = vec4(inPos, 1.0);
    posVS = pos.xyz;
    pos = proj * camera * world * inverse(u_cam) * pos;
    gl_Position = pos;
}
