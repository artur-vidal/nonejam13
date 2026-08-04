hovering = noone
dragging = noone

drag_area = {
    x1: 10,
    y1: 90,
    x2: room_width - 10,
    y2: room_height - 10
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
        drag_area.x1,
        drag_area.y1,
        drag_area.x2,
        drag_area.y2
    )
}

reset = function() {
    hovering = noone
    dragging = noone
    window_set_cursor(cr_default)
}

drop = function(paper) {
    var _drag_data = {
        paper: paper,
        accepted: false
    }
    
    ROOT.events.emit("paper-drop", _drag_data)
}

ROOT.events.connect("paper-destroyed", reset)

area_rect_surface = surface_create(room_width, room_height)
area_rect_alpha = 0

depth = -500