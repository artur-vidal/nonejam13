image_index = (toggle ? 2 : 0) + hovering
draw_self()

var prev_font = draw_get_font()
draw_set_font(fnt_paper)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_text_transformed(x, y + 12, "F11", .5, .5, 0)
draw_set_font(prev_font)
draw_set_halign(fa_left)
draw_set_valign(fa_top)