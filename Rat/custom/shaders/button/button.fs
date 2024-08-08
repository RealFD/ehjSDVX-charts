#extension GL_ARB_separate_shader_objects : enable

layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;

uniform sampler2D Texture;
uniform int uIndex;

void main()
{
    vec4 texColor = texture(Texture, fsTex);
    vec4 color = vec4(1.0,1.0,1.0,1.0);
    if (uIndex == 0){
        color = vec4(1.0,0.0,0.0,1.0);
    }
    if (uIndex == 1){
        color = vec4(0.0,1.0,0.0,1.0);
    }
    if (uIndex == 2){
        color = vec4(0.0,0.0,1.0,1.0);
    }
    if (uIndex == 3){
        color = vec4(1.0,1.0,0.0,1.0);
    }
    if (uIndex == 4){
        color = vec4(1.0,0.5,0.0,1.0);
    }
    if (uIndex == 5){
        color = vec4(1.0,0.5,0.0,1.0);
    }
    if (uIndex == 5){
        color = vec4(1.0,0.5,0.0,1.0);
    }

    target = color;
}
