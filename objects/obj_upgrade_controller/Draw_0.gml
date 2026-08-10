// draw_set_colour(#3E2A2A)
// draw_rectangle(x + 8, room_height - height - 8, x + room_width - 8, room_height - 4, false)
// draw_set_colour(c_white)

draw_sprite(spr_upgrade_box, 0, x + 8, room_height - height)

if(current_id > -1) {
    draw_sprite_ext(
        spr_icone_upgrade, 
        current_id,
        x + 24,
        room_height - height - 2,
        .5,
        .5,
        0,
        c_white,
        1
    )
}

var scribble_object = scribble($"Pontos restantes: {ROOT.state.upgrade_points}\n\n{get_content()}")
    .starting_format("fnt_paper", c_white)
    .transform(0.6, 0.6, 0)
    .wrap(450)
    .line_spacing("80%")

scribble_object.draw(x + 12 + padding, room_height - height + padding + 4)