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
	
Task GL3.3.2 Blend Options
	

------------------------

Contribution:

Alice Reymond(325763): 1/3
Jad Sobhie(287173): 1/3
Swann Destouches(258679): 1/3