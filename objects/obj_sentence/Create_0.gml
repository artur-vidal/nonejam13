sentence = get_sentence(instance_number(object_index) - 1)
processed_blocks = []
slot_hovered = undefined

width = 80
content_height = 0

line_h = 14
space_width = 4
padding = 8
stat_view_height = 60

text_scale = 0.65

remove_frame = true // gambiarra

get_width = function() {
    return width + padding * 2
}

get_height = function() {
    // return content_height + padding // altura dinamica
    return room_height // altura fixa
}

hovering_any_slot = function() {
    for (var i = 0; i < array_length(processed_blocks); i++) {
    	var block = processed_blocks[i]
        
        if(!is_instanceof(block.block, SentenceSlot)) continue;
        
        var mouse_in = point_in_rectangle(
            mouse_x,
            mouse_y,
            block.gx - 2,
            block.gy - 2,
            block.gx + block.width + 2,
            block.gy + block.height + 2
        )
        
        if(mouse_in) {
            return block
        }
    }
    
    return undefined
}

build_layout = function() {
    processed_blocks = []
    
    var prev_font = draw_get_font()
    draw_set_font(fnt_paper)
    
    var _x = padding
    var _y = padding + (stat_view_height) // espaço dos stats
    
    for (var i = 0; i < array_length(sentence.blocks); i++) {
        var block = sentence.blocks[i]
        
        if (is_instanceof(block, SentenceSlot)) {
            var w = block.get_width() * text_scale
            var h = block.get_height() * text_scale
            
            if(_x + w > width && _x > 0) {
                _x = padding
                _y += line_h
            }
            
            array_push(processed_blocks, {
                gx: x + _x,
                gy: y + _y,
                width: w,
                height: h,
                block: block
            })
            
            _x += w + space_width
        } else {
            var words = string_split(block.content, " ")
            
            for (var w_i = 0; w_i < array_length(words); w_i++) {
                var word = words[w_i]
                if (word == "") continue
                
                var w = string_width(word) * text_scale
                var h = string_height(word) * text_scale
                
                if(_x + w > width && _x > 0) {
                    _x = padding
                    _y += line_h
                }
                
                array_push(processed_blocks, {
                    gx: x + _x,
                    gy: y + _y,
                    width: w,
                    height: h,
                    block: block,
                    text: word
                })
                
                _x += w + space_width
            }
        }
    }
    
    content_height = _y + padding
    draw_set_font(prev_font)
}

init = function() {
    sentence = get_sentence(instance_number(object_index) - 1)
    build_layout()
}

drop = function(data) {
    if(data.destroy || data.accepted) {
        return
    }
    
    var slot = hovering_any_slot()
    if(!slot) {
        return
    }
    
    if (slot.block.type != data.paper.term.type) {
        data.accepted = true
        ROOT.events.emit("paper-unhover-slot", data.paper.term, slot)
        data.force_go_back = true
        return
    }
    
    if(slot.block.has_content()) {
        data.accepted = true
        data.force_go_back = true
        return
    }
    
    data.accepted = true
    data.destroy = true
    
    ROOT.events.emit("paper-drop-slot", data.paper.term, slot)
    build_layout()
    remove_frame = false
}

change_sentence = function(num) {
    for (var i = 0; i < array_length(processed_blocks); i++) {
    	var block = processed_blocks[i]
        
        if(!is_instanceof(block.block, SentenceSlot)) continue;
        
        if(block.block.has_content()) {
            create_paper(block.pop_term(), 50, 90)
        }
    }
    
    sentence = get_sentence(num)
    build_layout()
}

next_sentence = function() {
    
}

prev_sentence = function() {
    
}

ROOT.events.connect("paper-drop", drop)