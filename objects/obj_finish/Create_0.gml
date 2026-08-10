active = false

appear = function() {
    create_tween(id, "x", 0, seconds(1))
       .from(-sprite_width - 16)
       .ease(ANIMATION_EASINGS.OUT_CUBIC)
    
    active = true
}

disappear = function() {
    create_tween(id, "x", -sprite_width - 16, seconds(1))
       .from(0)
       .ease(ANIMATION_EASINGS.OUT_CUBIC)
    
    active = false
}

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

ROOT.events.connect("show-finish", appear)
ROOT.events.connect("hide-finish", disappear)

image_speed = 0