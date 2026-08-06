hovering = noone
dragging = noone

area_rect_surface = surface_create(room_width, room_height)
area_rect_alpha = 0

depth = -500

get_drag_area = function() {
    if(GAME.period == "day") {
        return {
            x1: 10,
            y1: 90,
            x2: room_width - 148,
            y2: room_height - 8
        }
    } else if(GAME.period == "night") {
        return {
            x1: 10,
            y1: 10,
            x2: room_width - 10,
            y2: room_height - 8
        }
    }
}

get_hovered_papers = function() {
    var papers = []
    with(obj_paper) { array_push(papers, id) }
    
    papers = array_filter(papers, function(el) {
        return el.is_hovered()
    })
    
    array_sort(papers, function(e1, e2) {
        return e1.depth - e2.depth
    })
    
    return papers
}

mouse_in_area = function() {
    return point_in_rectangle(
        mouse_x,
        mouse_y,
        get_drag_area().x1,
        get_drag_area().y1,
        get_drag_area().x2,
        get_drag_area().y2
    )
}

reset = function() {
    if(instance_exists(hovering)) {
        unhover_slot()
    }
    
    hovering = noone
    dragging = noone
    set_cursor(0)
}

hover_slot = function(_slot) {
    hovering.hovering_slot = _slot
}

unhover_slot = function() {
    if(hovering) {
        hovering.hovering_slot = undefined
    }
}

drop = function(paper) {
    var _drag_data = {
        paper: paper,
        accepted: false,
        destroy: false
    }
    
    ROOT.events.emit("paper-drop", _drag_data)
    
    if(_drag_data.destroy) {
        paper.poof_and_destroy()
    } else {
        var valid_pos = mouse_in_area() 
            && (
                instance_exists(hovering) 
                ? !hovering.hovering_slot 
                : true
            )
        
        paper.undrag(valid_pos)
        paper.go_back()
        dragging = noone
    }
}


ROOT.events.connect("paper-destroyed", reset)
ROOT.events.connect("paper-hover-slot", hover_slot)
ROOT.events.connect("paper-unhover-slot", unhover_slot)