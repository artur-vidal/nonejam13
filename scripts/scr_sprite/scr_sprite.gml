function Sprite(sprite_index) constructor {
    sprite = sprite_index
    index = 0
    anim_fps = 10
    
    parameters = {
        xscale: 1,
        yscale: 1,
        angle: 0,
        color: c_white,
        alpha: 1
    }
    
    default_parameters = struct_copy(parameters)
    
    get_frames = function() {
        return sprite_get_number(self.sprite)
    }
    
    update = function() {
        var increment = 1 / game_get_speed(gamespeed_fps);
        index += increment
        index %= self.get_frames()
    }
    
    draw = function(x, y) {
        draw_sprite_ext(
            self.sprite,
            self.index,
            x,
            y,
            self.parameters.xscale,
            self.parameters.yscale,
            self.parameters.angle,
            self.parameters.color,
            self.parameters.alpha
        )
    }
    
    draw_shadow = function(x, y, xfactor = 0.05, yfactor = 0.05) {
        var xdiff = lerp(0, room_width / 2 - x, xfactor);
        var ydiff = lerp(0, room_height / 2 - y, yfactor);
        
        draw_sprite_ext(
            self.sprite,
            self.index,
            x - xdiff,
            y + ydiff,
            self.parameters.xscale,
            self.parameters.yscale,
            self.parameters.angle,
            c_black,
            0.3
        )
    }
    
    set_xscale = function(xscale) {
        self.parameters.xscale = xscale
    }
    
    set_yscale = function(yscale) {
        self.parameters.yscale = yscale
    }
    
    set_angle = function(angle) {
        self.parameters.angle = angle
    }
    
    set_color = function(color) {
        self.parameters.color = color
    }
    
    set_alpha = function(alpha) {
        self.parameters.alpha = alpha
    }
}