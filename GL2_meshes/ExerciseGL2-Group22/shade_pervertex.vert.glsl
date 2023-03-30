// Vertex attributes, specified in the "attributes" entry of the pipeline
attribute vec3 vertex_position;
attribute vec3 vertex_normal;

// Per-vertex outputs passed on to the fragment shader

/* #TODO GL2.3
	Pass the values needed for per-pixel
	Create a vertex-to-fragment variable.
*/
varying vec3 Intensity;

// Global variables specified in "uniforms" entry of the pipeline
uniform mat4 mat_mvp;
uniform mat4 mat_model_view;
uniform mat3 mat_normals_to_view;

uniform vec3 light_position; //in camera space coordinates already

uniform vec3 material_color;
uniform float material_shininess;
uniform vec3 light_color;

void main() {
	float material_ambient = 0.1;

	/** #TODO GL2.3 Gouraud lighting
	Compute the visible object color based on the Blinn-Phong formula.

	Hint: Compute the vertex position, normal and light_position in eye space.
	Hint: Write the final vertex position to gl_Position
	*/
	vec3 l = normalize(light_position - (mat_model_view * vec4(vertex_position, 1.0)).xyz);
	vec3 n = normalize(mat_normals_to_view * vertex_normal);
	vec3 v = normalize(-(mat_model_view * vec4(vertex_position, 1.0)).xyz);
	vec3 h = normalize(v+l);
	Intensity = light_color * material_color * material_ambient;
	if(dot(n,l) > 0.){
		Intensity = Intensity + light_color * material_color * dot(n,l);
		if(dot(n,h) > 0.){
			Intensity = Intensity + light_color * material_color * pow(dot(n,h),material_shininess);
		}
	}

	gl_Position = mat_mvp * vec4(vertex_position, 1);
}
