#version 450

layout(push_constant) uniform Push
{
	float GAMMA_INPUT;
} params;

#pragma parameter GAMMA_INPUT "Gamma Input" 2.4 0.1 5.0 0.05
#define GAMMA_INPUT params.GAMMA_INPUT

layout(std140, set = 0, binding = 0) uniform UBO
{
	mat4 MVP;
} global;

#pragma stage vertex
layout(location = 0) in vec4 Position;
layout(location = 1) in vec2 TexCoord;
layout(location = 0) out vec2 vTexCoord;

void main()
{
   gl_Position = global.MVP * Position;
   vTexCoord = TexCoord;
}

#pragma stage fragment
layout(location = 0) in vec2 vTexCoord;
layout(location = 0) out vec4 FragColor;
layout(set = 0, binding = 2) uniform sampler2D AfterglowPass;

#define PassPrev3Texture AfterglowPass
#define COMPAT_TEXTURE(c,d) texture(c,d)

void main()
{
   FragColor = pow(vec4(COMPAT_TEXTURE(PassPrev3Texture, vTexCoord)), vec4(GAMMA_INPUT));
}