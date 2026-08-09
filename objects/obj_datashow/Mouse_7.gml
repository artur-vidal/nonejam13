if(!GAME.started_playing) exit;

if(!active) {
    GAME.pause()
    create_tween(id, "y", room_height - sprite_height, ms(1500))
        .ease(ANIMATION_EASINGS.IN_OUT_BACK)
    active = true
    alpha_animation()
    
    audio_play_sound(snd_datashow_toggle, 0, 0)
    audio_play_sound(snd_datashow, 0, 1)
} else {
    GAME.resume()
    create_tween(id, "y", ystart, ms(1500))
        .ease(ANIMATION_EASINGS.IN_OUT_BACK)
    active = false
    set_cursor(0)
    
    if(tween) {
        tween.cancel()
    }
    alpha = 0
    oscillate = false
    
    audio_play_sound(snd_datashow_toggle, 0, 0)
    audio_stop_sound(snd_datashow)
}