var hovered_slot_now = hovering_any_slot()

if(hovered_slot_now != slot_hovered) {
    // entrou
    if(slot_hovered = undefined) {
        ROOT.events.emit("paper-hover-slot", hovered_slot_now)
    } else { // saiu
        ROOT.events.emit("paper-unhover-slot")
    }
}

slot_hovered = hovered_slot_now