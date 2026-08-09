draw_set_colour(#422010)
draw_rectangle(x + 8, room_height - height - 8, x + room_width - 8, room_height - 4, false)
draw_set_colour(c_white)

var add_y = (current_id < 0 ? -4 : 0)
if(current_id > -1) {
    draw_sprite_ext(
        spr_icone_upgrade, 
        current_id,
        x + 20,
        room_height - height - 6,
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
    .wrap(500)
    .line_spacing("80%")

scribble_object.draw(x + 8 + padding, room_height - height + padding + add_y)