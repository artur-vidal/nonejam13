if(!active) exit;

var clicked_trash_button = trashable && hovering_trash

if(clicked_trash_button) {
    trash()
}

for (var i = 0; i < array_length(tokens); i++) {
    var tok = tokens[i]
    
    if (tok.recortavel && !tok.recortado) {
        var tok_x1 = x + tok.x
        var tok_y1 = y + tok.y
        var tok_x2 = tok_x1 + tok.largura
        var tok_y2 = tok_y1 + tok.altura
        
        var mouse_over = point_in_rectangle(
            mouse_x,
            mouse_y,
            tok_x1,
            tok_y1,
            tok_x2,
            tok_y2
        )
        
        if (mouse_over) {
            tok.recortado = true
            
            var papel = instance_create_depth(
                mouse_x - tok.largura / 2, 
                mouse_y - tok.altura, 
                0, 
                obj_paper
            )
            
            papel.content = tok.texto
            
            break // não preciso mais procurar
        }
    }
}