if(intro) {
    draw_sprite_ext(spr_nox, 0, 0, 0, 1, 1, 0, c_white, alpha)
} else {
    var _x = 56
    draw_sprite_part(spr_logo, 0, 0, 0, 100, 40, _x, logo_y.mentes + sin(current_time / 1000) * 3)
    draw_sprite_part(spr_logo, 0, 104, 0, 16, 40, _x + 100 + 4, logo_y.de + sin(current_time / 1000 + 200) * 3)
    draw_sprite_part(spr_logo, 0, 125, 0, 82, 40, _x + 100 + 16 + 7, logo_y.papel + sin(current_time / 1000 + 400) * 3)
    
    draw_set_alpha(alpha)
    draw_rectangle_colour(0, 0, room_width, room_height, c_black, c_black, c_black, c_black, false)
    draw_set_alpha(1)
}