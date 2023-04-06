precision highp float;

varying vec3 cam_surface_normal;
varying vec3 cam_vertex_position;
varying vec2 v2f_uv;

uniform vec3 light_position; // light position in camera coordinates
uniform vec3 light_color;
uniform sampler2D tex_color;
uniform samplerCube cube_shadowmap;

void main() {
	float material_shininess = 12.;

	/* #TODO GL3.1.1
	Sample texture tex_color at UV coordinates and display the resulting color.
	*/
	vec3 material_color = texture2D(tex_color, v2f_uv).rgb;

/*
	#TODO GL3.3.1: Blinn-Phong with shadows and attenuation
  
	Compute this light's diffuse and specular contributions.
	You should be able to copy your phong lighting code from GL2 mostly as-is,
	though notice that the light and view vectors need to be computed from scratch here; 
	this time, they are not passed from the vertex shader. 
	Also, the light/material colors have changed; see the Phong lighting equation in the handout if you need
	a refresher to understand how to incorporate `light_color` (the diffuse and specular
	colors of the light), `v2f_diffuse_color` and `v2f_specular_color`.
	
	To model the attenuation of a point light, you should scale the light
	color by the inverse distance squared to the point being lit.
	
	The light should only contribute to this fragment if the fragment is not occluded
	by another object in the scene. You need to check this by comparing the distance
	from the fragment to the light against the distance recorded for this
	light ray in the shadow map.
	
	To prevent "shadow acne" and minimize aliasing issues, we need a rather large
	tolerance on the distance comparison. It's recommended to use a *multiplicative*
	instead of additive tolerance: compare the fragment's distance to 1.01x the
	distance from the shadow map.
	Implement the Blinn-Phong shading model by using the passed
	variables and write the resulting color to `color`.
	Make sure to normalize values which may have been affected by interpolation!
	*/

	// Calculate and normalize the necessary vectors
	vec3 l = normalize(light_position - cam_vertex_position);
	vec3 v = normalize(-cam_vertex_position);
	vec3 h = normalize(l + v);
	vec3 n = normalize(cam_surface_normal);

	// Compute the different light components
	float ambient = 0.1;
	float diffuse = max(dot(n, l), 0.0);
	float specular = diffuse > 0. ? pow(max(dot(n, h), 0.0), material_shininess) : 0.;

	// Helper
	float distance = length(light_position - cam_vertex_position);

	// Compute the shadow map value and scale the light color accordingly
	float shadow_depth = textureCube(cube_shadowmap, cam_vertex_position - light_position).x;
	float shadow = length(shadow_depth)*1.01 < distance ? 0. : 1.;

	// Calculate the attenuation factor for the light
	float attenuation = 1. / (distance*distance);

	// Compute the final color for the fragment
	vec3 color = attenuation * material_color * light_color *(ambient + shadow * (diffuse + specular));

	gl_FragColor = vec4(color, 1.0);
}
