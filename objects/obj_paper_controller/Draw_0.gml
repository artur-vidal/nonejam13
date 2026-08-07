if(!surface_exists(area_rect_surface)) {
    area_rect_surface = surface_create(room_width, room_height)
}

surface_set_target(area_rect_surface)
draw_clear_alpha(c_black, 0)

draw_set_alpha(area_rect_alpha)

draw_set_colour(c_black)
draw_rectangle(0, 0, room_width, room_height, false)
draw_set_colour(c_white)

var _old_blend = gpu_get_blendmode()
gpu_set_blendmode(bm_subtract)

draw_set_alpha(1)

draw_roundrect_ext(
    get_drag_area().x1, 
    get_drag_area().y1, 
    get_drag_area().x2,
    get_drag_area().y2, 
    8, 
    8, 
    false
)

if(GAME.period == "day") {
    // abrindo mais um espaço na area das caixas ali
    draw_roundrect_ext(
        192, 
        96, 
        room_width,
        room_height, 
        8, 
        8, 
        false
    )
}

gpu_set_blendmode(_old_blend)

surface_reset_target()

draw_surface(area_rect_surface, 0, 0)