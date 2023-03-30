GL2 - Meshes in the GPU pipeline

Task GL2.1: Computing Vertex Normals in a Triangle Mesh
------------------------
Task GL2.1.1: Compute triangle normals and opening angles
	Here, the function <compute_triangle_normals_and_angle_weights> is completed. 
	It loops on every faces of a mesh (passed in arguments) and for each face, get the 3 vertices that compose the triangle.
	From those vertices, the 3 edges are first computed and by doing a cross product of two of them, the normal of the face and the 3 angles are calculated.
	All the normals and angles are stored in lists that are returned by the function.

Task GL2.1.2: Compute vertex normals
	Once the normals and angles of a mesh can be computed, the function <compute_vertex_normals> is completed.
	It will again loop on the faces and for each one, add the contribution of the face normal to each of its vertice's normal weighted by the angles at the vertices.
	The vertice's normals are then normalized and returned

Task GL2.2 : Visualizing normals
------------------------
Task GL2.2.1: Pass normals to fragment shader
	In this part, the file <mesh_render.js> is first completed by creating the 2 matrices <mat_mvp> and .
	Then, the vertex and fragment shaders for the normal rendering are completed by declaring the varying variable <normals> on both shaders and the vertex_position and
	vertex_normal are taken from the entry of the pipeline to be transfered in the shaders through the vertex shader.

Task GL2.2.2: Transforming the normals
	Then, the file <mesh_render.js> is again modified in order to calculate the matrices <mat_normals_to_view> and <mat_model_view> and the vertex shader is modified to
	transfer the vertex_position expressed into the camera space.

Task GL2.3-4: Lighting
------------------------
Task GL2.3: Gouraud lighting
	In this part, two shaders are completed in order to create a Gouraud lighting rendering of the scene.
	To do so, the light_position, material color, material shininess and light color are passed to the vertex shader through the "uniforms" entry of the pipeline.
	The varying variable is set as a 3D vector named <Intensity> and is computed, following the formula of Gouraud, in the vertex shader.
	It is then transfered to the <gl_FragColor> 4D vector in the fragment shader.

Task GL2.4: Phong lighting
	In this part, instead of calculating the intensity in the vertex shader and passing it to the fragment shader, the vertex shader only compute the view_vector,
	light_vector and surface_normal into the good coordonate systems and pass them to the fragment shader (through varying method) where the intensity is then computed
	for each pixel.

------------------------

Contribution:

Alice Reymond(325763): 1/3
Jad Sobhie(287173): 1/3
Swann Destouches(258679): 1/3