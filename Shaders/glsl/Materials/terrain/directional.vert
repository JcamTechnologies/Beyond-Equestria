varying float diffuse_value;
varying vec3 normal;
varying vec3 fNormal;
void main() {            
		gl_TexCoord[0] = gl_MultiTexCoord0;
		
		vec3 P = gl_Vertex.xyz; 
		vec3 N = gl_Normal.xyz;
		
		normal = gl_Normal;
    // Calculate the normal value for this vertex, in world coordinates (multiply by gl_NormalMatrix)
    vec3 vertex_normal = normalize(gl_NormalMatrix * gl_Normal);
    // Calculate the light position for this vertex
    vec3 vertex_light_position = gl_LightSource[0].position.xyz;
    // Set the diffuse value (darkness). This is done with a dot product between the normal and the light
    // and the maths behind it is explained in the maths section of the site.
    diffuse_value = max(dot(vertex_normal, vertex_light_position), 0.0);

    // Set the front color to the color passed through with glColor*f
    gl_FrontColor = gl_Color;
    // Set the position of the current vertex 
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
		vec3 fNormal = normalize(gl_Position);
}

