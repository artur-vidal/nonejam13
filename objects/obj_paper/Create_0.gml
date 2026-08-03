content = "papéu"

angle = 0

hovering = false
dragging = false

angle_tween = undefined
scale_tween = undefined

sprite = new Sprite(spr_paper)

width = 0
height = 0
base_scale = 0.55
scale = base_scale
padding = 4

xto = 0
yto = 0
spd = 0

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
}

undrag = function() {
    if(scale_tween) scale_tween.cancel();
    scale_tween = create_tween(id, "scale", base_scale, ms(200))
        .ease(ANIMATION_EASINGS.OUT_CUBIC)
    
    dragging = false
}

is_hovered = function() {
    return point_in_rectangle(
        mouse_x, 
        mouse_y, 
        x - width / 2, 
        y - height / 2, 
        x + width / 2, 
        y + height / 2
    )
}