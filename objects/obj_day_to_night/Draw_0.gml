draw_set_alpha(alpha)
draw_rectangle_colour(0, 0, room_width, room_height, c_black, c_black, c_black, c_black, false)
draw_set_alpha(1)

if(show_text) {
    var prev_font = draw_get_font()
    draw_set_font(fnt_paper)
    draw_set_halign(fa_center)
    draw_set_valign(fa_middle)
    
    draw_text(room_width / 2, room_height / 2, $"DIA {ROOT.state.day} - Noite")
    
    draw_set_font(prev_font)
    draw_set_halign(fa_left)
    draw_set_valign(fa_top)
}