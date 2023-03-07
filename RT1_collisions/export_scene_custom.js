{
name: "scene_custom", 
camera: {position: [5.26, 10.81, 0.91], up: [0.125, 0.151, 0.981], target: [-1.017, 3.276, 2.87], fov: 60},
 
materials: [
	{
name: "default", color: [0.6, 0.6, 0.6], ambient: 0.2, diffuse: 0.8, specular: 0.4, shininess: 2.0, mirror: 0.02},
 {
name: "grass", color: [0.1, 0.7, 0.01], ambient: 0.2, diffuse: 0.9, specular: 0.3, shininess: 2.0, mirror: 0.02},
 {
name: "fuzzy", color: [0.3, 0.4, 0.6], ambient: 0.2, diffuse: 0.9, specular: 0.1, shininess: 2.0, mirror: 0.02},
 {
name: "white_shiny", color: [0.9, 0.9, 0.9], ambient: 0.2, diffuse: 0.9, specular: 0.8, shininess: 8.0, mirror: 0.3},
 {
name: "black", color: [0.1, 0.1, 0.1], ambient: 0.1, diffuse: 0.5, specular: 0.8, shininess: 1.0, mirror: 0.5}], 
lights: [
	{position: [9.328, 6.822, 2.304], color: [1.0, 0.8, 0.7]},
 {position: [-2.817, 12.998, 7.154], color: [1.0, 0.8, 0.7]}], 
spheres: [
	{center: [-16.493, -23.149, 8.008], radius: 10.0, material: "default"},
 {center: [-25.0, -25.0, 0.0], radius: 20.0, material: "default"},
 {center: [-25.808, -14.725, 4.42], radius: 10.0, material: "default"},
 {center: [-14.294, -22.595, 10.202], radius: 7.5, material: "default"},
 {center: [-26.021, -11.959, 5.606], radius: 7.5, material: "default"}], 
planes: [
	{center: [0.0, 0.0, -1.033], normal: [0.0, 0.0, 1.0], material: "grass"}], 
cylinders: [
	{center: [-21.077, -25.943, 9.531], axis: [0.663, -0.059, 0.746], height: 2.0, radius: 25.0, material: "default"}]}