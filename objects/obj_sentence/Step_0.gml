var hovered_slot_now = hovering_any_slot()
var dragging_paper = singleton(obj_paper_controller).dragging

if(submitted || !GAME.playing) {
    exit
}

if(mouse_check_button_released(mb_left)) {
    if(hovering_left_arrow()) {
        prev_sentence()
        audio_play_sound(snd_bump, 0, 0)
    } else if(hovering_right_arrow()) {
        next_sentence()
        audio_play_sound(snd_bump, 0, 0)
    }
}

if(hovered_slot_now != slot_hovered) {
    // entrou
    if(
        slot_hovered == undefined 
        && !hovered_slot_now.block.has_content()
    ) {
        ROOT.events.emit("paper-hover-slot", hovered_slot_now)
    } else { // saiu
        ROOT.events.emit("paper-unhover-slot")
    }
    
    if (!dragging_paper) {
        set_cursor(
            ( hovered_slot_now != undefined 
                && hovered_slot_now.block.has_content() )
                ? 1 
                : 0
        )
    }
}

if(hovered_slot_now) {
    var block = hovered_slot_now.block
    if(
        block.has_content()
        && mouse_check_button_pressed(mb_left)
        && !dragging_paper
        && remove_frame
    ) {
        create_paper(block.pop_term(), mouse_x, mouse_y)
        build_layout()
    }
}

// carimbo
var hovering_stamp_now = is_hovering_stamp()
if(hovering_stamp_now != hovering_stamp) {
    if(hovering_stamp_now) {
        set_cursor(1)
    } else {
        set_cursor(0)
    }
}

if(hovering_stamp_now && stampable() && mouse_check_button_released(mb_left)) {
    submitted = true
    set_cursor(0)
    audio_play_sound(snd_bump, 0, 0)
    create_tween(id, "y", y, ms(400))
        .from(y - 6)
        .ease(ANIMATION_EASINGS.OUT_ELASTIC)
    ROOT.events.emit("sentence-submit", sentence)
}

hovering_stamp = hovering_stamp_now
slot_hovered = hovered_slot_now
remove_frame = true