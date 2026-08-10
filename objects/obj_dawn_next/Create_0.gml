active = true
image_speed = 0

scale_tween = undefined

hover_scale = function() {
    if(scale_tween) {
        scale_tween.cancel()
    }
    
    create_tween(id, "image_xscale", 1.05, ms(300))
        .from(1)
        .ease(ANIMATION_EASINGS.OUT_BACK)
    
    create_tween(id, "image_yscale", 0.95, ms(300))
        .from(1)
        .ease(ANIMATION_EASINGS.OUT_BACK)
}

unhover_scale = function() {
    if(scale_tween) {
        scale_tween.cancel()
    }
    
    create_tween(id, "image_xscale", 1, ms(300))
        .from(1.05)
        .ease(ANIMATION_EASINGS.OUT_BACK)
    
    create_tween(id, "image_yscale", 1, ms(300))
        .from(0.95)
        .ease(ANIMATION_EASINGS.OUT_BACK)
}

if(room == rm_dawn_results) {
    create_tween(id, "x", x, ms(500))
        .from(room_width + 60)
        .delay(seconds(2))
        .ease(ANIMATION_EASINGS.OUT_CUBIC)
        .fill(ANIMATION_FILL_MODES.BOTH)
}