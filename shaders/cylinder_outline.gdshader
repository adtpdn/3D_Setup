shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 highlight_color : source_color = vec4(1.0, 1.0, 1.0, 0.25);
uniform float highlight_intensity : hint_range(0.0, 1.0) = 0.25;
uniform sampler2D albedo_texture : source_color;
uniform bool use_texture = false;

void fragment() {
    vec4 base_color;
    if (use_texture) {
        base_color = texture(albedo_texture, UV);
    } else {
        base_color = vec4(1.0);  // White if no texture
    }

    // Mix the base color with the highlight color
    ALBEDO = mix(base_color.rgb, highlight_color.rgb, highlight_intensity);

    // Keep the original alpha
    ALPHA = base_color.a;
}