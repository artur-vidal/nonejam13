period = "day"
ended_period = false
playing = true

// DIA DIA DIA DIA DIA
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
    return term_count() == max_terms()
}

retrieve_last_term = function() {
    return array_pop(selected_terms)
}

ROOT.events.connect("greenbox-drop", add_term)
ROOT.events.connect("redbox-drop", remove_term)

ended_news = function() {
    return newspaper_index > array_length(day_news) - 1
}

next_news = function() {
    newspaper_index++
    if(ended_news()) {
        return
    }
    
    create_newspaper(day_news[newspaper_index])
}

newspaper_index = -1

day_news = [0, 1]
ROOT.events.connect("next-news", next_news)

// NOITE NOITE NIOTE NOITE

// gerais
pause = function() {
    playing = false
    ROOT.events.emit("paused")
}

resume = function() {
    playing = true
    ROOT.events.emit("resumed")
}

to_night = function() {
    period = "night"
    room_goto(rm_night)
    ended_period = false
}

// inicialização
if(period == "day") {
    next_news()
}