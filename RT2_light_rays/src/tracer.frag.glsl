precision highp float;

#define MAX_RANGE 1e6
//#define NUM_REFLECTIONS

//#define NUM_SPHERES
#if NUM_SPHERES != 0
uniform vec4 spheres_center_radius[NUM_SPHERES]; // ...[i] = [center_x, center_y, center_z, radius]
#endif

//#define NUM_PLANES
#if NUM_PLANES != 0
uniform vec4 planes_normal_offset[NUM_PLANES]; // ...[i] = [nx, ny, nz, d] such that dot(vec3(nx, ny, nz), point_on_plane) = d
#endif

//#define NUM_CYLINDERS
struct Cylinder {
	vec3 center;
	vec3 axis;
	float radius;
	float height;
};
#if NUM_CYLINDERS != 0
uniform Cylinder cylinders[NUM_CYLINDERS];
#endif

#define SHADING_MODE_NORMALS 1
#define SHADING_MODE_BLINN_PHONG 2
#define SHADING_MODE_PHONG 3
//#define SHADING_MODE

// materials
//#define NUM_MATERIALS
struct Material {
	vec3 color;
	float ambient;
	float diffuse;
	float specular;
	float shininess;
	float mirror;
};
uniform Material materials[NUM_MATERIALS];
#if (NUM_SPHERES != 0) || (NUM_PLANES != 0) || (NUM_CYLINDERS != 0)
uniform int object_material_id[NUM_SPHERES+NUM_PLANES+NUM_CYLINDERS];
#endif

/*
	Get the material corresponding to mat_id from the list of materials.
*/
Material get_material(int mat_id) {
	Material m = materials[0];
	for(int mi = 1; mi < NUM_MATERIALS; mi++) {
		if(mi == mat_id) {
			m = materials[mi];
		}
	}
	return m;
}

// lights
//#define NUM_LIGHTS
struct Light {
	vec3 color;
	vec3 position;
};
#if NUM_LIGHTS != 0
uniform Light lights[NUM_LIGHTS];
#endif
uniform vec3 light_color_ambient;


varying vec3 v2f_ray_origin;
varying vec3 v2f_ray_direction;

/*
	Solve the quadratic a*x^2 + b*x + c = 0. The method returns the number of solutions and store them
	in the argument solutions.
*/
int solve_quadratic(float a, float b, float c, out vec2 solutions) {

	// Linear case: bx+c = 0
	if (abs(a) < 1e-12) {
		if (abs(b) < 1e-12) {
			// no solutions
			return 0; 
		} else {
			// 1 solution: -c/b
			solutions[0] = - c / b;
			return 1;
		}
	} else {
		float delta = b * b - 4. * a * c;

		if (delta < 0.) {
			// no solutions in real numbers, sqrt(delta) produces an imaginary value
			return 0;
		} 

		// Avoid cancellation:
		// One solution doesn't suffer cancellation:
		//      a * x1 = 1 / 2 [-b - bSign * sqrt(b^2 - 4ac)]
		// "x2" can be found from the fact:
		//      a * x1 * x2 = c

		// We do not use the sign function, because it returns 0
		// float a_x1 = -0.5 * (b + sqrt(delta) * sign(b));
		float sqd = sqrt(delta);
		if (b < 0.) {
			sqd = -sqd;
		}
		float a_x1 = -0.5 * (b + sqd);


		solutions[0] = a_x1 / a;
		solutions[1] = c / a_x1;

		// 2 solutions
		return 2;
	} 
}

/*
	Check for intersection of the ray with a given sphere in the scene.
*/
bool ray_sphere_intersection(
		vec3 ray_origin, vec3 ray_direction, 
		vec3 sphere_center, float sphere_radius, 
		out float t, out vec3 normal) 
{
	vec3 oc = ray_origin - sphere_center;

	vec2 solutions; // solutions will be stored here

	int num_solutions = solve_quadratic(
		// A: t^2 * ||d||^2 = dot(ray_direction, ray_direction) but ray_direction is normalized
		1., 
		// B: t * (2d dot (o - c))
		2. * dot(ray_direction, oc),	
		// C: ||o-c||^2 - r^2				
		dot(oc, oc) - sphere_radius*sphere_radius,
		// where to store solutions
		solutions
	);

	// result = distance to collision
	// MAX_RANGE means there is no collision found
	t = MAX_RANGE+10.;
	bool collision_happened = false;

	if (num_solutions >= 1 && solutions[0] > 0.) {
		t = solutions[0];
	}
	
	if (num_solutions >= 2 && solutions[1] > 0. && solutions[1] < t) {
		t = solutions[1];
	}

	if (t < MAX_RANGE) {
		vec3 intersection_point = ray_origin + ray_direction * t;
		normal = (intersection_point - sphere_center) / sphere_radius;

		return true;
	} else {
		return false;
	}	
}

/*
	Check for intersection of the ray with a given plane in the scene.
*/
bool ray_plane_intersection(
		vec3 ray_origin, vec3 ray_direction, 
		vec3 plane_normal, float plane_offset, 
		out float t, out vec3 normal) 
{
	/** #TODO RT1.1:
	The plane is described by its normal vec3(nx, ny, nz) and an offset d.
	Point p belongs to the plane iff `dot(normal, p) = d`.

	- compute the ray's intersection of the plane
	- if ray and plane are parallel there is no intersection
	- otherwise compute intersection data and store it in `normal`, and `t` (distance along ray until intersection).
	- return whether there is an intersection in front of the viewer (t > 0)
	*/

	// can use the plane center if you need it
	vec3 plane_center = plane_normal * plane_offset;
	t = MAX_RANGE + 10.;

	vec2 solutions; // solutions will be stored here
	
	int num_solutions = solve_quadratic(
		// A: 0
		0., 
		// B: dot(n,d)
		dot(plane_normal, ray_direction),	
		// C: dot(n,o) - d			
		dot(plane_normal,ray_origin) - plane_offset,
		// where to store solutions
		solutions
	);

	if (num_solutions == 1) {
		t = solutions[0];
	}

	if (t < MAX_RANGE && t > 0.) {
		vec3 intersection_point = ray_origin + ray_direction * t;
		normal = -plane_normal * sign(dot(ray_direction,plane_normal));
		return true;
	} else {
		return false;
	}	
}

/*
	Check for intersection of the ray with a given cylinder in the scene.
*/
bool ray_cylinder_intersection(
		vec3 ray_origin, vec3 ray_direction, 
		Cylinder cyl,
		out float t, out vec3 normal) 
{
	/** #TODO RT1.2.2: 
	- compute the ray's first valid intersection with the cylinder
		(valid means in front of the viewer: t > 0)
	- store intersection point in `intersection_point`
	- store ray parameter in `t`
	- store normal at intersection_point in `normal`.
	- return whether there is an intersection with t > 0
	*/

	vec3 intersection_point;
	t = MAX_RANGE + 10.;
	
	vec2 solutions; // solutions will be stored here
	vec3 x0 = cyl.center;
	vec3 v = cyl.axis;
	vec3 o = ray_origin;
	vec3 d = ray_direction;
	v = v/length(v);
	d = d/length(d);

	int num_solutions = solve_quadratic(
		// A
		dot(d,d) - dot(d,v)*dot(d,v),
		// B
		2.*dot(d,o-x0)-2.*dot(d,v)*dot(o-x0,v),
		// C		
		dot(o-x0,o-x0)-cyl.radius*cyl.radius - dot(o-x0,v)*dot(o-x0,v),
		// where to store solutions
		solutions
	);
	// load the different possible solutions
	vec2 ts = vec2(MAX_RANGE + 5., MAX_RANGE + 5.);
	if (num_solutions >= 1) {
		if (solutions[0] > 0.) {
			ts[0] = solutions[0];
		}
		if(num_solutions == 2 && solutions[1] > 0.){
			ts[1] = solutions[1];
		}

		vec3 projSol;
		// loop on the different solutions
		for(int i = 0; i<2;i++){
			if(i==num_solutions){break;}
			// projection of the vector going from the origin of the cylindre to the solution to the axis of the cylindre (!!!PROBABLY A MISTAKE HERE!!!)
			vec3 x0Sol = o+ts[i]*d - x0;
			vec3 proj = dot(x0Sol,v)*v;
			// if the solution is on the real cylindre (not infinite one) and the closest to the ray origin, update t and projection
			if(length(proj) <= cyl.height/2. && ts[i] < t){
				t = ts[i];
				projSol = proj;
			}
		}
		if(t < MAX_RANGE && t > 0.){
			vec3 intersection_point = o + d * t;
			vec3 center_point = x0 + projSol;
			normal = -(intersection_point - center_point)/cyl.radius* sign(dot(d,intersection_point - center_point));
			return true;
		}else{
			return false;
		}
	}else{
		return false;
	}
}


/*
	Check for intersection of the ray with any object in the scene.
*/
bool ray_intersection(
		vec3 ray_origin, vec3 ray_direction, 
		out float col_distance, out vec3 col_normal, out int material_id) 
{
	col_distance = MAX_RANGE + 10.;
	col_normal = vec3(0., 0., 0.);

	float object_distance;
	vec3 object_normal;

	// Check for intersection with each sphere
	#if NUM_SPHERES != 0 // only run if there are spheres in the scene
	for(int i = 0; i < NUM_SPHERES; i++) {
		bool b_col = ray_sphere_intersection(
			ray_origin, 
			ray_direction, 
			spheres_center_radius[i].xyz, 
			spheres_center_radius[i][3], 
			object_distance, 
			object_normal
		);

		// choose this collision if its closer than the previous one
		if (b_col && object_distance < col_distance) {
			col_distance = object_distance;
			col_normal = object_normal;
			material_id =  object_material_id[i];
		}
	}
	#endif

	// Check for intersection with each plane
	#if NUM_PLANES != 0 // only run if there are planes in the scene
	for(int i = 0; i < NUM_PLANES; i++) {
		bool b_col = ray_plane_intersection(
			ray_origin, 
			ray_direction, 
			planes_normal_offset[i].xyz, 
			planes_normal_offset[i][3], 
			object_distance, 
			object_normal
		);

		// choose this collision if its closer than the previous one
		if (b_col && object_distance < col_distance) {
			col_distance = object_distance;
			col_normal = object_normal;
			material_id =  object_material_id[NUM_SPHERES+i];
		}
	}
	#endif

	// Check for intersection with each cylinder
	#if NUM_CYLINDERS != 0 // only run if there are cylinders in the scene
	for(int i = 0; i < NUM_CYLINDERS; i++) {
		bool b_col = ray_cylinder_intersection(
			ray_origin, 
			ray_direction,
			cylinders[i], 
			object_distance, 
			object_normal
		);

		// choose this collision if its closer than the previous one
		if (b_col && object_distance < col_distance) {
			col_distance = object_distance;
			col_normal = object_normal;
			material_id =  object_material_id[NUM_SPHERES+NUM_PLANES+i];
		}
	}
	#endif

	return col_distance < MAX_RANGE;
}

/*
	Return the color at an intersection point given a light and a material, exluding the contribution
	of potential reflected rays.
*/


vec3 lighting(
		vec3 object_point, vec3 object_normal, vec3 direction_to_camera, 
		Light light, Material mat) {

	/** #TODO RT2.1: 
	- compute the diffuse component
	- make sure that the light is located in the correct side of the object
	- compute the specular component 
	- make sure that the reflected light shines towards the camera
	- return the ouput color

	You can use existing methods for `vec3` objects such as `mirror`, `reflect`, `norm`, `dot`, and `normalize`.
	*/

	vec3 md = mat.color*mat.diffuse;
	vec3 l = normalize(light.position-object_point);
	vec3 n = object_normal;
	float nl = dot(n, l);
	vec3 diffuse = vec3(0.);
	if (nl >= 0.) {
		diffuse = light.color*md*nl;
	}

	vec3 ms = mat.color*mat.specular;
	vec3 r = reflect(-l,n);
	vec3 v = normalize(direction_to_camera);
	float rv = dot(r, v);
	vec3 phong_specular = vec3(0.);
	if (rv >= 0.) {
		phong_specular = light.color*ms*pow(rv,mat.shininess);
	}

	vec3 h = normalize(l+v);
	float nh = dot(n,h);
	vec3 blinn_phong_specular = vec3(0.);
	if (nh >= 0.) {
		blinn_phong_specular = light.color*ms*pow(nh, mat.shininess);
	}

	vec3 specular = vec3(0.);
	#if SHADING_MODE == SHADING_MODE_PHONG
	specular = phong_specular;
	#endif

	#if SHADING_MODE == SHADING_MODE_BLINN_PHONG
	specular = blinn_phong_specular;
	#endif

	/** #TODO RT2.2: 
	- shoot a shadow ray from the intersection point to the light
	- check whether it intersects an object from the scene
	- update the lighting accordingly
	*/

	float shadow = 1.;
	float col_distance;
	vec3 col_normal = vec3(0.);
	int material_id = 0;
	vec3 light_to_obj = normalize(light.position-object_point);
	if (ray_intersection(object_point, light_to_obj , col_distance, col_normal, material_id)) {
		if (length(light.position-object_point) > col_distance) {
			shadow = 0.;
		}
	}

	return (diffuse + specular)*shadow;
}

/*
Render the light in the scene using ray-tracing!
*/
vec3 render_light(vec3 ray_origin, vec3 ray_direction) {

	/** #TODO RT2.1: 
	- check whether the ray intersects an object in the scene
	- if it does, compute the ambient contribution to the total intensity
	- compute the intensity contribution from each light in the scene and store the sum in pix_color
	*/

	/** #TODO RT2.3.2: 
	- create an outer loop on the number of reflections (see below for a suggested structure)
	- compute lighting with the current ray (might be reflected)
	- use the above formula for blending the current pixel color with the reflected one
	- update ray origin and direction

	We suggest you structure your code in the following way:

	vec3 pix_color          = vec3(0.);
	float reflection_weight = ...;

	for(int i_reflection = 0; i_reflection < NUM_REFLECTIONS+1; i_reflection++) {
		float col_distance;
		vec3 col_normal = vec3(0.);
		int mat_id      = 0;

		...

		Material m = get_material(mat_id); // get material of the intersected object

		ray_origin        = ...;
		ray_direction     = ...;
		reflection_weight = ...;
	}
	*/

	vec3 pix_color = vec3(0.);

	float col_distance;
	vec3 col_normal = vec3(0.);
	int mat_id = 0;
	if(ray_intersection(ray_origin, ray_direction, col_distance, col_normal, mat_id)) {
		Material m = get_material(mat_id);
		pix_color = light_color_ambient*m.color*m.ambient;

		#if NUM_LIGHTS != 0
		for(int i_light = 0; i_light < NUM_LIGHTS; i_light++) {
			pix_color += lighting(ray_origin + ray_direction*0.9999*col_distance, col_normal, -ray_direction, lights[i_light], m);
		}
		#endif
	}

	return pix_color;
}


/*
	Draws the normal vectors of the scene in false color.
*/
vec3 render_normals(vec3 ray_origin, vec3 ray_direction) {
	float col_distance;
	vec3 col_normal = vec3(0.);
	int mat_id = 0;

	if(ray_intersection(ray_origin, ray_direction, col_distance, col_normal, mat_id) ) {	
		return 0.5*(col_normal + 1.0);
	} else {
		vec3 background_color = vec3(0., 0., 1.);
		return background_color;
	}
}


void main() {
	vec3 ray_origin = v2f_ray_origin;
	vec3 ray_direction = normalize(v2f_ray_direction);

	vec3 pix_color = vec3(0.);

	#if SHADING_MODE == SHADING_MODE_NORMALS
	pix_color = render_normals(ray_origin, ray_direction);
	#else
	pix_color = render_light(ray_origin, ray_direction);
	#endif

	gl_FragColor = vec4(pix_color, 1.);
}
