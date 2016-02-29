
uniform sampler2D aTexture0;
uniform sampler2D aTexture1;
uniform sampler2D aTexture2;
uniform float ambientR, ambientG, ambientB;
varying float diffuse_value;
varying vec3 normal;
varying vec3 fNormal;

vec4 interpolate(vec4 c1, vec4 c2, float inter)
{
	return ( 1.0 - inter )* c1 + inter * c2;
}
void main() {
		vec2 texcoord = vec2(gl_TexCoord[0])*16.0;
    // Set the output color of our current pixel
		vec4 c = gl_Color;
		vec4 color = texture2D(aTexture0, vec2(c.r, c.g));
		float angle = normal.xyz;
		vec4 grass = texture2D(aTexture1, texcoord);
		vec4 rock = texture2D(aTexture2, texcoord/8);
		float gray = (grass.r+grass.g+grass.b)/3.0;
		grass = vec4(gray, gray, gray, 1.0);
		vec4 final = grass*color.rgba*angle+rock*(1.0-angle);
    gl_FragColor = diffuse_value * final + (final*vec4(ambientR, ambientG, ambientB, 1.0));
		
}

