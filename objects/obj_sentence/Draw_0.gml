draw_rectangle_colour(x, y, x + get_width(), y + get_height(), #FFFFFD, #FFFFFD, #FFFFFD, #FFFFFD, false)

// parte azul dos status e setinhas
draw_rectangle_colour(x, y, x + get_width(), y + stat_view_height, #408B90, #408B90, #408B90, #408B90, false)
var is_playing = GAME.playing // impedir q mudem de frame pausado
if(!submitted) {
    draw_sprite_ext(
        spr_setas, 
        hovering_left_arrow() && is_playing, 
        x + arrow_x, 
        y + arrow_y, 
        1, 
        1, 
        0, 
        c_white, 
        1
    )
    
    draw_sprite_ext(
        spr_setas, 
        hovering_right_arrow() && is_playing, 
        x + arrow_x + sprite_get_width(spr_setas) * 2 + arrow_gap,
        y + arrow_y, 
        -1, 
        1, 
        0,
        c_white, 
        1
    )
}

// texto
var prev_font = draw_get_font()
draw_set_font(fnt_paper)

draw_set_colour(#07070E)
draw_text_transformed(x + padding, y + content_height + 8, $"{sentence_index + 1} / 31", 0.4, 0.4, 0)

for (var i = 0; i < array_length(processed_blocks); i++) {
    draw_set_colour(#07070E)
	var block = processed_blocks[i]
    
    if(is_instanceof(block.block, SentenceSlot)) {
        if(block.block.has_content()) {
            draw_text_transformed(x + block.x, y + block.y, block.block.content, text_scale, text_scale, 0)
            
            set_term_type_colour(block.block.type)
            draw_line(x + block.x, y + block.y + block.height, x + block.x + block.width, y + block.y + block.height)
            draw_line(x + block.x, y + block.y + block.height + 1, x + block.x + block.width, y + block.y + block.height + 1)
        } else {
            set_term_type_colour(block.block.type)
            var thickness = 2
            draw_rectangle_thick(x + block.x, y + block.y, x + block.x + block.width, y + block.y + block.height, thickness)
        }
    } else {
        draw_text_transformed(x + block.x, y + block.y, block.text, text_scale, text_scale, 0)
    }
}

draw_set_font(prev_font)
draw_set_colour(c_white)

// carimbo
var stamp_x = get_width() - padding
var stamp_y = get_height() - padding * 2
draw_sprite_ext(spr_carimbo, stampable() + submitted, x + stamp_x, y + stamp_y, stamp_scale, stamp_scale, -4, c_white, 1)
