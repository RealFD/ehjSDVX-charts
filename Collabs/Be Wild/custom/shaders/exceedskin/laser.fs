#ifdef EMBEDDED
varying vec2 fsTex;
varying vec4 position;
#else
#extension GL_ARB_separate_shader_objects : enable
layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;
in vec4 position;
#endif

uniform sampler2D mainTex;

uniform sampler2D l_entry;
uniform sampler2D l_middle;
uniform sampler2D l_exit;

uniform sampler2D r_entry;
uniform sampler2D r_middle;
uniform sampler2D r_exit;

uniform vec4 l_color;
uniform vec4 r_color;

uniform int uIndex;     // Laser index (0 = left, 1 = right)
uniform int laserPart;  // Laser part (0 = body, 1 = entry, 2 = exit)
uniform int hitState;   // Hit state (0 = miss, 1 = inactive, 2/3 = active alternating)

const float laserSize = 1.0675;

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    float x = fsTex.x;

    x -= (laserSize / 2);
    x /= laserSize;
    x += (laserSize / 2);

    float y = 0.25 * ceil(float(hitState)) + 0.01;
    vec4 channels = texture(mainTex, vec2(x, y));

    vec3 baseColor = ((uIndex == 0) ? l_color.rgb : r_color.rgb) * channels.g;
    vec3 baseHsv = rgb2hsv(baseColor);

    float h = baseHsv.x;

    float hilightHue = 0.0;
    if (h < 2.0 / 12.0)
        hilightHue = 1.0 - smoothstep(0, 1.0 / 12.0, h);
    else 
        hilightHue = smoothstep(2.0 / 12.0, 6.0 / 12.0, h);

    hilightHue = mod((280.0 / 360.0) + (hilightHue * 140.0 / 360.0), 1.0);
    vec3 hilightColor = hsv2rgb(vec3(hilightHue, 1, 1));

    baseColor = baseColor * (1.0 - channels.b) + vec3(channels.b);

    vec3 mixedColor = clamp(mix(baseColor, hilightColor, channels.r), 0.0, 1.0);

    target = vec4(mixedColor, 1);

    if (laserPart == 1) {
        vec4 channels = texture(mainTex, fsTex);
        vec3 baseColor = ((uIndex == 0) ? l_color.rgb : r_color.rgb) * channels.g;
        vec3 baseHsv = rgb2hsv(baseColor);

        float h = baseHsv.x;
        float s = baseHsv.y;
        float v = baseHsv.z;

        float hilightHue = 0.0;

        if (s > 0.01 && h > 0.194 && h < 0.333) {
            float greenFactor = smoothstep(0.194, 0.333, h);
            hilightHue = mod((280.0 / 360.0) + (greenFactor * 140.0 / 360.0), 1.0);
        }

        vec3 hilightColor = hsv2rgb(vec3(hilightHue, s, v));

        vec3 finalColor;
        if (h >= 0.194 && h <= 0.333) {
            finalColor = hilightColor;
        } else {
            finalColor = baseColor;
        }

        // Blend colors based on channels
        finalColor = finalColor * (1.0 - channels.b) + vec3(channels.b);
        vec3 mixedColor = clamp(mix(baseColor, finalColor, channels.r), 0.0, 1.0);

        // Output final color
        target = vec4(mixedColor, 1);
        return;
    }
}

