shader_type canvas_item;

//The screen UV of whats ahead current object is auto excluded
uniform sampler2D noiseTex;
uniform float MAX_UV_DISP = 0.01;
uniform float LOWER_DIST = 0.01;
uniform float UPPER_DIST = 0.5;
uniform float sprite_scale = 211.469;
uniform float rotation_scale = 0.5;

const float PI = 3.1415926535897932384;
void fragment() {
	vec2 noiseVal = texture(noiseTex, UV).rg - vec2(0.5);

// Linear interpolated effect (from black hole)
//	Radius of 0.5 in UV space
	float dist = clamp(distance(UV, vec2(0.5)), LOWER_DIST, UPPER_DIST);
//	equivilant to atan2 when using both parameters
//	float angle = atan(normal_UV.y, normal_UV.x);
	vec2 normal_UV = UV - vec2(0.5);
	
//	Normalized
	float remapped = (dist - LOWER_DIST) / (UPPER_DIST - LOWER_DIST);
	float inverse_mapped = 1.0 - remapped;
	float angle = rotation_scale * PI * inverse_mapped;

//	inverse sqrt interp
//	float dist = distance(UV, vec2(0.5));
//	float inverse_dist = (1.0/dist) * LOWER_DIST;
//	inverse_dist = clamp(inverse_dist, LOWER_DIST, UPPER_DIST);
//	float inverse_bound_mapped = (inverse_dist - LOWER_DIST) / (UPPER_DIST - LOWER_DIST);
 
//	COLOR.rgb = vec3(inverse_mapped);

	vec2 text_pixels = sprite_scale/ TEXTURE_PIXEL_SIZE;
	vec2 text_coord = UV * text_pixels;
	vec2 origin_pixels = (FRAGCOORD.xy - text_coord) + text_pixels/2.0;
//	Convert back into screen_uv
	vec2 origin_uv = origin_pixels * SCREEN_PIXEL_SIZE;
	COLOR.rgb = vec3(text_coord, 0);

//	Doing this without a noise texture has a very weird effect
	vec2 uv = SCREEN_UV + noiseVal * MAX_UV_DISP * inverse_mapped;
//	Need to apply rotation (using rot mat) based on angle computed 
//	vec2 uv = SCREEN_UV;
	uv -= origin_uv;
	mat2 rotation = mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
	uv = uv * rotation;
	uv += origin_uv;
	vec3 c = textureLod(SCREEN_TEXTURE, uv, 0.0).rgb;
	COLOR.rgb = c;
}