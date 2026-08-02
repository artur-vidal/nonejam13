hovering = noone
dragging = noone

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