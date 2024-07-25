#ifdef EMBEDDED
varying vec2 fsTex;
#else
#extension GL_ARB_separate_shader_objects : enable
layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;
#endif

uniform float time;
uniform float beat;
uniform vec2 resolution;

void main() {
    vec2 uv = fsTex;
    vec2 center = vec2(0.5, 0.5);
    
    float dist = distance(uv, center);
    float pulse = sin(dist * 20.0 - beat * 5.0) * 0.5 + 0.5;
    
    vec3 color = vec3(pulse*0.1, pulse * 0.5, pulse * 0.3);
    target = vec4(color, 1.0);
}
