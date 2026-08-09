if(state == "talking") {
    var pos = point_in_rectangle(
        mouse_x,
        mouse_y,
        text_area.x1,
        text_area.y1,
        text_area.x2,
        text_area.y2
    )
    if(pos) {
        next()
    }
}