var clicking = mouse_check_button(mb_left)
var papers = get_hovered_papers()

if(array_length(papers) > 0) {
    var top_paper = papers[0]
    
    // se não estiver arrastando nada
    if !(dragging && dragging != top_paper) {
        if(!hovering) {
            top_paper.hover()
            hovering = top_paper
        } else {
            if(clicking) {
                top_paper.drag()
                dragging = top_paper
            } else if(dragging) {
                dragging.undrag()
                dragging = noone
            }
        }
    }
    
    
} else {
    
    if(hovering && !dragging) {
        hovering.unhover()
        hovering = noone
    } else if(!clicking and dragging) {
        dragging.undrag()
        dragging = noone
    }
    
}

window_set_cursor(hovering ? cr_size_all : cr_default)