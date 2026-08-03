manchete = "ladrão rouba idoso no meio da rua"
termos = [
    {
        termo_id: 1,
        texto: "ladrão",
        secreto: false
    },
    {
        termo_id: 2,
        texto: "idoso",
        secreto: true
    },
    {
        termo_id: 3,
        texto: "meio da rua",
        secreto: false
    },
]

space_width = 8
line_h = 10
padding_x = 8
padding_y = 12
max_width = 80
text_scale = 0.65

// se torna true quanto todos os termos não-secretos forem recortados
trashable = false
trash_alpha = 0
trash_gap = 4
hovering_trash = false
active = true

// preenchido em rebuild_layout()
tokens = []

termos_ordenados = array_create(array_length(termos))
array_copy(termos_ordenados, 0, termos, 0, array_length(termos))

// ordenando os termos por tamanho, assim termos como
// "maçã" e "maçã verde" na mesma frase não vão conflitar
// (são ordenados descrescente, então maçã verde tem prioridade)
array_sort(termos_ordenados, function(_a, _b) {
    return string_length(_b) - string_length(_a)
})

// retorna o termo encontrado naquela posição da string
function termo_em(_str, _pos, _lista_termos) {
    for (var i = 0; i < array_length(_lista_termos); i++) {
        var _termo = _lista_termos[i]
        var _len = string_length(_termo.texto)
        
        if (_pos + _len - 1 > string_length(_str)) continue;
            
        var _trecho = string_copy(_str, _pos, _len)
        if (string_lower(_trecho) == string_lower(_termo.texto)) {
            return _termo
        }
    }
    
    return { 
        termo_id: 1,
        texto: "",
        secreto: false
    } // termo vazio se não encontrou nenhum
}

function num_linhas() {
    var _max_y = 0
    for (var i = 0; i < array_length(tokens); i++) {
        _max_y = max(_max_y, tokens[i].y)
    }
    return floor((_max_y) / (line_h * text_scale))
}

function tokenizar(_str, _lista_termos) {
    var _resultado = []
    var _pos = 1 // strings >:(
    var _len_total = string_length(_str)
    var _buffer = ""
    
    // logica do bagulho !!!!
    // _pos passa por cada posição da string. se naquela posição
    // tiver um termo, eu adiciono o _buffer (ja explico)
    // e esse termo nos tokens.
    // caso não tiver termo nessa posição, eu adiciono o caractere
    // atual no buffer; ele basicamente vai comendo as letras das
    // palavras normais e adiciona elas como tokens não-recortáveis.
    // quando o _buffer chega em um espaço, ele é adicionado
    // nos tokens e reinicia.
    while (_pos <= _len_total) {
        var _termo_encontrado = termo_em(_str, _pos, _lista_termos)
        
        if (_termo_encontrado.texto != "") {
            if (string_trim(_buffer) != "") {
                array_push(_resultado, {
                    texto: string_trim(_buffer),
                    recortavel: false,
                    recortado: false,
                    secreto: false
                })
            }
            _buffer = ""
            
            array_push(_resultado, {
                texto: _termo_encontrado.texto,
                recortavel: true,
                recortado: false,
                secreto: _termo_encontrado.secreto
            })
            
            _pos += string_length(_termo_encontrado.texto)
        } else {
            // caractere normal, acumula no buffer
            var _char = string_char_at(_str, _pos)
            _buffer += _char
            
            // se bateu num espaço, fecha a palavra atual como token não-recortável
            if (_char == " ") {
                if (string_trim(_buffer) != "") {
                    array_push(_resultado, {
                        texto: string_trim(_buffer),
                        recortavel: false,
                        recortado: false,
                        secreto: false
                    })
                }
                _buffer = ""
            }
            _pos += 1
        }
    }
    
    // fecha o que sobrou no buffer ao chegar ao fim da string
    if (string_trim(_buffer) != "") {
        array_push(_resultado, {
            texto: string_trim(_buffer),
            recortavel: false,
            recortado: false,
            secreto: false
        })
    }
    
    return _resultado
}

function calcular_layout() {
    var _fonte_antiga = draw_get_font()
    draw_set_font(fnt_paper)
    
    var _x = padding_x
    var _y = padding_y
    
    for (var i = 0; i < array_length(tokens); i++) {
        var tok = tokens[i]
        var _largura = string_width(tok.texto) * text_scale
        var _altura = string_height(tok.texto) * text_scale
        
        // quebra de linha se não couber
        if (_x + _largura > max_width && _x > padding_x) {
            _x = padding_x
            _y += line_h
        }
        
        tok.x = _x
        tok.y = _y
        tok.largura = _largura
        tok.altura = _altura
        
        _x += _largura + space_width
    }
    
    draw_set_font(_fonte_antiga)
}

function get_width() {
    return max_width + padding_x * 2
}

function get_height() {
    return padding_y * 2 + line_h * (num_linhas() + 1)
}

function rebuild_layout() {
    tokens = tokenizar(manchete, termos_ordenados)
    calcular_layout()
}

function normal_tokens_cut() {
    return array_all(tokens, function(tok) {
        return !tok.recortavel || tok.secreto || (tok.recortavel && tok.recortado)
    })
}

function all_tokens_cut() {
    return array_all(tokens, function(tok) {
        return !tok.recortavel || (tok.recortavel && tok.recortado)
    })
}

function trash() {
    create_tween(id, "y", room_height + 10, seconds(2))
        .ease(ANIMATION_EASINGS.OUT_CUBIC)
        .on_complete(destroy)
    
    active = false
}

// precisa estar assim pra usar no tween
destroy = function() {
    instance_destroy(id)
}

// criando layout e fazendo animação do papel surgindo de baixo
rebuild_layout()
create_tween(id, "y", room_height - get_height() + 16, seconds(1))
    .from(room_height)
    .ease(ANIMATION_EASINGS.OUT_CUBIC)
x = 20