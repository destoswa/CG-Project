Ray-Plane Intersection

Task RT1.1: Implement Ray-Plane intersections

	We used the formula given in the course for ray-plane intersection and solved the quadratic formula
	to find a potential t value. If such value exists it is stored along with the direction of the normal
	at that intersection which is the same as the given plane normal at a sign's difference. By multiplying
	it by the opposite sign of the dot product of the ray direction and the plane normal, we make sure the
	normal is facing the proper direction.


Ray-Cylinder Intersection

Task RT1.2.1: Derive the expression for a Ray-Cylinder intersection

	The expression for Ray-Cylinder intersection was derived in the way described in TheoryExercise.pdf.

Task RT1.2.2: Implement Ray-Cylinder intersections

	From the expression derived in the previous task, we solve the quadratic formula for the cylinder like we 	did for the plane and derive up to two possible intersections. We make sure the intersections are on the 	cylinder by projecting them on the axis and making sure the distance between the cylinder center and 	projection is smaller than half the height of the cylinder, and save the smallest valid value of t. The 	normal is defined as the direction between the projection of the intersection point on the axis and the 	intersection point itself. The same treatment as with the plane is applied to the normal to make sure it's 	facing the right direction (solved an issue where the normal on the inner cylinder was facing the wrong way).

Note: An issue was detected in the barrel picture where the cylinder doesn't show. It has yet to be debugged. (Solved, issue came from an eroneous nested condition that skipped the second possible solution if the first one was negative, even if the second one could have been positive.)


Custom scenes

A custom scene was added for fun, the files "scene_custom_normals.png", "export_scene_custom.js" and "scenes.js" were thus added to the zip file.

Contribution:

Alice: 1/3	Jad: 1/3	Swann:1/3