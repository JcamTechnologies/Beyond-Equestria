#version 330

in vec3 aPosition;

noperspective out vec2 vTexcoord;

void main() {
	vTexcoord = aPosition.xy * 0.5 + 0.5;
	gl_Position = vec4(aPosition.xy, 0.0, 1.0);
}