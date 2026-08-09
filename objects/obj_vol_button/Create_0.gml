image_speed = 0
tween = undefined
anim_ms = 300

hovering = false
toggle = false
draw = true

hover = function() {
    if(tween) {
        tween.cancel()
    }
    
    create_tween(id, "x", xstart - 2, ms(anim_ms))
        .ease(ANIMATION_EASINGS.OUT_CUBIC)
    
    audio_play_sound(snd_button_hover, 0, 0)
}

unhover = function() {
    if(tween) {
        tween.cancel()
    }
    
    create_tween(id, "x", xstart, ms(anim_ms))
        .ease(ANIMATION_EASINGS.OUT_CUBIC)
}

blocked = function() {
    if(instance_exists(obj_menu)) {
        return !singleton(obj_menu).enabled
    } else if(instance_exists(obj_datashow)) {
        return !singleton(obj_datashow).active
    }
    
    return false
}

if(room == rm_menu) {
    create_tween(id, "x", xstart, seconds(2))
        .from(xstart + 50)
        .delay(seconds(3.5))
        .fill(ANIMATION_FILL_MODES.BOTH)
        .ease(ANIMATION_EASINGS.OUT_BACK)
} else if (room == rm_day) {
    draw = false
}