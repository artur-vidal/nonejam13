var clicking = mouse_check_button_pressed(mb_left)
var holding = mouse_check_button(mb_left)

var papers = get_hovered_papers()
if (array_length(papers) > 0) {
    var top_paper = papers[0]

    if (!(dragging && dragging != top_paper)) {
        if (!hovering) {
            top_paper.hover()
            window_set_cursor(cr_size_all)
            hovering = top_paper
        } else if (!dragging) {
            if (holding) {
                top_paper.drag()
                dragging = top_paper
            }
        } else if (!holding) {
            drop(dragging)
            if(dragging) {
                dragging.undrag()
                dragging = noone
            }
        }
    }
} else {
    if (hovering && !dragging) {
        hovering.unhover()
        window_set_cursor(cr_default)
        hovering = noone
    } else if (!holding && dragging) {
        drop(dragging)
        if(dragging) {
            dragging.undrag()
            dragging = noone
        }
    }
}

area_rect_alpha = lerp(
    area_rect_alpha, 
    (!dragging || (dragging && mouse_in_area())) 
        ? 0 
        : 0.75, 
    0.05
)