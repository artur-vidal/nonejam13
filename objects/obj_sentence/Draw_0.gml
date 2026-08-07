draw_set_colour(#FFFFFD)
draw_rectangle(x, y, x + get_width(), y + get_height(), false)

draw_set_colour(#408B90)
draw_rectangle(x, y, x + get_width(), y + stat_view_height, false)

var prev_font = draw_get_font()
draw_set_font(fnt_paper)

for (var i = 0; i < array_length(processed_blocks); i++) {
    draw_set_colour(#07070E)
	var block = processed_blocks[i]
    
    if(is_instanceof(block.block, SentenceSlot)) {
        if(block.block.has_content()) {
            draw_text_transformed(block.gx, block.gy, block.block.content, text_scale, text_scale, 0)
            
            set_term_type_colour(block.block.type)
            draw_line(block.gx, block.gy + block.height, block.gx + block.width, block.gy + block.height)
            draw_line(block.gx, block.gy + block.height + 1, block.gx + block.width, block.gy + block.height + 1)
        } else {
            set_term_type_colour(block.block.type)
            var thickness = 2
            draw_rectangle_thick(block.gx, block.gy, block.gx + block.width, block.gy + block.height, thickness)
        }
    } else {
        draw_text_transformed(block.gx, block.gy, block.text, text_scale, text_scale, 0)
    }
}

draw_set_font(prev_font)
draw_set_colour(c_white)