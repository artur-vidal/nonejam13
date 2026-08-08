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
    }
    clipboard_set_text(json_stringify(results, true))
    ROOT.state.people += floor(ROOT.state.people * factors)
}

alarm[0] = 300