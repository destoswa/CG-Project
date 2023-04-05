precision highp float;

varying vec3 cam_surface_normal;
varying vec3 cam_vertex_position;
varying vec2 v2f_uv;

// Global variables specified in "uniforms" entry of the pipeline
uniform mat4 mat_mvp;
uniform mat4 mat_model_view;
uniform mat3 mat_normals_to_view;

uniform vec3 light_position; // light position in camera coordinates
uniform vec3 light_color;
uniform sampler2D tex_color;
uniform samplerCube cube_shadowmap;

void main() {
	float material_shininess = 12.;
	// Sample texture color at UV coordinates and display the resulting color.
	vec3 material_color = texture2D(tex_color, v2f_uv).rgb;

	// Calculate the light and view vectors.
	vec3 l = normalize(light_position - cam_vertex_position);
	vec3 v = normalize(-cam_vertex_position);

	// Calculate the halfway vector for Blinn-Phong.
	vec3 h = normalize(l + v);
	vec3 n = normalize(cam_surface_normal);

	// Compute the diffuse and specular components.
	float ambient = 0.1;
	float diffuse = max(dot(n, l), 0.0);
	float specular = diffuse > 0. ? pow(max(dot(n, h), 0.0), material_shininess) : 0.;

	// Compute the shadow map value and scale the light color accordingly.
	vec3 shadow_depth = textureCube(cube_shadowmap, cam_vertex_position).xyz;
	float shadow = length(shadow_depth)*1.01 < length(l) ? 0.0 : 1.0;

	// Calculate the attenuation factor for the light.
	float distance = length(light_position - cam_vertex_position);
	float attenuation = 1. / (distance*distance);

	// Compute the final color for the fragment.
	vec3 color = material_color * (ambient + light_color * attenuation * shadow * (diffuse + specular));

	gl_FragColor = vec4(color, 1.0);
}
