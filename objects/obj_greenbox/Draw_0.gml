draw_self()

var _prev_font = draw_get_font()
draw_set_font(fnt_paper)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_set_colour(#FFFFD9)

var controller = singleton(obj_game)
var max_terms = controller.max_terms()
var term_count = controller.term_count()

if(max_terms != infinity) {
    draw_text(x, y + 32, $"{term_count} / {max_terms}")
}

draw_set_font(_prev_font)
draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_colour(c_white)