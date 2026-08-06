#macro GAME singleton(obj_game)

/// @description Retorna ou cria uma instância global do objeto
/// @param {Asset.GMObject} obj O objeto que será retornado
function singleton(obj){
    var instance = noone
    
    // checagens extras caso a instância desapareça
    if(!instance || !instance_exists(instance)) {
        instance = instance_find(obj, 0)
        
        if(!instance) { 
            object_set_persistent(obj, true)
            instance = instance_create_depth(0, 0, 0, obj)   
        }
    }
    
    return instance
}

/// @description Converte o número de segundos passado em steps
/// @param {real} n O número de segundos
function seconds(n) {
    return floor(n * game_get_speed(gamespeed_fps))
}

/// @description Converte o número de milissegundos passado em steps
/// @param {real} n O número de milissegundos
function ms(n) {
    return floor(n / 1000 * game_get_speed(gamespeed_fps))
}

/// @description Retorna o tamanho de um pixel do sprite passado
/// @param {Asset.GMSprite} sprite O sprite a checar
/// @param {real} index O index do sprite a checar
function get_sprite_texel_size(sprite, index) {
    var texture = sprite_get_texture(sprite, index);
    return [
        texture_get_texel_width(texture),
        texture_get_texel_height(texture)
    ];
}

/// @description Define o cursor do jogo. 0 Ponteiro - 1 Mão - 2 Arrastar
function set_cursor(i) {
    ROOT.cursor.sprite = [
        spr_mouse_pointer,
        spr_mouse_handpoint,
        spr_mouse_grab,
    ][i]
}

/// @description Usa draw_set_colour() com a cor do tema.
/// @param {Enum.TermTypes} type
function set_term_type_colour(type) {
    switch (type) {
   	case TermTypes.SUBJECT:
           draw_set_colour(#FFA0A0)
           break
   	case TermTypes.LOCATION:
           draw_set_colour(#A0FFA0)
           break
   	case TermTypes.OBJECT:
           draw_set_colour(#A0A0FF)
           break 
   }
}

/// @description Desenha um retângulo GROSSO.
/// @param {real} x1
/// @param {real} y1
/// @param {real} x2
/// @param {real} y2
/// @param {real} thickness
function draw_rectangle_thick(x1, y1, x2, y2, thickness) {
    var ht = thickness / 2 // half thickness
    draw_line_width(x1 - ht, y1, x2 + ht, y1, thickness) 
    draw_line_width(x1, y1 - ht, x1, y2 + ht, thickness)
    draw_line_width(x1 - ht, y2, x2 + ht, y2, thickness)
    draw_line_width(x2, y1 - ht, x2, y2 + ht, thickness)
}

/// @description Cor RGB simples.
function RGB() constructor {
    r = 255
    g = 255
    b = 255
    
    compute = function() {
        return make_colour_rgb(self.r, self.g, self.b)
    } 
}