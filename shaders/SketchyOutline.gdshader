shader_type spatial;
render_mode unshaded, cull_front;

uniform sampler2D outline_noise_tex : source_color;
uniform vec4 outline_color : source_color;
uniform float scissor_value : hint_range(0.0, 1.0) = 0.5;
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform sampler2D falloff_curve : hint_default_white;
uniform float outline_size : hint_range(0.0, 1.0) = 0.1;
uniform float offset_fres : hint_range(0.0, 1.0) = 0.3;
uniform float fps : hint_range(1.0, 60.0) = 5.0;

varying float h;

void vertex() {
    VERTEX += NORMAL * outline_size * texture(outline_noise_tex, UV).r;
    h = (MODEL_MATRIX * vec4(VERTEX, 1.0)).y;
}

void fragment() {
    float fres = abs(dot(normalize(-NORMAL), normalize(VIEW)));
    vec3 nor = normalize(NORMAL);
    float angle = atan(nor.y, nor.x);
    angle /= 3.14159265359;

    float fres_remap = texture(falloff_curve, vec2(1.0 - fres)).r + offset_fres;
    ALPHA = texture(outline_noise_tex, vec2(angle * uv_scale.x + SCREEN_UV.x, nor.z * uv_scale.y + floor(TIME * fps)/fps)).r * fres_remap;
    ALBEDO = outline_color.rgb;
    ALPHA_SCISSOR_THRESHOLD = scissor_value;
}