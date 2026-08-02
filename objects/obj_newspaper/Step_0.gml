if(all_tokens_cut() && active) {
    trash()
}

if(normal_tokens_cut() && !trashable && active) {
    create_tween(id, "trash_alpha", 1, seconds(.5))
        .ease(ANIMATION_EASINGS.OUT_CUBIC)
    
    trashable = true
}

var hovering_trash_now = point_in_rectangle(
    mouse_x,
    mouse_y,
    x + get_width() + trash_gap,
    y,
    x + get_width() + trash_gap + sprite_get_width(spr_trash),
    y + sprite_get_width(spr_trash)
)

if((trashable && active) && hovering_trash != hovering_trash_now) {
    window_set_cursor(hovering_trash_now ? cr_handpoint : cr_default)
}

hovering_trash = hovering_trash_now