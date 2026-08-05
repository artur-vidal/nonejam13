if(period == "day") {
    if(is_full() && ended_news()) {
        ended_period = true
    }
    
    if(ended_period) {
        show_debug_message("NOITEEEE")
    }
} else if (period == "night") {
    
}

