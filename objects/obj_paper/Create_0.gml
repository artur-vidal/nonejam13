term = get_terms(1)

angle = 0

hovering = false
dragging = false

on_green = false
on_red = false

color = new RGB()

angle_tween = undefined
scale_tween = undefined

sprite = new Sprite(spr_paper)

width = 0
height = 0
padding = 0
mask_padding = 4

base_scale = 0.55
scale = base_scale
scale_decrement = 0

xto = x
yto = y
spd = 0

original_x = x
original_y = y

hover = function() {
    if(angle_tween) angle_tween.cancel();
    angle_tween = create_tween(id, "angle", choose(-8, -4, 4, 8), ms(500))
        .ease(ANIMATION_EASINGS.OUT_ELASTIC)
    
    hovering = true
}

unhover = function() {
    if(angle_tween) angle_tween.cancel();
    angle_tween = create_tween(id, "angle", random_range(-2, 2), ms(300))
        .ease(ANIMATION_EASINGS.OUT_QUAD)
    
    hovering = false
}

drag = function() {
    if(scale_tween) scale_tween.cancel();
    scale_tween = create_tween(id, "scale", base_scale * 1.1, ms(500))
        .ease(ANIMATION_EASINGS.OUT_ELASTIC)
    
    dragging = true
    audio_play_sound(snd_paper_grab, 0, 0)
}

undrag = function(dropped_in_area = true) {
    if(scale_tween) scale_tween.cancel();
    scale_tween = create_tween(id, "scale", base_scale, ms(200))
        .ease(ANIMATION_EASINGS.OUT_CUBIC)
    
    if(dropped_in_area) {
        original_x = x
        original_y = y
    }
    
    dragging = false
    audio_play_sound(snd_paper_grab, 0, 0, 1, 0, .7)
}

is_hovered = function() {
    return point_in_rectangle(
        mouse_x, 
        mouse_y, 
        x - width / 2 - mask_padding, 
        y - height / 2 - mask_padding, 
        x + width / 2 + mask_padding, 
        y + height / 2 + mask_padding
    )
}

poof = function() {
    audio_play_sound(choose(snd_bag_1, snd_bag_2), 0, 0)
    ROOT.particle_system.poof(x, y)
}

poof_and_destroy = function() {
    poof()
    
    ROOT.events.emit("paper-destroyed")
    call_later(1, time_source_units_frames, method(id, function() {
        instance_destroy(id)
    }))
}

go_back = function() {
    xto = original_x
    yto = original_y
}