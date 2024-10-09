#ifdef EMBEDDED
varying vec2 fsTex;
#else
#extension GL_ARB_separate_shader_objects : enable
layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D u_fb;
uniform float u_fade;

// Random number generator based on coordinates
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    // RGB channel shifting offsets
    vec2 redOffset = vec2(0.0075, 0.0);
    vec2 greenOffset = vec2(0.0, 0.0075);
    vec2 blueOffset = vec2(-0.0075, 0.0);

    // Sample the base texture color
    vec4 texColor = texture(u_fb, fsTex);

    // Sample individual color channels with respective offsets
    vec4 redChannel = texture(u_fb, fsTex + redOffset);
    vec4 greenChannel = texture(u_fb, fsTex + greenOffset);
    vec4 blueChannel = texture(u_fb, fsTex + blueOffset);

    // Apply color shifts to the RGB channels
    texColor = vec4(redChannel.r, greenChannel.g, blueChannel.b, texColor.a);

    // Random horizontal displacement effect
    float displacement = 0.01 * rand(vec2(time, fsTex.y));
    vec2 displacedTexCoords = fsTex + vec2(displacement, 0.0);
    vec4 displacedColor = texture(u_fb, displacedTexCoords);

    // Add a subtle noise pattern
    float noise = 0.05 * rand(fsTex * 10.0); // Adjust noise intensity and frequency
    vec4 noiseColor = vec4(noise, noise, noise, 0.0);
    texColor += noiseColor;

    // Combine all effects with a blend
    target = mix(texColor, displacedColor, 0.5);
    target.a = u_fade;  // Set the alpha based on the fade uniform
}
