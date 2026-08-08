if(!playing) {
    if(!surface_exists(pause_surface)) {
        pause_surface = surface_create(room_width, room_height)
    }
    
    surface_set_target(pause_surface)
    draw_clear_alpha(c_black, 0.6)
    surface_reset_target()
    
    draw_surface(pause_surface, 0, 0)
}