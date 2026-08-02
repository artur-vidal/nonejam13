var hovering_now = position_meeting(mouse_x, mouse_y, id)
if(hovering) {
    
    if(hovering_now) window_set_cursor(cr_handpoint); 
    else window_set_cursor(cr_default)
    
    if(
        mouse_check_button_pressed(mb_left)
        && instance_top_position(mouse_x, mouse_y, object_index, false) == id
    ) {
        var inst = instance_create_depth(x, y, 0, obj_paper)
        inst.content = termo.conteudo
        instance_destroy(id)
    }
    
}

hovering = hovering_now