term = get_terms(irandom_range(1, 36))

angle = 0

hovering = false
dragging = false
hovering_slot = undefined

on_green = false
on_red = false

color = new RGB()

angle_tween = undefined
scale_tween = undefined

sprite = new Sprite(spr_paper)

width = 0
height = 0
padding = 6
mask_margin = 2

base_scale = 0.55
scale = base_scale
scale_decrement = 0
scale_decrement_max = 0.1

xto = x
yto = y
spd = 0

collision_radius = 12
collision_force = 8

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

undrag = function(valid_pos = true) {
    if(scale_tween) scale_tween.cancel();
    scale_tween = create_tween(id, "scale", base_scale, ms(200))
        .ease(ANIMATION_EASINGS.OUT_CUBIC)
    
    if(valid_pos) {
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
        x - width / 2 - mask_margin, 
        y - height / 2 - mask_margin, 
        x + width / 2 + mask_margin, 
        y + height / 2 + mask_margin
    )
}

set_dimensions = function() { 
    var prev_font = draw_get_font()
    draw_set_font(fnt_paper)
    
    width = (string_width(term.content) + padding * 2) * (scale - scale_decrement)
    height = (string_height(term.content) + padding * 2) * (scale - scale_decrement)
    
    draw_set_font(prev_font)
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