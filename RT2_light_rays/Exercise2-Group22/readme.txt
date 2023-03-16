Lighting and light rays

Task RT2.1: Implement Lighting Models

	In this first part we implemented the two formulas for the Phong and Blinn-Phong Model in the lighting method. 
	The lighting is	composed of 3 components: The ambiant, the diffusion and the specular components. 
	However, some conditions influence those components:
		- if the dot product between the vectors n and l is less than 0, the diffusion component is null
		- if the dot product between the vectors r and v is less than 0, the specular component of the
		Phong model is null.
		- if the dot product between the vectors h and n is less than 0, the specular component of the 
		Blinn-Phong model is null.
	This lighting method is then called by an other function (render_light) each time the ray collide
	with an object.

Task RT2.2: Implement shadows

	In this second part, the method lighting is modified in order to integrate the gestion of shadows.
	To do so, a shadow ray is shooted from the intersection to the light and if an object is present between them,
	a coefficient multiplying the specular and diffusion component is set to 0.
	In order to avoid shadow acne, the intersection point sent to the lighting method is offset by a cst small 
	term in direction of the ray origin (in the render_light method).
	
Task RT3.1Task RT2.3.1: Derive iterative formula

	Here a demonstration by reccurence is used to prove the given formula from the definition of the color
	coefficient. This infinite formula is then derived into one to N where the N+1 reflection coefficient is
	null (no reflection).
	
Task RT2.3.2: Implement reflections

	The methode render_light is then modify to loop a maximum of NUM_REFLECTION times (if no intersection, break)
	and call the lighting method each time. for each reflection, the result of the lighting method is multyplied by
	a decreasing coefficient.
	Here again the intersection is offset in the direction of the ray origin in order to avoid reflection artifacts.

Contribution:

Alice Reymond: 1/3
Jad Sobhie(287173): 1/3
Swann Destouches:1/3