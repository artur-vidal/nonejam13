draw_sprite_ext(
    spr_porta,
    state == "talking",
    x,
    y,
    image_xscale,
    image_yscale,
    0,
    c_white,
    1
)

// olívia atras da porta
draw_sprite_ext(
    spr_porta,
    2,
    x,
    y,
    image_xscale,
    image_yscale,
    0,
    c_white,
    secretary_alpha
)

// olívia na
if(state == "talking") {
    var index = (text_pos div 3) % 2 == 0
    if(ended()) index = 0;
    
    draw_sprite_ext(
        spr_olivia,
        index,
        x,
        y + 1,
        image_xscale,
        image_yscale,
        0,
        c_white,
        1
    )
}

if (state == "talking") {
    var scribble_obj = scribble(string_copy(current_dialogue(), 1, floor(text_pos)))
        .starting_format("fnt_paper", c_white)
        .transform(.5, .5, 0)
        .wrap(160)
    
    draw_rectangle_colour(text_area.x1 - 2, text_area.y1, text_area.x2 + 2, text_area.y2, c_black, c_black, c_black, c_black, false)
    scribble_obj.draw(text_area.x1 + 8, text_area.y1 + 8)
    
    if(ended()) {
        draw_sprite_ext(
            spr_cs_mouse, 
            round(0.5 + sin(current_time / 300) * 0.5), 
            text_area.x2 - 12, 
            text_area.y2 - 12,
            .5,
            .5,
            0,
            c_white,
            1
        )
    }
}