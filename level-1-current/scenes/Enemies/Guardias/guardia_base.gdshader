shader_type canvas_item;


uniform bool highlight_all = false;

// Instance specific rather than the group
instance uniform float overlay_amount : hint_range(0.0, 1.0) = 0.0;
instance uniform vec3 overlay_color : source_color = vec3(1.0, 0.0, 0.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	
    tex.rgb = mix(tex.rgb, overlay_color.rgb, overlay_amount);

	if(highlight_all){
		tex.rgb = mix(tex.rgb, overlay_color.rgb, 0.7);
	}

    COLOR = tex;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
