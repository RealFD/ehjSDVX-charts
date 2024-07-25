#ifdef EMBEDDED
varying vec2 fsTex;
#else
#extension GL_ARB_separate_shader_objects : enable
layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;
#endif

uniform float timer;
uniform vec4 color;
uniform vec4 color1;

void main()
{
    vec2 uv = fsTex * 2.0 - 1.0;

    // Calculate polar coordinates
    float angle = atan(uv.y, uv.x);
    float radius = length(uv);

    // radius and time
    float adjustedRadius = radius + timer * 0.5;

    float gridSize = 0.1;
    float checker = mod(floor(adjustedRadius / gridSize) + floor(angle / (3.14159265 / 10.0)), 2.0);

    vec4 generatedColor = mix(color1, color, checker);

    float centerDarkness = smoothstep(0.0, 0.2, radius);
    generatedColor.rgb *= centerDarkness;


    float vignette = radius * 1.9;
    generatedColor.rgb *= vignette;


    target = generatedColor;
}
