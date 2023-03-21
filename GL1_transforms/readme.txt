Geometric transforms in the GPU pipeline

Task GL1.1: 2D Scene
--------------------
Task GL1.1.1: 2D translation in shader

	For the vertex shader of the first triangle, we need to add to the triangle's translation the offset of the mouse.
	Since gl_Position is the vector that will represent the last column of the translation matrix, it suffices to add mouse_offset to the
	initial triangle position.
	Then this first triangle is built with its color and current mouse_offset.

Task GL1.1.2: Matrix transform

	To apply a transformation matrix to a vertex, we multiply it to the vertex' position vector.
	When multiplying transformation matrices, the last one corresponds to the first transformation.
	Hence, for the green triangle, we first translate the shape away from the origin, then rotate it around the origin.
	For the red triangle, we apply the rotation first while the shape is still centered at the origin, then translate it.

Task GL1.2: Solar System
------------------------
Task GL1.2.1: MVP matrix

	Same as previously, we mutliply the transform matrix is multiplied to the position vector
	of the vertex the transformation applies to.
	The MVP matrix is the multiplication of the three different change-of-coordinates matrices,
	the first one applied being multiplied last.
	
Task GL1.2.2: View matrix
	This matrix transforms the world coordinates into camera coordinates.
	We had some trouble getting the turn-table effect right for this exercise.
	We first used the lookAt function to set the camera facing the world's origin.
	Then we multiplied the look_at matrix with rotations on the Y and Z axes, dependent of the camera angle,
	to give the turn-table effect.

Task GL1.2.3: Model matrix
	This matrix transforms model coordinates to world coordinates.
	In this function, we first fetch all the necessary variables from the actor's parent, if it is not null.
	For such children actors, we apply a rotation of the model around its parent planet/star 
	and a translation that corresponds the actor's orbit and changes along the simulation time.
	We had a bit of trouble here with vector addition.
	We then also created transformation matrices for the actor's rotation on itself, around the Z axis
	and scaling using the actor's size.
	For actors that do not have a parent (i.e the sun), we only apply the scaling and rotation on itself matrices.

Task GL1.3: Screenshots
-----------------------
	Please see the jpg files we have included in the zip file.
	

Contribution:

Alice Reymond(325763): 1/3
Jad Sobhie(287173): 1/3
Swann Destouches(258679): 1/3