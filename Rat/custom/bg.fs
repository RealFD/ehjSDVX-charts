#version 330
#extension GL_ARB_separate_shader_objects : enable

layout(location=1) in vec2 texVp;
layout(location=0) out vec4 target;
 
uniform ivec2 screenCenter;
uniform vec3 timing;
uniform ivec2 viewport;
uniform float objectGlow;
uniform vec2 tilt;
uniform float clearTransition;
uniform float LUAtimer;
uniform float LUAfadeOutTimer;

uniform float LUAalpha;
uniform float NUMOCTAVES;

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

float fbm ( in vec2 _st) {
    float t = 1.;
    float v = 0.;
    float a = 0.5;
    vec2 shift = vec2(120.0);
    // Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5), sin(0.5),
                    -sin(0.5), cos(0.5));
    for (int i = 0; i < NUMOCTAVES; ++i) {
        v += a * noise(vec3(_st, t));
        _st = rot * _st * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

vec2 addfbm(vec2 uv) {
    return uv + vec2(fbm(uv), fbm(uv+vec2(314.433623, 234.62324)));
}

vec3 makeImg(vec2 uv) {
    vec2 noiseUv = addfbm(uv);
    noiseUv.x += LUAtimer*.1;
    noiseUv = addfbm(noiseUv);
    noiseUv = addfbm(noiseUv);
    noiseUv = addfbm(noiseUv);
    noiseUv.x += LUAtimer*.1;
    noiseUv = addfbm(noiseUv);

    float m = fbm(noiseUv*5.);
    vec3 col = vec3(pow(m, 4.));
    return col;

}

// main
void main()
{

	vec2 center = vec2(screenCenter) / vec2(viewport);

	vec2 texCoordsCentered = (texVp - center)*.005;

	vec3 col = makeImg(texCoordsCentered);

	target = vec4(col,LUAalpha);
	return;
}