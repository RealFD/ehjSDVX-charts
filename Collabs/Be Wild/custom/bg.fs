#version 330
#extension GL_ARB_separate_shader_objects : enable

layout(location=1) in vec2 texVp;
layout(location=0) out vec4 target;

uniform ivec2 screenCenter;
// x = bar time
// y = off-sync but smooth bpm based timing
// z = real time since song start
uniform vec3 timing;
uniform ivec2 viewport;
uniform float objectGlow;

uniform sampler2D bgTex;
uniform vec2 tilt;
uniform float clearTransition;

void main()
{
  target = vec4(0.0, 0.0, 0.0, 0.0);
}
