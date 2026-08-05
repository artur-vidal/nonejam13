var w = get_width();
var h = get_height();

// fundo
draw_set_color(#FFFFCD)
draw_rectangle(x, y, x + w, y + h, false)

// textual textilico
var prev_font = draw_get_font()
draw_set_color(#07070E)
draw_set_font(fnt_paper)
draw_set_halign(fa_left)
draw_set_valign(fa_top)

for (var i = 0; i < array_length(processed_blocks); i++) {
    var block = processed_blocks[i]
    
    if (block.type == "headline") {
        for (var j = 0; j < array_length(block.tokens); j++) {
            var tok = block.tokens[j]
            var _x = x + padding + tok.x
            var _y = y + block.y_offset + tok.y
            
            if (tok.cuttable && tok.cut) {
                // riscado/apagado
                draw_set_color(c_gray)
                draw_text_transformed(_x, _y, tok.text, text_scale, text_scale, 0)
                draw_line(_x, _y + tok.height / 2, _x + tok.width, _y + tok.height / 2)
                draw_set_color(#07070E)
            } else {
                draw_text_transformed(_x, _y, tok.text, text_scale, text_scale, 0)
            }
        }
    } else if (block.type == "deco") {
        if(i == 0) {
            block.deco.draw_logo(x + padding, y + block.y_offset + 2)
        } else {
            // block.deco.draw(x + get_width() / 2 + padding * 2, y + block.y_offset - 8)
        }
    }
}

draw_set_font(prev_font)
draw_set_colour(c_white)