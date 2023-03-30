precision mediump float;

/* #TODO GL2.4
	Setup the varying values needed to compue the Phong shader:
	* surface normal
	* lighting vector: direction to light
	* view vector: direction to camera
*/
varying vec3 surface_normal;
varying vec3 view_vector;
varying vec3 light_vector;

uniform vec3 material_color;
uniform float material_shininess;
uniform vec3 light_color;

void main()
{
	float material_ambient = 0.1;

	/*
	/** #TODO GL2.4: Apply the Blinn-Phong lighting model

	Implement the Blinn-Phong shading model by using the passed
	variables and write the resulting color to `color`.

	Make sure to normalize values which may have been affected by interpolation!
	*/
	vec3 l = normalize(light_vector);
	vec3 n = normalize(surface_normal);
	vec3 v = normalize(view_vector);
	vec3 h = normalize(v+l);
	vec3 Intensity = light_color * material_color * material_ambient;
	if(dot(n,l) > 0.){
		Intensity = Intensity + light_color * material_color * dot(n,l);
		if(dot(n,h) > 0.){
			Intensity = Intensity + light_color * material_color * pow(dot(n,h),material_shininess);
		}
	}
	vec3 color = Intensity;
	gl_FragColor = vec4(color, 1.); // output: RGBA in 0..1 range
}
