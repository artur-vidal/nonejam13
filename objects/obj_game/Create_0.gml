// period = "day" - MOVIDO PARA VARIABLE DEFINITIONS
ended_period = false
playing = true

// DIA DIA DIA DIA DIA
newspaper_index = -1
today_news = [0, 1]

boxed_terms = []

add_term_to_box = function(term) {
    array_push(boxed_terms, {
        added: true,
        term: term
    })
}

remove_term_to_box = function(term) {
    array_push(boxed_terms, {
        added: false,
        term: term
    })
}

get_boxed_terms = function() {
    return array_filter(boxed_terms, function(el) {
        return el.added == true
    })
}

term_count = function() {
    return array_length(get_boxed_terms())
}

max_terms = function() {
    return ROOT.state.get_upgrade_effect(Upgrades.VOCABULARIO)
}

is_full = function() {
    return term_count() == max_terms()
}

retrieve_last_box_term = function() {
    if(array_length(boxed_terms) > 0) {
        var paper_controller = singleton(obj_paper_controller)
        var x1 = paper_controller.get_drag_area().x1 + 16
        var y1 = paper_controller.get_drag_area().y1 + 16
        var x2 = paper_controller.get_drag_area().x2 - 16
        var y2 = paper_controller.get_drag_area().y2 - 16
        
        var _x = irandom_range(x1, x2)
        var _y = irandom_range(y1, y2)
        
        var greenbox = singleton(obj_greenbox)
        var redbox = singleton(obj_redbox)
        
        var element = array_pop(boxed_terms)
        var _inst_x = (element.added ? greenbox.x : redbox.x)
        var _inst_y = (element.added ? greenbox.y : redbox.y)
        
        var pap = create_paper(element.term, _inst_x, _inst_y, false)
        pap.xto = _x
        pap.yto = _y
        pap.original_x = _x
        pap.original_y = _y
    }
}

ended_news = function() {
    return newspaper_index > array_length(today_news) - 1
}

next_news = function() {
    newspaper_index++
    if(ended_news()) {
        return
    }
    
    create_newspaper(today_news[newspaper_index])
}

ROOT.events.connect("greenbox-drop", add_term_to_box)
ROOT.events.connect("redbox-drop", remove_term_to_box)
ROOT.events.connect("next-news", next_news)

// NOITE NOITE NIOTE NOITE
add_term_to_slot = function(term, slot) {
    slot.block.term = term
    slot.block.content = term.content
}

ROOT.events.connect("paper-drop-slot", add_term_to_slot)

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
    ended_period = false
    room_goto(rm_night)
}

// inicialização
if(period == "day") {
    next_news()
} else if(period == "night") {
    var i = 0
    repeat(2) {
        var sentence = instance_create_depth(room_width - 110 - i * 120, 30, 0, obj_sentence)
        sentence.init(i)
        i++
    }
}