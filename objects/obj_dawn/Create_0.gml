depth = -100

results = []

stage = 0 // 0 - resultados, 1 - upgrades
alpha = 1

/// @param {Array<Struct.NewsResult>} _results
init = function(_results) {
    results = _results
    var strings = []
    for (var i = 0; i < array_length(results); i++) {
        array_push(strings, results[i].str)
    	results[i].calculate()
    }
    
    var factors = 1
    for (var i = 0; i < array_length(results); i++) {
    	factors += results[i].factor - 1
        
        ROOT.state.confidence += results[i].others.confidence_increase
        ROOT.state.violence += results[i].others.violence_increase
        ROOT.state.seriousness += results[i].others.seriousness_increase
        
        ROOT.state.upgrade_points += 2
        if(results[i].others.additional_point) {
            ROOT.state.upgrade_points++
        }
    }
    
    // clipboard_set_text(json_stringify(results, true))
    var add_people = floor(ROOT.state.people * factors)
    singleton(obj_results).init(strings, add_people, results)
    ROOT.state.people += add_people
}

next = function() {
    switch(stage) {
        case 0:
            var results = singleton(obj_results)
            results.sequence.cancel()
            results.rising = false
            create_tween(results.id, "x", -600, seconds(2))
                .ease(ANIMATION_EASINGS.IN_BACK)
                .on_complete(function() {
                    room_goto(rm_dawn_upgrades)
                    instance_destroy(obj_results)
                    stage = 1
                })
            break
        case 1:
            create_tween(id, "alpha", 1, seconds(2))
                .ease(ANIMATION_EASINGS.IN_CUBIC)
                .on_complete(function() {
                    if(ROOT.state.day < 6) { 
                        set_cursor(0)
                        ROOT.goto_day(ROOT.state.day + 1)
                        GAME.reset()
                    } else {
                        room_goto(rm_cutscene_outro)
                    }
                      
                    instance_destroy(id)
                })
            break
    }
}

create_tween(id, "alpha", 0, seconds(2))
audio_play_sound(msc_results, 0, 1)
audio_sound_gain(msc_results, 0, 0)
audio_sound_gain(msc_results, 1, 2000)

ROOT.events.connect("dawn-next-stage", next)

ROOT.events.emit("show-finish")