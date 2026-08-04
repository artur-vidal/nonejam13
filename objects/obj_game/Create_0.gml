selected_terms = []

add_term = function(term) {
    array_push(selected_terms, {
        added: true,
        term: term
    })
}

remove_term = function(term) {
    array_push(selected_terms, {
        added: false,
        term: term
    })
}

get_selected_terms = function() {
    return array_filter(selected_terms, function(el) {
        return el.added == true
    })
}

term_count = function() {
    return array_length(get_selected_terms())
}

max_terms = function() {
    return ROOT.state.get_upgrade_effect(UPGRADES.VOCABULARIO)
}

is_full = function() {
    return max_terms < term_count()
}

retrieve_last_term = function() {
    return array_pop(selected_terms)
}

mouse_in_area = function() {
    return point_in_rectangle(
        mouse_x,
        mouse_y,
        10,
        90,
        room_width - 10,
        room_height - 10
    )
}

ROOT.events.connect("greenbox-drop", add_term)