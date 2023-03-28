precision mediump float;

// #TODO GL2 setup varying
varying vec3 Intensity;

void main()
{
	/*
	#TODO GL2.3: Gouraud lighting
	*/
	//vec3 color = vec3(1., 0., 0.);
	vec3 color = Intensity;
	gl_FragColor = vec4(color, 1.); // output: RGBA in 0..1 range
}
