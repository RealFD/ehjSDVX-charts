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
uniform float bpm;

void main()
{
    // Compute the center of the texture
    vec2 center = vec2(0.5, 0.5);

    // Translate texture coordinates to center the rotation
    vec2 centeredCoords = fsTex - center;

    // Compute the rotation angle (clockwise)
    float angle = time * (bpm/2.0);

    // Apply rotation matrix
    vec2 rotatedCoords = vec2(
        centeredCoords.x * cos(angle) + centeredCoords.y * sin(angle),
        -centeredCoords.x * sin(angle) + centeredCoords.y * cos(angle)
    );

    // Translate texture coordinates back
    vec2 newTexCoords = rotatedCoords + center;

    // Sample the texture with the new coordinates
    vec4 texColor = texture(myTexture, newTexCoords);

    // Apply the color uniform
    target = texColor * color;
}
