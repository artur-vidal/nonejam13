active = false

appear = function() {
    create_tween(id, "x", room_width, seconds(1))
       .from(room_width + sprite_height + 16)
       .ease(ANIMATION_EASINGS.OUT_CUBIC)
    
    active = true
}

disappear = function() {
    create_tween(id, "x", room_width + sprite_height + 16, seconds(1))
       .from(room_width)
       .ease(ANIMATION_EASINGS.OUT_CUBIC)
    
    active = false
}

ROOT.events.connect("show-finish", appear)
ROOT.events.connect("hide-finish", disappear)

image_speed = 0