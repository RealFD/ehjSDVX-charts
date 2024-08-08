#extension GL_ARB_separate_shader_objects : enable

layout(location=0) in vec3 inPos;
layout(location=1) in vec2 inTex;

out gl_PerVertex
{
    vec4 gl_Position;
};
layout(location=1) out vec2 fsTex;

uniform mat4 proj;
uniform mat4 camera;
uniform mat4 world;
uniform int uIndex;

mat3 rotationX(float angle) {
    return mat3(    1.0,        0,            0,
                     0,     cos(angle),    -sin(angle),
                    0,     sin(angle),     cos(angle));
}

mat3 rotationY(float angle) {
    return mat3(    cos(angle),        0,        sin(angle),
                             0,        1.0,             0,
                    -sin(angle),    0,        cos(angle));
}

mat3 rotationZ(float angle) {
    return mat3(    cos(angle),        -sin(angle),    0,
                     sin(angle),        cos(angle),        0,
                            0,                0,        1);
}

void main()
{
    fsTex = inTex;
    vec4 pos = vec4(inPos, 1.0);
         if (uIndex >= 0){
        pos = vec4(inPos*.15, 1.0);
        pos.x += .085;
        pos.y += .085;
     }
     if (uIndex >= 4){
        pos = vec4(inPos, 1.0);
     }
    pos = proj * camera * world * pos;
    gl_Position = pos;
}
