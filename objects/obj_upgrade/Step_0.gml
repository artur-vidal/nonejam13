var hovered_now = is_hovered()

if(hovered_now != hovering) {
    if(hovered_now) {
        ROOT.events.emit("upgrade-hovered", upgrade_id)
    }
}

if(mouse_check_button_released(mb_left)) {
    if(hovering_upgrade_green_button()) {
        buy_upgrade()
    } else if(hovering_upgrade_red_button()) {
        remove_upgrade()
    }
    
    // show_message(ROOT.state.get_upgrade_effect(upgrade_id))
}

hovering = hovered_now