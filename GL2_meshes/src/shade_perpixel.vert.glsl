// Vertex attributes, specified in the "attributes" entry of the pipeline
attribute vec3 vertex_position;
attribute vec3 vertex_normal;

// Per-vertex outputs passed on to the fragment shader

/* #TODO GL2.4
	Setup the varying values needed to compue the Phong shader:
	* surface normal
	* lighting vector: direction to light
	* view vector: direction to camera
*/
varying vec3 surface_normal;
varying vec3 view_vector;
varying vec3 light_vector;

// Global variables specified in "uniforms" entry of the pipeline
uniform mat4 mat_mvp;
uniform mat4 mat_model_view;
uniform mat3 mat_normals_to_view;

uniform vec3 light_position; //in camera space coordinates already


void main() {
	/** #TODO GL2.4:
	Setup all outgoing variables so that you can compute in the fragment shader
    the phong lighting. You will need to setup all the uniforms listed above, before you
    can start coding this shader.
	* surface normal
	* lighting vector: direction to light
	* view vector: direction to camera
    Hint: Compute the vertex position, normal and light_position in eye space.
    Hint: Write the final vertex position to gl_Position
    */
	// viewing vector (from camera to vertex in view coordinates), camera is at vec3(0, 0, 0) in cam coords
	//v2f_dir_from_view = vec3(1, 0, 0); // TODO calculate
	view_vector = normalize(-(mat_model_view * vec4(vertex_position, 1.0)).xyz);
	// direction to light source
	//v2f_dir_to_light = vec3(0, 1, 0); // TODO calculate
	light_vector = normalize(light_position - (mat_model_view * vec4(vertex_position, 1.0)).xyz);
	// transform normal to camera coordinates
	//v2f_normal = normal; // TODO apply normal 
	surface_normal = normalize(mat_normals_to_view * vertex_normal);
	
	gl_Position = mat_mvp * vec4(vertex_position, 1);
}
