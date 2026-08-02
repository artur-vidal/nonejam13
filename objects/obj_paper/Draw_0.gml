sprite.set_xscale(scale * (width / sprite_get_width(spr_paper)))
sprite.set_yscale(scale * (height / sprite_get_height(spr_paper)))
sprite.set_angle(angle)

sprite.draw_shadow(x + width / 2, y + height / 2 + (dragging ? 12 : 4), 0.025, 0)
sprite.draw(x + width / 2, y + height / 2)

var _prev_font = draw_get_font()
draw_set_font(fnt_paper)
draw_set_colour(#07070E)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)

draw_text_transformed(
    x + width / 2,
    y + height / 2,
    content,
    scale,
    scale,
    angle
)

draw_set_font(_prev_font)
draw_set_colour(c_white)
draw_set_halign(fa_left)
draw_set_valign(fa_top)