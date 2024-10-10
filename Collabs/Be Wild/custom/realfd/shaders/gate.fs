// shadertoy https://www.shadertoy.com/view/ltBfDt

#ifdef GL_ES
precision highp float;
#endif

#ifdef EMBEDDED
varying vec2 fsTex;
#else
#extension GL_ARB_separate_shader_objects : enable
layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;
#endif

// Uniforms
uniform float u_time;
uniform vec2 u_resolution;
uniform float u_gateSize;
uniform float u_gateAlpha;
uniform vec3 color;

// Random noise function
float random(in vec2 p) { 
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

// 2D noise function
float noise(in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) + 
           (c - a) * u.y * (1.0 - u.x) + 
           (d - b) * u.x * u.y;
}

// Light intensity function
float light(in vec2 pos, in float size, in float radius, in float inner_fade, in float outer_fade) {
    float len = length(pos / size);
    return pow(clamp((1.0 - pow(clamp(len - radius, 0.0, 1.0), 1.0 / inner_fade)), 0.0, 1.0), 1.0 / outer_fade);
}

// Flare generation function
float flare(in float angle, in float alpha, in float time) {
    float t = time;
    float n = noise(vec2(t + 0.5 + abs(angle) + pow(alpha, 0.6), t - abs(angle) + pow(alpha + 0.1, 0.6)) * 7.0);
    float split = (15.0 + sin(t * 2.0 + n * 4.0 + angle * 20.0 + alpha * 1.0 * n) * (0.3 + 0.5 + alpha * 0.6 * n));
    float rotate = sin(angle * 20.0 + sin(angle * 15.0 + alpha * 4.0 + t * 30.0 + n * 5.0 + alpha * 4.0)) * (0.5 + alpha * 1.5);
    float g = pow((2.0 + sin(split + n * 1.5 * alpha + rotate) * 1.4) * n * 4.0, n * (1.5 - 0.8 * alpha));
    
    g *= alpha * alpha * alpha * 0.5;
    g += alpha * 0.7 + g * g * g;
    return g;
}

// Constants for sizing and fading
#define SIZE 2.8
#define RADIUS 0.07
#define INNER_FADE 0.8
#define OUTER_FADE 0.02
#define SPEED 0.1
#define BORDER 0.21

void main() {
    //vec2 uv = (fsTex.xy - u_resolution.xy * 0.5) / u_resolution.y;
    //uv *= u_gateSize;

    vec2 uv = fsTex;
    uv = uv*2.-1.;
    uv *= u_gateSize;
    float aspect = u_resolution.x/u_resolution.y;
    //uv.x *= aspect;
	float f = .0;
    float f2 = .0;
    float t = u_time * SPEED;
	float alpha = light(uv,SIZE,RADIUS,INNER_FADE,OUTER_FADE);
	float angle = atan(uv.x,uv.y);
    float n = noise(vec2(uv.x*20.+u_time,uv.y*20.+u_time));
   
	float l = length(uv);

    // Smooth transition for the dark core and outer flame
    float innerRadius = RADIUS; // Adjust inner radius based on sun size
    float innerAlpha = smoothstep(innerRadius - INNER_FADE, innerRadius, l);

	if(l < BORDER){
        t *= .8;
        alpha = (1. - pow(((BORDER - l)/BORDER),0.22)*0.7);
        alpha = clamp(alpha-light(uv,0.2,0.0,1.3,.7)*.55,.0,1.);
        f = flare(angle*1.0,alpha,-t*.5+alpha);
        f2 = flare(angle*1.0,alpha*1.2,((-t+alpha*.5+0.38134)));
        alpha = 1.;
	}else if(alpha < 0.001){
		f = alpha;
	}else{
		f = flare(angle,alpha,t)*1.3;
	}

    //// Core and flame colors
    vec3 coreColor = vec3(0.0, 0.0, 0.0); // Core color (black)
    vec3 flameColor = color; // Flame color from uniform

    //// Create flame-like color around the sun
    float dist = length(uv);
    float flameIntensity = smoothstep(innerRadius + INNER_FADE, innerRadius + INNER_FADE + 0.2, dist);
    vec3 finalFlameColor = mix(flameColor, vec3(0.0, 1.0, 0.0), flameIntensity); // Blend with black

    //// Combine core and flame colors
    vec3 finalColor = mix(coreColor, finalFlameColor * (f + f2 * 0.5), innerAlpha);

    alpha = alpha * alpha;
    // Set the fragment color
    target = vec4(finalColor, alpha*u_gateAlpha); // Use the finalColor for output
}
