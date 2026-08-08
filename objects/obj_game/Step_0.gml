if(period == "day") {
    if(all_added()) {
        if(!ended_period) {
            ROOT.events.emit("show-finish")
        }
        
        ended_period = true
    } else {
        if(ended_period) {
            ROOT.events.emit("hide-finish")
        }
        
        ended_period = false
    }
} else if (period == "night") {
    if(sentences_completed()) {
        if(!ended_period) {
            ROOT.events.emit("show-finish")
        }
        
        ended_period = true
    } else {
        if(ended_period) {
            ROOT.events.emit("hide-finish")
        }
        
        ended_period = false
    }
}