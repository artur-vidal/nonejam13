var sprite_xscale = width / sprite_get_width(spr_paper)
var sprite_yscale = height / sprite_get_height(spr_paper)

sprite.set_xscale(sprite_xscale)
sprite.set_yscale(sprite_yscale)
sprite.set_angle(angle)
sprite.set_color(color.compute())

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
    term.content,
    scale - scale_decrement,
    scale - scale_decrement,
    angle
)

draw_set_font(_prev_font)
draw_set_halign(fa_left)
draw_set_valign(fa_top)

set_term_type_colour(term.type)
draw_sprite_ext(spr_paper_marker, term.type, x, y, sprite_xscale, sprite_yscale, angle, draw_get_colour(), 1)
draw_set_colour(c_white)

if(on_green || on_red) {
    draw_sprite(spr_paper_check, on_red, x + width / 2 - 4, y - height / 2 - 2)
}