sprite.set_xscale(width / sprite_get_width(spr_paper))
sprite.set_yscale(height / sprite_get_height(spr_paper))
sprite.set_angle(angle)

sprite.draw_shadow(x, y + (dragging ? 4 : 2), 0.025, 0)
sprite.draw(x, y)

var _prev_font = draw_get_font()
draw_set_font(fnt_paper)
draw_set_colour(#07070E)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)

draw_text_transformed(
    x,
    y,
    content,
    scale * 0.9,
    scale * 0.9,
    angle
)

draw_set_font(_prev_font)
draw_set_colour(c_white)
draw_set_halign(fa_left)
draw_set_valign(fa_top)