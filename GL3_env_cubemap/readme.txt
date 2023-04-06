GL3 - Textures, reflections, and shadows

Task GL3.1: Texture
------------------------
Task GL3.1.1: Sampling a texture
	In this first part, the texture is sampled by using the function <texture2D>, which returns a 4D vector and by rescalling it into a 3Dd vector by dropping the
	last coordinate.

Task GL3.1.2: UV coordinates and wrapping modes
	Here, the texture is first reshaped by changing the vertex positions so that it takes only a fourth of the its original size and it is then repeated by setting the
	texture's wrapping mode to 'mirror'.


Task GL3.2: Environment mapping
------------------------
Task GL3.2.1: Projection matrix for a cube camera
	Here the different faces of the cube are projected on 6 different screens by using the function 'mat4.perspective' and using the parameters Math.PI/2 for the fovy,
	1 for the aspect and 0.1/200 for the near and far parameters.

Task GL3.2.2: Up vectors for cube camera
	The axe of the up vector for each face of the cube is then set for them to point in the right direction.

Task GL3.2.3: Reflection shader
	Finally, the shaders are edited in order to implement the environement-map based reflections. The vertex shader is computing the vertex normal and vertex position in
	the view space and passing them to the fragment shader which is then calculating the reflected ray sirection by using the textureCube function. This function will take
	the samplerCube and the vertex position as parameters in order to sample the cube-map.


Task GL3.3: Shadow Mapping
------------------------
Task GL3.3.1: Phong Lighting Shader with Shadows
	Here we implemented the vertex and fragment shaders for the Phong lighting. The vertex shader wasn't too complicated, as it is very similar to the previous one from GL2.
	However, we encountered a few difficulties with the fragment shader:
	- first of all, we struggled for some time with the material color (sample texture) because we were adding the texture2D to the overall color
		and kept material_color as it was given in the handout. This gave us a rendered image with separated yellow, green and red lights.
	- the shadow map was not too difficult to use: the code checks whether the depth value of a vertex in space is shorter than the distance vertex-light.
		If it is, it means that the point is in shadow. However we had wrong shadows for quite some time because we had only passed the vertex position as the coord argument
		of textureCube, instead of the vector cam_vertex_position - light_position.
	- once this was fixed, we noticed that the shadows were more correctly mapped, but there was a gap between the shadow and its object.
		We realized that this was because we were using all x,y,z components of the textureCube, instead of just its depth value (x).
	We computed separately all different components for the color of a fragment (ambient, diffuse and specular components, shadow and attenuation) before putting all of them together in one equation.
	We also had to add the vase1 and table meshes back into GL3, as we realized that they did not render simply because they were not present at the right place in the project folders.

Task GL3.3.2 Blend Options
	We had to play around a lot with the different possible parameters of the blend function. We didn't change the equation parameter, as the default "add" is what we were looking for.
	The current parameters (src alpha and dst alpha) seemed to be the blending factors corresponding at best to the handout.
	

------------------------

Contribution:

Alice Reymond(325763): 1/3
Jad Sobhie(287173): 1/3
Swann Destouches(258679): 1/3