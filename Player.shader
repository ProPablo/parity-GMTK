shader_type canvas_item;

//The screen UV or whats ahead current object is auto excluded
uniform sampler2D noiseTex;
uniform float MAX_UV_DISP = 0.1;
uniform float LOWER_DIST = 0.01;
uniform float UPPER_DIST = 0.5;


void fragment() {
	vec2 noiseVal = texture(noiseTex, UV).rg - vec2(0.5);
//	Radius of 0.5 in UV space

// Linear interpolated effect (from black hole)
	float dist = clamp(distance(UV, vec2(0.5)), LOWER_DIST, UPPER_DIST);
//	Normalized
	float remapped = (dist - LOWER_DIST) / (UPPER_DIST - LOWER_DIST);
	float inverse_mapped = 1.0 - remapped;

//	inverse sqrt interp
//	float dist = distance(UV, vec2(0.5));
//	float inverse_dist = (1.0/dist) * LOWER_DIST;
//	inverse_dist = clamp(inverse_dist, LOWER_DIST, UPPER_DIST);
//	float inverse_bound_mapped = (inverse_dist - LOWER_DIST) / (UPPER_DIST - LOWER_DIST);
 
//	COLOR.rgb = vec3(inverse_mapped);

//	uv = clamp(rel + vec2(0.5,0.5), vec2(0.0, 0.0), vec2(1.0, 1.0));

	vec2 newScreenUV = SCREEN_UV + noiseVal * MAX_UV_DISP * inverse_mapped;
	vec3 c = textureLod(SCREEN_TEXTURE, newScreenUV, 0.0).rgb;
	COLOR.rgb = c;
}