image_speed = 0
tween = undefined
anim_ms = 300

clicked = false

hover = function() {
    if(tween) {
        tween.cancel()
    }
    
    create_tween(id, "image_xscale", 1.15, ms(anim_ms))
        .ease(ANIMATION_EASINGS.OUT_CUBIC)
    create_tween(id, "image_yscale", 0.9, ms(anim_ms))
        .ease(ANIMATION_EASINGS.OUT_CUBIC)
    
    audio_play_sound(snd_button_hover, 0, 0)
}

unhover = function() {
    if(tween) {
        tween.cancel()
    }
    
    create_tween(id, "image_xscale", 1, ms(anim_ms))
        .ease(ANIMATION_EASINGS.OUT_CUBIC)
    create_tween(id, "image_yscale", 1, ms(anim_ms))
        .ease(ANIMATION_EASINGS.OUT_CUBIC)
}


create_tween(id, "y", ystart, seconds(2.5))
    .from(room_height + 80)
    .delay(seconds(3))
    .fill(ANIMATION_FILL_MODES.BOTH)
    .ease(ANIMATION_EASINGS.OUT_BACK)