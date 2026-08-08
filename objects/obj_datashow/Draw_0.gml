draw_self()

if(active) {
    if(!surface_exists(surf)) {
        surf = surface_create(sprite_width, sprite_height)
    }
    
    surface_set_target(surf)
    draw_clear_alpha(c_black, 0)
    
    var hw = sprite_width / 2
    var hh = sprite_height / 2
    
    var med_sprites = sprite_get_number(spr_med_conf) - 1 
    var med_w = sprite_get_width(spr_med_conf)
    var med_h = sprite_get_height(spr_med_conf)
    
    var prev_font = draw_get_font()
    
    draw_set_font(fnt_paper)
    draw_set_alpha(alpha)
    draw_set_colour(#332211)
    draw_set_halign(fa_center)
    draw_set_valign(fa_middle)
    
    draw_text(hw, hh - 50, "SEU DESEMPENHO")
    
    var conf = ROOT.state.confidence
    draw_text_transformed(hw - 20, hh - 28, "Confiança", 0.9, 0.9, 0)
    draw_sprite(spr_med_conf, clamp(floor(conf / 100 * med_sprites), 0, med_sprites), hw + 24 - med_w / 2, hh - 22)
    
    var viol = ROOT.state.violence
    draw_text_transformed(hw - 20, hh, "Violência", 0.9, 0.9, 0)
    draw_sprite(spr_med_viol, clamp(floor(viol / 100 * med_sprites), 0, med_sprites), hw + 24 - med_w / 2, hh + 6)
    
    var serie = ROOT.state.seriousness
    draw_text_transformed(hw - 20, hh + 28, "Seriedade", 0.9, 0.9, 0)
    draw_sprite(spr_med_serie, clamp(floor(serie / 100 * med_sprites), 0, med_sprites), hw + 24 - med_w / 2, hh + 34)
    
    draw_set_font(prev_font)
    draw_set_alpha(1)
    draw_set_colour(c_white)
    draw_set_halign(fa_left)
    draw_set_valign(fa_top)
    
    surface_reset_target()
    
    // desenhando com shaders
    var shader = ROOT.shader_mgr
    shader.set_xwave(64, 0.25, 8)
    shader.set_saturation(0.4)
    //shader.set_ywave(16, 0.25, -2)
    shader.for_surface(surf)
    
    shader.apply()
    draw_surface(surf, x, y)
    shader.reset()
}