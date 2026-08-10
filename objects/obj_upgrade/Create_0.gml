upgrade_point_x = [16, 40, 64]
button_gap = 4

hovering = false

get_points = function() {
    return ROOT.state.upgrade_levels[upgrade_id]
}

remaining_points = function() {
    return ROOT.state.upgrade_points
}

is_hovered = function() {
    return hovering_upgrade_green_button()
    || hovering_upgrade_red_button()
    || point_in_rectangle(
        mouse_x,
        mouse_y,
        x - sprite_get_width(spr_icone_upgrade) / 2,
        y - sprite_get_height(spr_icone_upgrade) / 2,
        x + sprite_get_width(spr_icone_upgrade) / 2 + sprite_get_width(spr_grade_upgrade), // sei la chutei
        y + sprite_get_height(spr_icone_upgrade) / 2
    )
}

hovering_upgrade_green_button = function() {
    var button_w = sprite_get_width(spr_botao_upgrade)
    var button_h = sprite_get_height(spr_botao_upgrade)
    
    return point_in_rectangle(
        mouse_x,
        mouse_y,
        x + 100 + button_gap - button_w / 2,
        y - button_h,
        x + 100 + button_gap + button_w / 2,
        y - 1
    )
}

hovering_upgrade_red_button = function() {
    var button_w = sprite_get_width(spr_botao_upgrade)
    var button_h = sprite_get_height(spr_botao_upgrade)
    
    return point_in_rectangle(
        mouse_x,
        mouse_y,
        x + 100 + button_gap - button_w / 2,
        y + 1,
        x + 100 + button_gap + button_w / 2,
        y + button_h
    )
}

buy_upgrade = function() {
    if(remaining_points() > 0 && get_points() < 3) {
        ROOT.state.upgrade_levels[upgrade_id]++
        ROOT.state.upgrade_points--
        audio_play_sound(snd_button_click, 0, 0, 1, 0, 1.1)
        ROOT.events.emit("shake-screen", ms(75))
    }
}

remove_upgrade = function() {
    if(get_points() > 0) {
        ROOT.state.upgrade_levels[upgrade_id]--
        ROOT.state.upgrade_points++
        audio_play_sound(snd_button_click, 0, 0, 1, 0, 0.8)
        ROOT.events.emit("shake-screen", ms(75))
    }
}

create_tween(id, "x", xstart, seconds(2))
    .delay(seconds(1))
    .from(x + room_width)
    .ease(ANIMATION_EASINGS.OUT_CUBIC)
    .fill(ANIMATION_FILL_MODES.BOTH)