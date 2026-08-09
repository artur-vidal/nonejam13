if(!GAME.started_playing) exit;
    
if(!active) {
    GAME.pause()
    create_tween(id, "y", room_height - sprite_height, ms(1500))
        .ease(ANIMATION_EASINGS.IN_OUT_BACK)
    active = true
    alpha_animation()
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
}