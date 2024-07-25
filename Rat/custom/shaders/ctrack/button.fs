#ifdef EMBEDDED
varying vec2 fsTex;
varying vec4 position;
#else
#extension GL_ARB_separate_shader_objects : enable
layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;
in vec4 position;
#endif

uniform sampler2D myTexture1;
uniform bool hasSample;

uniform float trackPos;
uniform float trackScale;
uniform float hiddenCutoff;
uniform float hiddenFadeWindow;
uniform float suddenCutoff;
uniform float suddenFadeWindow;

uniform vec3 uColor;

#ifdef EMBEDDED
void main() {
	vec4 mainColor = texture(myTexture1, fsTex.xy);
	if(hasSample)
	{
		float addition = abs(0.5 - fsTex.x) * - 1.;
		addition += 0.2;
		addition = max(addition,0.);
		addition *= 2.8;
		mainColor.xyzw += addition;
	}

	target = mainColor;
}

#else

float hide() {
	float off = trackPos + position.y * trackScale;

	if (hiddenCutoff > suddenCutoff) {
		float sudden = smoothstep(suddenCutoff, suddenCutoff - suddenFadeWindow, off);
		float hidden = smoothstep(hiddenCutoff, hiddenCutoff + hiddenFadeWindow, off);
		return min(hidden + sudden, 1.0);
	}

	float sudden = smoothstep(suddenCutoff + suddenFadeWindow, suddenCutoff, off);
	float hidden = smoothstep(hiddenCutoff - hiddenFadeWindow, hiddenCutoff, off);

	return hidden * sudden;
}

void main() {
	vec4 mainColor = texture(myTexture1, fsTex.xy);
	if (hasSample) {
		//float addition = abs(0.5 - fsTex.x) * - 1.;
		//addition += 0.2;
		//addition = max(addition,0.);
		//addition *= 2.8;
		//mainColor.xyzw += addition;
		float xa = abs(0.5 - fsTex.x);
		float ya = 1.0-abs(0.5-fsTex.y)-(1.0-xa);
		mainColor.xyz *= 1.0-ya*2.5;
	}
	
	//mainColor.xyz *= uColor;
	target = mainColor;
	target *= hide();
}
#endif
