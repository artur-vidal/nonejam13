//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// LIBS SUBSTITUÍDAS

// UVS
uniform vec4 u_uvs;
uniform vec2 u_texel_size;

vec4 get_uvs() {
    // vec4(0.0) é o valor padrão; como quero que seja 0, 0, 1, 1
    // eu retorno esse valor caso seja padrão
    if (u_uvs == vec4(0.0)) {
        return vec4(0.0, 0.0, 1.0, 1.0);
    }
    return u_uvs;
}

vec2 texture_size() {
    vec4 uvs = get_uvs();
    return uvs.zw - uvs.xy;
}

vec2 global_to_local_uvs(vec2 global_pixel_position) {
    return (global_pixel_position - get_uvs().xy) / texture_size();
}

vec2 local_to_global_uvs(vec2 local_uv) {
    return (local_uv * texture_size()) + get_uvs().xy;
}

vec2 texel_size() {
    return vec2(1.0) / texture_size();
}


// CORES
// https://github.com/DragoniteSpam-GameMaker-Tutorials/TutorialHueShiftShader/blob/master/shaders/shd_hue_hsv_conversion/shd_hue_hsv_conversion.fsh
uniform float u_hue_shift;

vec3 to_hsv(vec3 color) {                                                    // color: rgb
    vec4 K = vec4(0.0,      -1.0 / 3.0,         2.0 / 3.0,      -1.0);      // K: xyzw
    vec4 p = mix(vec4(color.b, color.g, K.w, K.z),      vec4(color.g, color.b, K.x, K.y),       step(color.b, color.g));        // p: xyzw
    vec4 q = mix(vec4(p.x, p.y, p.w, color.r),          vec4(color.r, p.y, p.z, p.x),           step(p.x, color.r));            // q: xyzw
    
    float d = q.x - min(q.w, q.y);
    float e = 0.00001;
    
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),         d / (q.x + e),          q.x);               // hsv: xyz
}

vec3 to_rgb(vec3 color) {                                                    // hsv: xyz
    vec4 K = vec4(1.0,      2.0 / 3.0,          1.0 / 3.0,      3.0);       // K: xyzw
    vec3 p = abs(fract(vec3(color.x + K.x, color.x + K.y, color.x + K.z)) * 6.0 - vec3(K.w, K.w, K.w));     // p: xyz
    return mix(vec3(K.x, K.x, K.x),                     clamp(p - vec3(K.x, K.x, K.x), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)),       color.y) * color.z;
}

vec3 hue_shift(vec3 color) {
    vec3 hsv = to_hsv(color);
    
    hsv.x += u_hue_shift;
    hsv.x = fract(hsv.x);
    
    return to_rgb(hsv);
}

// RANDOMS
float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

float perlin_noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
    
    float a = dot(vec2(rand(i + vec2(0.0, 0.0))), f - vec2(0.0, 0.0));
    float b = dot(vec2(rand(i + vec2(1.0, 0.0))), f - vec2(1.0, 0.0));
    float c = dot(vec2(rand(i + vec2(0.0, 1.0))), f - vec2(0.0, 1.0));
    float d = dot(vec2(rand(i + vec2(1.0, 1.0))), f - vec2(1.0, 1.0));
    
    return mix(mix(a, b, u.x),
        mix(c, d, u.x), u.y);
}










uniform float u_time;

// ondas (FREQUÊNCIA, AMPLITUDE, VELOCIDADE)
uniform vec3 u_xwave;
uniform vec3 u_ywave;

// brilho, contraste, saturação, gamma, opacidade
uniform float u_brightness;
uniform float u_contrast;
uniform float u_saturation;
uniform float u_gamma;
uniform float u_opacity;

// noise barulho
uniform float u_noise;

void main()
{
    // processamento de pixels
    vec2 pos = global_to_local_uvs(v_vTexcoord);
    
    // ONDA
    pos.x += sin((pos.y * u_xwave.x) + (u_time * u_xwave.z))
        * (u_xwave.y * u_texel_size.x);
    
    pos.y += sin((pos.x * u_ywave.x) + (u_time * u_ywave.z))
        * (u_ywave.y * u_texel_size.y);
    
    // processamento de cores
    vec4 color = v_vColour * texture2D(
        gm_BaseTexture, 
        local_to_global_uvs(pos)
    );
    
    vec3 color_channels = color.rgb;
    float alpha = color.a;
    
    vec3 luminance_values = vec3(0.2126, 0.7152, 0.0722);
    
    // brilho
    color_channels += vec3( dot( vec3( u_brightness ), luminance_values ) );
    
    // gamma
    color_channels = pow(color_channels, vec3(1.0) / u_gamma);
    
    // hue shift
    color_channels = hue_shift(color_channels);
    
    // contraste
    color_channels = mix(vec3(0.5), color_channels, u_contrast);
    
    // saturação
    float gray_value = dot(color_channels, luminance_values);
    color_channels = mix(vec3(gray_value), color_channels, u_saturation);
    
    // noise
    vec4 final_color = vec4(color_channels, alpha * u_opacity);
    float noise = rand(pos + vec2(sin(u_time), cos(u_time)));
    final_color.rgb = mix(final_color.rgb, vec3(noise), u_noise);
    
    gl_FragColor = final_color;
}
