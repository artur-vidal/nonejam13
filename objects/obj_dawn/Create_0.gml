results = undefined

flags = {
    
}

/// @param {Array<Struct.NewsResult>} _results
init = function(_results) {
    results = _results
    for (var i = 0; i < array_length(results); i++) {
    	results[i].calculate()
    }
    
    var factors = 1
    for (var i = 0; i < array_length(results); i++) {
    	factors += results[i].factor - 1
        
        ROOT.state.confidence += results[i].others.confidence_increase
        ROOT.state.violence += results[i].others.violence_increase
        ROOT.state.seriousness += results[i].others.seriousness_increase
        
        ROOT.state.upgrade_points++
        if(results[i].others.additional_point) {
            ROOT.state.upgrade_points++
        }
    }
    
    clipboard_set_text(json_stringify(results, true))
    ROOT.state.people += floor(ROOT.state.people * factors)
}

alarm[0] = 300