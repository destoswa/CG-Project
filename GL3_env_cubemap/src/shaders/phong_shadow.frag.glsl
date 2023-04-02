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
uniform samplerCube cube_shadowmap;
uniform sampler2D tex_color;

void main() {

	float material_shininess = 12.;

	/* #TODO GL3.1.1
	Sample texture tex_color at UV coordinates and display the resulting color.
	*/
	vec3 material_color = vec3(v2f_uv, 0.);
	float material_ambient = 0.1;
	vec3 l = normalize(light_position - cam_vertex_position);
	vec3 n = normalize(cam_surface_normal);
	vec3 v = normalize(-cam_vertex_position);
	vec3 h = normalize(v+l);
	
	vec3 color = vec3(0.,0.,0.);
	vec3 shadow_depth = textureCube(cube_shadowmap, cam_vertex_position).xyz;
	if(length(cam_vertex_position) > length(shadow_depth)*1.01){
		color = color + light_color * material_color * material_ambient;
		if(dot(n,l) > 0.){
			color = color + light_color * material_color * dot(n,l);
			if(dot(n,h) > 0.){
				color = color + light_color * material_color * pow(dot(n,h),material_shininess);
			}
		}
	}
	color /= (length(cam_vertex_position)*length(cam_vertex_position));
	color = color + vec3(texture2D(tex_color, v2f_uv));
	/*if(length(cam_vertex_position) > length(shadow_depth)*1.01){
		color = vec3(0.,0.,0.);
	}*/
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
	//vec3 color = light_color * material_color;
	gl_FragColor = vec4(color, 1.); // output: RGBA in 0..1 range
}
