sentence = undefined
processed_blocks = []
slot_hovered = undefined

width = 90
content_height = 0

line_h = 14
space_width = 4
padding = 8

text_scale = 0.7

get_width = function() {
    return width + padding * 2
}

get_height = function() {
    return content_height + padding
}

hovering_any_slot = function() {
    if(!singleton(obj_paper_controller).dragging) {
        return undefined
    }
    
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
    var _y = padding
    
    for (var i = 0; i < array_length(sentence.blocks); i++) {
        var block = sentence.blocks[i]
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
    }
    
    content_height = _y + padding
    draw_set_font(prev_font)
}

init = function(_sentence) {
    sentence = get_sentence(instance_number(object_index) - 1)
    build_layout()
}

drop = function(data) {
    if(data.destroy) {
        return
    }
    
    var slot = hovering_any_slot()
    if(!slot) {
        return
    }
    
    if(slot.block.type != data.paper.term.type) {
        data.accepted = true
        return
    }
    
    ROOT.events.emit("paper-drop-slot", data.paper.term, slot)
    build_layout()
    
    data.accepted = true
    data.destroy = true
}

ROOT.events.connect("paper-drop", drop)