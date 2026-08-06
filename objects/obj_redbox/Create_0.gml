drop = function(data) {
    if(data.accepted) {
        return
    }
    
    var paper = data.paper
    if(!position_meeting(paper.x, paper.y, id)) {
        return
    }
    
    var game = GAME
    
    game.remove_term(paper.term)
    
    create_tween(id, "image_xscale", 1, ms(700))
        .ease(ANIMATION_EASINGS.OUT_BACK)
        .from(1.3)
    
    create_tween(id, "image_yscale", 1, ms(700))
        .ease(ANIMATION_EASINGS.OUT_BACK)
        .from(0.6)
    
    data.accepted = true
    data.destroy = true
}

ROOT.events.connect("paper-drop", drop)