if(!active) exit;

var _hover_result = hovering_any_token();

if (_hover_result != hovering_token && !singleton(obj_paper_controller).dragging) {
    set_cursor(_hover_result ? 1 : 0)
}

hovering_token = _hover_result;

if(active && all_tokens_cut()) {
    create_tween(id, "y", room_height + 60, seconds(1.5))
        .ease(ANIMATION_EASINGS.IN_BACK)
        .on_complete(destroy)
    
    active = false
}