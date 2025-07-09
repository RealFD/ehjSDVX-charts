#ifdef EMBEDDED
varying vec2 fsTex;
#else
#extension GL_ARB_separate_shader_objects : enable
layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;
#endif

uniform sampler2D mainTex;
uniform vec4 lCol;
uniform vec4 rCol;
uniform float hidden;

uniform vec4 l_color;
uniform vec4 r_color;

// Function to convert RGB to HSV
vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs((q.z + (q.w - q.y) / (6.0 * d + e))), d / (q.x + e), q.x);
}

// Function to convert HSV to RGB
vec3 hsv2rgb(vec3 c) {
    vec3 p = abs(fract(c.xxx + vec3(0.0, 1.0 / 3.0, 2.0 / 3.0)) * 6.0 - vec3(3.0));
    return c.z * mix(vec3(1.0), clamp(p - vec3(1.0), 0.0, 1.0), c.y);
}

// Function to apply a hue shift to a color
vec3 hueShift(vec3 color, float shift) {
    vec3 hsv = rgb2hsv(color);
    hsv.x = mod(hsv.x + shift, 1.0);
    return hsv2rgb(hsv);
}

void main()
{    
    vec4 mainColor = texture(mainTex, fsTex.xy);
    vec4 col = mainColor;

    if(fsTex.y > hidden)
    {
        // Apply hue shift to the red channel to color right lane
        vec3 rightLaneColor = hueShift(vec3(mainColor.x), 0.0); // example shift value
        col.xyz = vec3(.9) * r_color.xyz * rightLaneColor;

        // Apply hue shift to the blue channel to color left lane
        vec3 leftLaneColor = hueShift(vec3(mainColor.z), 0.3); // example shift value
        col.xyz += vec3(.9) * l_color.xyz * leftLaneColor;

        // Color green channel white
        col.xyz += vec3(.6) * vec3(mainColor.y);
    }
    else
    {
        col.xyz = vec3(0.);
        col.a = col.a > 0.0 ? 0.3 : 0.0;
    }
    target = col;
}
