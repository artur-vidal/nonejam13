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
/// @param {int} n O número de segundos
function seconds(n) {
    return floor(n * game_get_speed(gamespeed_fps))
}

/// @description Converte o número de milissegundos passado em steps
/// @param {int} n O número de milissegundos
function ms(n) {
    return floor(n / 1000 * game_get_speed(gamespeed_fps))
}

/// @description Retorna o tamanho de um pixel do sprite passado
/// @param {Asset.GMSprite} sprite O sprite a checar
/// @param {int} index O index do sprite a checar
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

/// @description Cor RGB simples.
function RGB() constructor {
    r = 255
    g = 255
    b = 255
    
    compute = function() {
        return make_colour_rgb(self.r, self.g, self.b)
    } 
}