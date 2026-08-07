var hovered_slot_now = hovering_any_slot()
var dragging_paper = singleton(obj_paper_controller).dragging

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

slot_hovered = hovered_slot_now
remove_frame = true