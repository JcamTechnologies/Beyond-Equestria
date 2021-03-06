uniform sampler2D SceneBuffer : register(s0);
uniform float BufferWidth;
uniform float BufferHeight;

float4 main(float2 texCoord:TEXCOORD0):COLOR
{
	return tex2D(SceneBuffer, texCoord);
}

//======================================================================================
float4 downscale2x2(float2 texCoord:TEXCOORD0):COLOR
{
	float2 texSize = float2(1.0/BufferWidth, 1.0/BufferHeight);
	float4 average=0.0;
	const float2 samples[4] = {
		{-0.5, -0.5},
		{-0.5,  0.5},
		{ 0.5, -0.5},
		{ 0.5,  0.5}
    };
	for (int i=0; i<4; ++i)
	{
		average += tex2D(SceneBuffer, texCoord+texSize*samples[i]);
	}
	float4 finalCol = average*0.25f;
	return finalCol;
}

/*
//======================================================================================
#define FXAA_PC 1
#define FXAA_HLSL_3 1
#define FXAA_QUALITY__PRESET 12
#define FXAA_GREEN_AS_LUMA 1
#include "media/shaders/fxaa3_11.h"
FxaaFloat4 finalPassFXAA(float2 texCoord:TEXCOORD0):COLOR
{
	FxaaFloat2 fxaaQualityRcpFrame = FxaaFloat2(1.0/BufferWidth, 1.0/BufferHeight);
	FxaaFloat4 fxaaConsoleRcpFrameOpt = FxaaFloat4(-0.5/BufferWidth, -0.5/BufferHeight, 0.5/BufferWidth, 0.5/BufferHeight);
	FxaaFloat4 fxaaConsoleRcpFrameOpt2 = FxaaFloat4(-2.0/BufferWidth, -2.0/BufferHeight, 2.0/BufferWidth, 2.0/BufferHeight);
	FxaaFloat4 fxaaConsole360RcpFrameOpt2 = FxaaFloat4(8.0/BufferWidth, 8.0/BufferHeight, -4.0/BufferWidth, -4.0/BufferHeight);
	FxaaFloat fxaaQualitySubpix = 0.75;
	FxaaFloat fxaaQualityEdgeThreshold = 0.166;
	FxaaFloat fxaaQualityEdgeThresholdMin = 0.0625;
	FxaaFloat fxaaConsoleEdgeSharpness = 8.0;
	FxaaFloat fxaaConsoleEdgeThreshold = 0.125;
	FxaaFloat fxaaConsoleEdgeThresholdMin = 0.05;
	FxaaFloat4 fxaaConsole360ConstDir = FxaaFloat4(1.0, -1.0, 0.25, -0.25);
	FxaaFloat4 texCoord2 = FxaaFloat4(texCoord.x, texCoord.y, texCoord.x, texCoord.y)+fxaaConsoleRcpFrameOpt;
	
	return FxaaPixelShader(
		texCoord,
		texCoord2,
		SceneBuffer,
		SceneBuffer,
		SceneBuffer,
		fxaaQualityRcpFrame,
		fxaaConsoleRcpFrameOpt,
		fxaaConsoleRcpFrameOpt2,
		fxaaConsole360RcpFrameOpt2,
		fxaaQualitySubpix,
		fxaaQualityEdgeThreshold,
		fxaaQualityEdgeThresholdMin,
		fxaaConsoleEdgeSharpness,
		fxaaConsoleEdgeThreshold,
		fxaaConsoleEdgeThresholdMin,
		fxaaConsole360ConstDir);
}*/