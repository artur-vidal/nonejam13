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
    if(array_length(selected_terms) > 0) {
        var paper_controller = singleton(obj_paper_controller)
        var x1 = paper_controller.drag_area.x1 + 16
        var y1 = paper_controller.drag_area.y1 + 16
        var x2 = paper_controller.drag_area.x2 - 16
        var y2 = paper_controller.drag_area.y2 - 16
        
        var _x = irandom_range(x1, x2)
        var _y = irandom_range(y1, y2)
        
        var greenbox = singleton(obj_greenbox)
        var redbox = singleton(obj_redbox)
        
        var element = array_pop(selected_terms)
        var _inst_x = (element.added ? greenbox.x : redbox.x)
        var _inst_y = (element.added ? greenbox.y : redbox.y)
        
        var pap = create_paper(element.term, _inst_x, _inst_y, false)
        pap.xto = _x
        pap.yto = _y
        pap.original_x = _x
        pap.original_y = _y
    }
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