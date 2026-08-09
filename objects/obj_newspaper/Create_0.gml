depth = -50

hovering_token = undefined

space_width = 2
line_h = 8
padding = 10
block_gap = 8
max_width = 60 + padding * 2
text_scale = 0.7

active = true
processed_blocks = [] 

function term_at(_text, _pos, _headline_terms) {
    for (var i = 0; i < array_length(_headline_terms); i++) {
        var headline_term = _headline_terms[i]
        var term = headline_term.get_term()
        var len = string_length(term.content)
        
        // se já acabou a string eu procuro o próximo
        if (_pos + len - 1 > string_length(_text)) continue
        
        // se o pedaço da string for igual ao texto do termo, achei :)
        var piece = string_copy(_text, _pos, len)
        if (string_lower(piece) == string_lower(term.content)) {
            return headline_term
        }
    }

    return undefined
}

function tokenize_headline(_headline) {
    var _tokens = []
    var _pos = 1
    var _len_total = string_length(_headline.content)
    
    // o buffer vai comendo as letras normais da palavra pra criar
    // e diferencias tokens não-recortáveis
    var _buffer = ""
    
    while (_pos <= _len_total) {
        var _headline_term = term_at(_headline.content, _pos, _headline.terms)
        
        if (_headline_term != undefined) {
            if (string_trim(_buffer) != "") {
                array_push(_tokens, {
                    text: string_trim(_buffer),
                    cuttable: false,
                    cut: false,
                    headline_term: undefined
                })
            }
            _buffer = ""
            
            var _term = _headline_term.get_term()
            array_push(_tokens, {
                text: _term.content,
                cuttable: true,
                cut: false,
                headline_term: _headline_term // guarda a referência: dá acesso a .secreto e .get_term()
            })
            
            _pos += string_length(_term.content)
        } else {
            var _char = string_char_at(_headline.content, _pos)
            _buffer += _char
            
            if (_char == " ") {
                if (string_trim(_buffer) != "") {
                    array_push(_tokens, {
                        text: string_trim(_buffer),
                        cuttable: false,
                        cut: false,
                        headline_term: undefined
                    })
                }
                _buffer = ""
            }
            _pos += 1
        }
    }

    if (string_trim(_buffer) != "") {
        array_push(_tokens, {
            text: string_trim(_buffer),
            cuttable: false,
            cut: false,
            headline_term: undefined
        })
    }
    
    return _tokens
}

function layout_tokens(tokens) {
    var prev_font = draw_get_font()
    draw_set_font(fnt_paper)
    
    var _x = 0
    var _y = 0
    
    for (var i = 0; i < array_length(tokens); i++) {
        var tok = tokens[i]
        var w = string_width(tok.text) * text_scale
        var h = string_height(tok.text) * text_scale
        
        if (_x + w > max_width && _x > 0) {
            _x = 0
            _y += line_h
        }
        
        tok.x = _x
        tok.y = _y
        tok.width = w
        tok.height = h
        
        _x += w + space_width
    }
    
    draw_set_font(prev_font)
    
    // altura total ocupada por esse bloco de tokens
    var _max_y = array_last(tokens).y + line_h
    return _max_y
}

function build_layout(newspaper) {
    processed_blocks = []
    
    var _y = padding
    
    for (var i = 0; i < array_length(newspaper.blocks); i++) {
        var block = newspaper.blocks[i]
        
        if (is_instanceof(block, Headline)) {
            var _tokens = tokenize_headline(block)
            var _height = layout_tokens(_tokens)
            
            array_push(processed_blocks, {
                type: "headline",
                y_offset: _y,
                tokens: _tokens,
                height: _height
            })
            
            _y += _height + block_gap
        } else if (is_instanceof(block, NewspaperDeco)) {
            var _height = sprite_get_height(block.sprite) + (i == 0 ? 8 : 0)
            
            array_push(processed_blocks, {
                type: "deco",
                y_offset: _y,
                deco: block,
                height: _height
            })
            
            _y += _height + block_gap
        }
    }

    content_height = _y - block_gap
}

function get_width() {
    return max_width + padding * 2
}

function get_height() {
    return padding * 2 + content_height
}

function hovering_any_token() {
    for (var i = 0; i < array_length(processed_blocks); i++) {
        var block = processed_blocks[i]
        
        if (block.type != "headline") continue
            
        for (var t = 0; t < array_length(block.tokens); t++) {
            var tok = block.tokens[t];
            
            if (!tok.cuttable || tok.cut) continue
                
            var x1 = x + padding + tok.x
            var y1 = y + block.y_offset + tok.y
            var x2 = x1 + tok.width
            var y2 = y1 + tok.height
            
            if (point_in_rectangle(
                mouse_x, 
                mouse_y,
                x1,
                y1,
                x2,
                y2)
            ) {
                return { token: tok, block: block }
            }
        }
    }
    
    return undefined
}

function all_tokens_cut() {
    for (var i = 0; i < array_length(processed_blocks); i++) {
    	var block = processed_blocks[i]
        
        if(block.type != "headline") continue;
        
        var tokens = block.tokens
        for(var j = 0; j < array_length(tokens); j++) {
            var tok = tokens[j]
            if(tok.cuttable && !tok.cut) {
                return false
            }
        }
    }
    
    return true
}

function init(newspaper) {
    build_layout(newspaper)
    x = 20
    create_tween(id, "y", room_height - get_height() + padding, seconds(1))
        .ease(ANIMATION_EASINGS.OUT_SINE)
        .from(room_height)
}

function destroy() {
    instance_destroy(id)
    ROOT.events.emit("next-news")
}