#ifdef EMBEDDED
varying vec2 fsTex;
#else
#extension GL_ARB_separate_shader_objects : enable
layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;
#endif

uniform vec4 color;
uniform sampler2D myTexture;
uniform float time;
uniform float ksegments;

// Function to create a kaleidoscope effect
vec2 kaleidoscope(vec2 uv, float segments) {
    float angle = atan(uv.y, uv.x);
    float radius = length(uv);
    angle = mod(angle, 2.0 * 3.14159 / segments);
    return vec2(cos(angle), sin(angle)) * radius;
}

// Function to generate a sine wave distortion
vec2 sineDistortion(vec2 uv, float frequency, float amplitude, float phase) {
    uv.x += sin(uv.y * frequency + phase) * amplitude;
    uv.y += sin(uv.x * frequency + phase) * amplitude;
    return uv;
}

void main() {
    // Center the coordinates around (0.5, 0.5)
    vec2 uv = fsTex - 0.5;

    // Apply the kaleidoscope effect
    uv = kaleidoscope(uv, ksegments); // Increased to 12 segments for more complexity

    // Apply the sine wave distortion
    uv = sineDistortion(uv, 15.0, 0.1, time); // Increased frequency and amplitude

    // Sample the texture with the distorted coordinates
    vec4 texColor = texture(myTexture, uv + 0.5);

    // Create a color shift effect
    float offset = sin(time * 2.0) * 0.05; // Increased speed of color shift
    vec4 redChannel = texture(myTexture, uv + vec2(offset, 0.0) + 0.5);
    vec4 greenChannel = texture(myTexture, uv + vec2(-offset, offset) + 0.5);
    vec4 blueChannel = texture(myTexture, uv + vec2(0.0, -offset) + 0.5);

    // Combine the color channels with additional intensity
    vec4 finalColor = vec4(redChannel.r * 2.0, greenChannel.g * 2.0, blueChannel.b * 2.0, texColor.a);

    // Apply the final color with the uniform color
    target = finalColor * color;
}
