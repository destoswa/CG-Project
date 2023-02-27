ExerciseIN0-Group22

---------------------
1.Set background color

	We modified to background color from black to a shade of red by changing the parameters in line 199
	of tracer.frag.glsl (pix_color = vec3(0., 0., 0.);) from (0., 0., 0.) to (0.7, 0., 0.2)

2.Modify the scene

	We created a new material instance in the materials section in line 18 of raytracer_pipeline.js that's
	identical to the already existing one, exept for the name field that was 'custom' instead of 'green' and
	the color field which was [1., 1., 1.] instead of [0.3, 1., 0.4], turning it from a shade of green to white.
	To apply the new material to the sphere, the material field in the spheres section was changed from 'green' to
	'custom'. The radius field was also changed from 1. to 0.5

3.Custom mesh

	Built a star-shaped mesh in Blender by adding new vertices in the mesh.
	struggled a little bit with object orientation, since .obj automatically applies default axes.
	since the mesh is bigger than expected, we removed the ground plane for better visibility.


Contribution:

Alice: 1/3		Jad: 1/3		Swann: 1/3