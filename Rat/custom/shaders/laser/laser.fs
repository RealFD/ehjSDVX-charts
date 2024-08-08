#extension GL_ARB_separate_shader_objects : enable

layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;

uniform sampler2D Texture;
uniform int uIndex;
uniform float time;

uniform vec3 colorL;
uniform vec3 colorR;

// 0 = body, 1 = entry, 2 = exit
uniform int laserPart;

// 20Hz flickering. 0 = Miss, 1 = Inactive, 2 & 3 = Active alternating.
uniform int hitState;

const float laserSize = 1.25;

// Function to generate noise
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Function to shift color hue along a spectrum
vec3 hueShift(vec3 color, float shift)
{
    const vec3 k = vec3(0.299, 0.587, 0.114);
    float angle = shift * 6.28318;
    mat3 hueRotation = mat3(
        vec3(cos(angle) + k.x * (1.0 - cos(angle)), k.x * (1.0 - cos(angle)) - k.x * sin(angle), k.x * (1.0 - cos(angle)) + k.x * sin(angle)),
        vec3(k.y * (1.0 - cos(angle)) + k.y * sin(angle), cos(angle) + k.y * (1.0 - cos(angle)), k.y * (1.0 - cos(angle)) - k.y * sin(angle)),
        vec3(k.z * (1.0 - cos(angle)) - k.z * sin(angle), k.z * (1.0 - cos(angle)) + k.z * sin(angle), cos(angle) + k.z * (1.0 - cos(angle)))
    );
    return hueRotation * color;
}

void main()
{
    float x = fsTex.x;
    float y = fsTex.y;

    x += 0.125;

    x -= (laserSize / 2);
    x /= laserSize;
    x += (laserSize / 2);

    float intensity = 1.0 - abs(x - (laserSize / 2.0)) / (laserSize / 2.0);

    // Add noise to intensity
    float noise = random(fsTex * 100.0);
    intensity *= (0.9 + 0.9 * noise); 

    vec3 baseColor = (uIndex == 0) ? colorL : colorR;
    if (hitState == 2 || hitState == 3) {
        float shiftAmount = 0.5 * time;
        baseColor = hueShift(baseColor, 0.0); // Apply sinusoidal hue shift to the base color
    }

    // Create a basic bloom effect
    float bloomIntensity = pow(intensity, 2.0);
    vec3 bloomColor = baseColor * bloomIntensity * 15.0;

    vec4 color = vec4(baseColor, intensity);

    // Adjust intensity based on laser part
    if (laserPart == 0) {
        color = vec4(bloomColor, intensity);
    };
    if (laserPart == 1) {
        color = vec4(bloomColor, intensity *0.5);
    };
    if (laserPart == 2) {
        color = vec4(bloomColor, intensity *0.5);
    };

    // Blend the bloom with the original color for a glowing effect
    target = mix(color, vec4(bloomColor, 1.0), bloomIntensity * 0.5) * (0.25 * ceil(float(hitState)) + 0.01);
}
