#ifdef GL_ES
precision highp float;
#endif

#ifdef EMBEDDED
varying vec2 fsTex;
#else
#extension GL_ARB_separate_shader_objects : enable
layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;
#endif 

in vec3 posVS;

// Uniforms
uniform float u_time;
uniform vec2 u_resolution;
uniform vec3 color;

uniform sampler2D tex1;

// Constants for sizing and fading
#define SIZE 2.8
#define RADIUS 0.07
#define INNER_FADE 0.8
#define OUTER_FADE 0.02
#define SPEED 0.1
#define BORDER 0.21

void main() {
    vec2 uv = fsTex;
    uv.y = 1.-uv.y;
    vec3 normal = texture(tex1,uv).xyz;
    normal = normal.yzx;

    float time = u_time*2.;
    vec3 lightPos = vec3(100.*sin(time),30.,100.*cos(time));

    // diffuse
    vec3 lightDir = normalize(lightPos-posVS);
    vec3 dif = vec3(dot(normal,lightDir));

    target = vec4(dif*vec3(0.,1.,0.),1.);
    //target = vec4(1.0);
}
