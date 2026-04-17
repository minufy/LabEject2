vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords){
    vec4 pixel = Texel(tex, texture_coords);
    return vec4(0.0, 0.0, 0.0, pixel.a*0.2);
}