sentence_index = -1
sentence = undefined

processed_blocks = []
slot_hovered = undefined

room_y = 10
width = 80
content_height = 0

line_h = 12
space_width = 4
padding = 8
stat_view_height = 60

text_scale = 0.5

// carimbo
hovering_stamp = false
stamp_scale = 0.75
submitted = false

remove_frame = true // gambiarra

// setinhas
arrow_x = 0
arrow_y = 0
arrow_gap = 4

tween = undefined

get_width = function() {
    return width + padding * 2
}

get_height = function() {
    // return content_height + padding // altura dinamica
    return room_height // altura fixa
}

hovering_left_arrow = function() {
    var arrow_w = sprite_get_width(spr_setas)
    var arrow_h = sprite_get_height(spr_setas)
    return point_in_rectangle(
        mouse_x,
        mouse_y,
        x + arrow_x,
        y + arrow_y,
        x + arrow_x + arrow_w,
        y + arrow_y + arrow_h
    )
}

hovering_right_arrow = function() {
    var arrow_w = sprite_get_width(spr_setas)
    var arrow_h = sprite_get_height(spr_setas)
    return point_in_rectangle(
        mouse_x,
        mouse_y,
        x + arrow_x + arrow_w + arrow_gap,
        y + arrow_y,
        x + arrow_x + arrow_w + arrow_gap + arrow_w,
        y + arrow_y + arrow_h
    )
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

is_hovering_stamp = function() {
    var stamp_w = sprite_get_width(spr_carimbo) * stamp_scale
    var stamp_h = sprite_get_width(spr_carimbo) * stamp_scale
    var stamp_x = get_width() - padding
    var stamp_y = get_height() - padding * 2
    
    
    return point_in_rectangle(
        mouse_x,
        mouse_y,
        x + stamp_x - stamp_w,
        y + stamp_y - stamp_h,
        x + stamp_x,
        y + stamp_y
    )
}

stampable = function() {
    for(var i = 0; i < array_length(processed_blocks); i++) {
        var block = processed_blocks[i]
        
        if(!is_instanceof(block.block, SentenceSlot)) continue;
        
        if(!block.block.has_content()) {
            return false
        }
    }
    
    return true
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
                gy: room_y + _y,
                x: _x,
                y: _y,
                width: w,
                height: h,
                block: block
            })
            
            _x += w + space_width
        } else {
            var words = string_split(block.content, " ")
            
            for (var j = 0; j < array_length(words); j++) {
                var word = words[j]
                if (word == "") continue
                
                var w = string_width(word) * text_scale
                var h = string_height(word) * text_scale
                
                if(_x + w > width && _x > 0) {
                    _x = padding
                    _y += line_h
                }
                
                array_push(processed_blocks, {
                    gx: x + _x,
                    gy: room_y + _y,
                    x: _x,
                    y: _y,
                    width: w,
                    height: h,
                    block: block,
                    text: word
                })
                
                _x += w + space_width
            }
        }
    }
    
    draw_set_font(prev_font)
    
    var arrow_w = sprite_get_width(spr_setas)
    var arrow_h = sprite_get_height(spr_setas)
    arrow_x = get_width() - padding - arrow_w * 2 - arrow_gap + 8
    arrow_y = stat_view_height - arrow_h
    
    y = room_y // reset de segurança
    
    content_height = _y + padding
}

get_raw_text = function() {
    var text = ""
    
    for (var i = 0; i < array_length(sentence.blocks); i++) {
        var block = sentence.blocks[i]
        var content = is_instanceof(block, SentenceSlot) 
            ? (block.has_content() ? block.content : "_") 
            : block.content
        
        var first_char = string_char_at(content, 1)
        var no_space = (text == "" || first_char == "," || first_char == "!" || first_char == ".")
        
        text += (no_space ? "" : " ") + content
    }
    
    return text
}

change_sentence = function(num, forwards = true) {
    sentence = get_sentence(num)
    
    with(obj_sentence) {
        if(other.id == id) continue;
        
        if(other.sentence == sentence) {
            if(forwards) {
                other.next_sentence()
            } else {
                other.prev_sentence()
            }
            
            return
        }
    }
    
    for (var i = 0; i < array_length(processed_blocks); i++) {
    	var block = processed_blocks[i]
        
        if(!is_instanceof(block.block, SentenceSlot)) continue;
        
        if(block.block.has_content()) {
            create_paper(block.block.pop_term(), 50, 90, false)
        }
    }
    
    //sentence = get_sentence(num)
    build_layout()
    
    if(tween) {
        tween.cancel()
    }
    
    tween = tween_sequence()
        .next(
            create_tween(id, "y", y - 6, ms(75))
                .ease(ANIMATION_EASINGS.OUT_CIRC)
        )
        .next(
            create_tween(id, "y", y, ms(300))
                .ease(ANIMATION_EASINGS.OUT_BOUNCE)
        )
}

next_sentence = function() {
    sentence_index++
    // 31 é o numero de frases, hardcoded mesmo pq não aprendo
    if(sentence_index > 31 - 1) {
        sentence_index = 0
    }
    change_sentence(sentence_index)
}

prev_sentence = function() {
    sentence_index--
    if(sentence_index < 0) {
        // 31 é o numero de frases, hardcoded mesmo pq não aprendo
        sentence_index = 31 - 1
    }
    change_sentence(sentence_index, false)
}

init = function() {
    sentence_index = instance_number(object_index) - 1
    sentence = get_sentence(sentence_index)
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

init()
ROOT.events.connect("paper-drop", drop)