// fundo do papel (retângulo branco)
var _largura_papel = get_width()
var _altura_papel = get_height()

draw_set_color(#FFFFCD)
draw_rectangle(x, y, x + _largura_papel, y + _altura_papel, false)

draw_set_font(fnt_paper)
draw_set_halign(fa_left)
draw_set_valign(fa_top)

for (var i = 0; i < array_length(tokens); i++) {
    var _tok = tokens[i]
    var _draw_x = x + _tok.x
    var _draw_y = y + _tok.y

    if (_tok.recortavel && _tok.recortado) {
        // riscado/apagado: cinza + linha por cima
        draw_set_color(c_gray)
        draw_text(_draw_x, _draw_y, _tok.texto)
        draw_line(_draw_x, _draw_y + _tok.altura / 2, _draw_x + _tok.largura, _draw_y + _tok.altura / 2)
        draw_set_color(c_black)
    } else if (_tok.recortavel) {
        // recortável e ainda não recortada: pode destacar (ex: sublinhado sutil) pra dar affordance
        draw_set_color(c_black)
        draw_text(_draw_x, _draw_y, _tok.texto)
        // opcional: linha pontilhada ou cor diferente pra indicar "isso é clicável"
    } else {
        // texto normal, não recortável
        draw_set_color(c_black)
        draw_text(_draw_x, _draw_y, _tok.texto)
    }
}

// desenhando o sprite de lixeira
draw_set_alpha(trash_alpha)
draw_sprite(spr_trash, 0, x + get_width() + 16, y)
draw_set_alpha(1)