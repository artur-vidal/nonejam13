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

ROOT.events.connect("show-finish", appear)
ROOT.events.connect("hide-finish", disappear)

image_speed = 0