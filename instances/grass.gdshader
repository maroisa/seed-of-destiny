shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

uniform sampler2D texture_albedo : source_color, filter_nearest;
uniform vec2 wind_direction = vec2(1.0, 0.5);
uniform float wind_speed : hint_range(0.0, 10.0) = 2.0;
uniform float wind_strength : hint_range(0.0, 1.0) = 0.15;
uniform float wind_scale : hint_range(0.0, 10.0) = 1.0;
uniform float alpha_scissor_threshold : hint_range(0.0, 1.0) = 0.5;

void vertex() {
    // UV.y is 1.0 at the bottom and 0.0 at the top of a Sprite3D.
    // Height factor isolates movement to the top of the grass blade.
    float height_factor = 1.0 - UV.y;
    
    // Calculate world position so adjacent grass instances sway out of phase
    vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    
    // Primary sine wave + secondary turbulence wave for natural movement
    float wave_1 = sin(TIME * wind_speed + (world_pos.x + world_pos.z) * wind_scale);
    float wave_2 = cos(TIME * wind_speed * 1.6 + (world_pos.x - world_pos.z) * wind_scale * 2.1) * 0.4;
    
    vec2 norm_wind = normalize(wind_direction);
    vec2 displacement = norm_wind * (wave_1 + wave_2) * wind_strength * height_factor;
    
    VERTEX.x += displacement.x;
    VERTEX.z += displacement.y;
}

void fragment() {
    vec4 albedo_tex = texture(texture_albedo, UV);
    ALBEDO = albedo_tex.rgb;
    ALPHA = albedo_tex.a;
    ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
}