shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
    vec4 tinted_color = original_color * color;
    COLOR = tinted_color;
}
