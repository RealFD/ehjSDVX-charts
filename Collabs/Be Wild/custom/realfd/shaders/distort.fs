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

// Control parameters for glitch intensity
uniform float u_noiseIntensityX = 0.1;  // Controls horizontal noise distortion
uniform float u_noiseIntensityY = 0.02; // Controls vertical noise distortion
uniform float u_redOffset = 0.05;       // Offset amount for the red channel
uniform float u_blueOffset = -0.03;     // Offset amount for the blue channel
uniform float u_scale = 400.0;          // Scaling factor for UV manipulation

// Simple 2D noise function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(
        mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
        mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
        u.y
    );
}

// Function to create glitchy distortion
vec2 glitchDistortion(vec2 uv, float time) {
    float offsetX = noise(uv * 10.0 + time * 5.0) * u_noiseIntensityX;  // Horizontal distortion
    float offsetY = noise(uv * 20.0 - time * 5.0) * u_noiseIntensityY;  // Vertical distortion
    return vec2(uv.x + offsetX, uv.y + offsetY);
}

void main() {
    vec2 uv = fsTex;
    
    // Apply glitch distortion to the UV coordinates
    vec2 distortedUV = glitchDistortion(uv, time);
    
    // Sample the color from the distorted UV coordinates
    vec4 color = texture(u_fb, distortedUV);
    
    // Control channel offsets for glitch effect
    vec2 redUV = uv + vec2(noise(uv * 10.0 + time * 10.0) * u_redOffset, 0.0);
    vec2 blueUV = uv + vec2(noise(uv * 5.0 - time * 8.0) * u_blueOffset, 0.0);
    
    // Sample color channels
    float red = texture(u_fb, redUV).r;
    float green = color.g;
    float blue = texture(u_fb, blueUV).b;
    
    // Construct glitch color
    vec3 glitchColor = vec3(red, green, blue);
    
    // Final color with alpha controlled by fade
    vec2 scaledUV = floor(uv * (u_scale - u_fade * u_scale)) / (u_scale - u_fade * u_scale);
    vec4 finalColor = texture(u_fb, scaledUV);
    
    // Ensure alpha channel is set to 1
    target = vec4(glitchColor, u_fade);
}
