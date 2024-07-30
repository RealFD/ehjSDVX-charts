#extension GL_ARB_separate_shader_objects : enable

layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;

uniform sampler2D Texture;

void main()
{
    // Sample the texture
    vec4 texColor = texture(Texture, fsTex);

    // Simulate a Fresnel effect using the texture coordinates
    // We use the length of the texture coordinates vector to simulate the angle
    float fresnelFactor = pow(1.0 - dot(normalize(vec3(fsTex * 2.0 - 1.0, 1.0)), vec3(0.0, 0.0, 1.0)), 3.0) * 0.5 + 0.5;

    // Apply the Fresnel effect
    vec4 fresnelColor = texColor * vec4(fresnelFactor, fresnelFactor, fresnelFactor, 1.0);

    target = fresnelColor;
}
