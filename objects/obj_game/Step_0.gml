if(period == "day") {
    if(is_full() && ended_news()) {
        ended_period = true
    }
    
    if(ended_period) {
        to_night()
    }
} else if (period == "night") {
    
}

if(keyboard_check_pressed(vk_space)) {
    if(period == "day") {
        retrieve_last_box_term()
    }
}