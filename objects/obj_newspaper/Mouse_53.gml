if (hovering_token != undefined && !singleton(obj_paper_controller).hovering) {
    var tok = hovering_token.token
    var block = hovering_token.block
    
    tok.cut = true
    
    var term = tok.headline_term.get_term()
    create_paper(term, mouse_x, mouse_y)
}