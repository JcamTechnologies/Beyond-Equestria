uniform sampler2D aTexture0;
uniform sampler2D aTexture1;
uniform sampler2D aTexture2;
uniform sampler2D aTexture3;
uniform float ambientR, ambientG, ambientB;
varying float diffuse_value;
varying vec3 normal;

vec4 interpolate(vec4 c1, vec4 c2, float inter)
{
	return ( 1.0 - inter )* c1 + inter * c2;
}
void main() {
		vec2 texcoord = vec2(gl_TexCoord[0]);
    // Set the output color of our current pixel
		vec4 c = gl_Color;
		vec4 color = texture2D(aTexture0, vec2(c.r, c.g));
		float angle = 1.0-normal.y;
		vec4 grass = texture2D(aTexture1, texcoord*64.0);
		vec4 rock = texture2D(aTexture2, texcoord*32.0);
		vec4 sand = texture2D(aTexture3, texcoord*16.0);
		
		float gGray = 0.3+(grass.r+grass.g+grass.b)/3.0;
		grass = vec4(gGray, gGray, gGray, 1.0);
		grass = color*grass;
		
		float sGray = (sand.r+sand.g+sand.b)/3.0;
		sand = vec4(sGray, sGray, sGray, 1.0);
		sand = color*sand;
		
		vec4 snow = color* vec4(0.9, 0.9, 0.9, 1.0);
		
		vec4 tex;
		float dis = c.r;
		float disa = c.g;
		
		if(dis >= 0.5 && dis < 0.55 && disa > 0.55)
		{
			tex = interpolate(sand, grass, (dis - 0.5)*(1.0/(0.55 - 0.5)));
		}
		else if(dis >= 0.55  && disa > 0.55)
		{
			tex = sand;
		}
		else if(dis <= 0.3 && dis > 0.15)
		{
			tex = interpolate(snow, grass, (dis - 0.15)*(1.0/(0.3 - 0.15)));
		}
		else if(dis <= 0.15)
		{
			tex = snow;
		}
		else
		{
			tex = grass;
		}
		vec4 final;
		if(angle <= 0.07)
		{
			final = tex;
		}else if(angle > 0.07 && angle <= 0.5)
		{
			final = interpolate(tex, rock, (angle - 0.07)*(1.0/(0.5 - 0.07)));
		}
		else
		{
			final = rock;
		}
    gl_FragColor = diffuse_value * final + (final*vec4(ambientR, ambientG, ambientB, 1.0));
		
}

