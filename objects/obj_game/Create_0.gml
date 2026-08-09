if(instance_number(obj_game) > 1) {
    instance_destroy(id)
    exit
}

// period = "day" - MOVIDO PARA VARIABLE DEFINITIONS
ended_period = false
playing = true
pause_surface = surface_create(room_width, room_height)
overlay = false

started_playing = false

// DIA DIA DIA DIA DIA
newspaper_index = -1
day_news = [
    [0, 1],
    [2, 3],
    [4, 5],
    [6, 7],
    [8, 9],
    [10, 11, 12],
]

today_news = day_news[ROOT.state.day - 1]

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
    return (max_terms() != infinity) ? term_count() == max_terms() : true
}

all_added = function() {
    return instance_number(obj_paper) == 0 && is_full() && ended_news()
}

retrieve_last_box_term = function() {
    if(array_length(boxed_terms) > 0) {
        var paper_controller = singleton(obj_paper_controller)
        var x1 = paper_controller.get_drag_area().x2 / 2 + 16
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
    started_playing = true
    
    newspaper_index++
    if(ended_news()) {
        return
    }
    
    create_newspaper(today_news[newspaper_index])
    audio_play_sound(snd_paper_crease, 0, 0)
}

ROOT.events.connect("greenbox-drop", add_term_to_box)
ROOT.events.connect("redbox-drop", remove_term_to_box)
ROOT.events.connect("paper-undo", retrieve_last_box_term)
ROOT.events.connect("next-news", next_news)

// NOITE NOITE NIOTE NOITE
sentences = []

add_term_to_slot = function(term, slot) {
    slot.block.set_term(term)
}

submit_sentence = function(sentence) {
    array_push(sentences, sentence)
}

sentences_completed = function() {
    for (var i = 0; i < instance_number(obj_sentence); i++) {
    	if(!instance_find(obj_sentence, i).submitted) {
            return false
        }
    }
    
    return true
}

ROOT.events.connect("paper-drop-slot", add_term_to_slot)
ROOT.events.connect("sentence-submit", submit_sentence)

// gerais
pause = function(_overlay = true) {
    playing = false
    overlay = _overlay
    //ROOT.events.emit("paused")
}

resume = function() {
    playing = true
    overlay = false
    //ROOT.events.emit("resumed")
}

next_stage = function() {
    if(period == "day") {
        pause(false)
        instance_create_depth(0, 0, 0, obj_day_to_night)
    } else if (period == "night") {
        pause(false)
        instance_create_depth(0, 0, 0, obj_night_to_dawn)
    }
}

to_night = function() {
    period = "night"
    ended_period = false
    ROOT.particle_system.poof(-100, -100) // limpa particulas
    singleton(obj_paper_controller).reset()
    
    audio_stop_all()
    audio_play_sound(snd_brass_high, 0, 0, 3)
    audio_play_sound(msc_night_ambience, 1, 1)
    
    room_goto(rm_night)
    
    var night_initialization = function() {
        var added_terms = get_boxed_terms()
        for (var i = 0; i < array_length(added_terms); i++) {
        	var term = added_terms[i].term
            create_paper(term, room_width / 5, room_height / 2, false)
        }
        
        
        var x1 = room_width - 100
        var x2 = x1 - 100 - 10
        
        instance_create_depth(x1, 0, 0, obj_sentence)
        if(ROOT.state.day >= 4) {
            instance_create_depth(x2, 0, 0, obj_sentence)
        }
    }
    
    call_later(1, time_source_units_frames, night_initialization)
}

to_dawn = function() {
    period = "dawn"
    audio_stop_all()
    room_goto(rm_dawn_results)
    
    call_later(1, time_source_units_frames, function() {
        var results = []
        for (var i = 0; i < array_length(sentences); i++) {
        	array_push(results, new NewsResult(sentences[i]))
        }
        
        var dawn = instance_find(obj_dawn, 0)
        dawn.init(results)
        reset()
    })
}

reset = function() {
    boxed_terms = []
    
    for (var i = 0; i < array_length(sentences); i++) {
        var s = sentences[i]
    	for (var j = 0; j < array_length(s.blocks); j++) {
        	var block = s.blocks[j]
            if(!is_instanceof(block, SentenceSlot)) continue;
                
            block.pop_term()
        }
    }
    sentences = []
    
    period = "day"
    today_news = day_news[ROOT.state.day - 1]
    newspaper_index = -1
    started_playing = false
}

// inicialização
if(period == "day") {
    singleton(obj_paper_controller)
    // next_news()
} else if(period == "night") {
    singleton(obj_paper_controller)
    repeat(30) {
        var term = undefined
        do {
            term = get_terms(irandom_range(1, 39))
        } until(term != undefined)
        create_paper(term, 70, 90, false)
    }
    var sentence = instance_create_depth(room_width - 110, 20, 0, obj_sentence)
    sentence.init()
}

depth = -500

ROOT.events.connect("next-stage", next_stage)