function ShaderManager() constructor {
    
    parameters = {
        uvs: {
            uniform: shader_get_uniform(shd_shaders, "u_uvs"),
            value: [0, 0, 1, 1]
        },
        texel_size: {
            uniform: shader_get_uniform(shd_shaders, "u_texel_size"),
            value: [1, 1]
        },
        
        
        
        brightness: {
            uniform: shader_get_uniform(shd_shaders, "u_brightness"),
            value: 0
        },
        contrast: {
            uniform: shader_get_uniform(shd_shaders, "u_contrast"),
            value: 1
        },
        saturation: {
            uniform: shader_get_uniform(shd_shaders, "u_saturation"),
            value: 1
        },
        gamma: {
            uniform: shader_get_uniform(shd_shaders, "u_gamma"),
            value: 1
        },
        opacity: {
            uniform: shader_get_uniform(shd_shaders, "u_opacity"),
            value: 1
        },
        
        
        
        xwave: {
            uniform: shader_get_uniform(shd_shaders, "u_xwave"),
            value: [0, 0, 0]
        },
        ywave: {
            uniform: shader_get_uniform(shd_shaders, "u_ywave"),
            value: [0, 0, 0]
        },
        
        
        
        hue_shift: {
            uniform: shader_get_uniform(shd_shaders, "u_hue_shift"),
            value: 0
        },
        
        
        
        noise: {
            uniform: shader_get_uniform(shd_shaders, "u_noise"),
            value: 0
        },
        
        // esse em especifico usa value como multiplicador
        time: {
            uniform: shader_get_uniform(shd_shaders, "u_time"),
            value: 1
        }
    }
    
    default_parameters = struct_copy(self.parameters);
    
    // utilitários
    function set_brightness(value) {
        self.parameters.brightness.value = value;
    }
    
    function set_contrast(value) {
        self.parameters.contrast.value = value;
    }
    
    function set_saturation(value) {
        self.parameters.saturation.value = value;
    }
    
    function set_gamma(value) {
        self.parameters.gamma.value = value;
    }
    
    function set_opacity(value) {
        self.parameters.opacity.value = value;
    }
    
    function set_hue_shift(value) {
        self.parameters.hue_shift.value = value;
    }
    
    function set_xwave(frequency, amplitude, speed) {
        self.parameters.xwave.value = [
            frequency,
            amplitude,
            speed
        ];
    }
    
    function set_ywave(frequency, amplitude, speed) {
        self.parameters.ywave.value = [
            frequency,
            amplitude,
            speed
        ];
    }
    
    function set_noise(value) {
        self.parameters.noise.value = value;
    }
    
    function for_sprite(sprite, subimg) {
        var uvs = sprite_get_uvs(sprite, subimg);
        
        self.parameters.uvs.value = [
            uvs[0],
            uvs[1],
            uvs[2],
            uvs[3]
        ];
        
        self.parameters.texel_size.value =
            get_sprite_texel_size(sprite, subimg);
    }
    
    function for_surface(surf) {
        var texture = surface_get_texture(surf)
        self.parameters.texel_size.value = [
            texture_get_texel_width(texture),
            texture_get_texel_height(texture)
        ]
    }
    
    function apply() {
        shader_set(shd_shaders);
        
        shader_set_uniform_f_array(
            self.parameters.uvs.uniform,
            self.parameters.uvs.value
        );
        
        shader_set_uniform_f_array(
            self.parameters.texel_size.uniform,
            self.parameters.texel_size.value
        );
        
        shader_set_uniform_f(
            self.parameters.brightness.uniform,
            self.parameters.brightness.value
        );
        
        shader_set_uniform_f(
            self.parameters.contrast.uniform,
            self.parameters.contrast.value
        );
        
        shader_set_uniform_f(
            self.parameters.saturation.uniform,
            self.parameters.saturation.value
        );
        
        shader_set_uniform_f(
            self.parameters.gamma.uniform,
            self.parameters.gamma.value
        );
        
        shader_set_uniform_f(
            self.parameters.opacity.uniform,
            self.parameters.opacity.value
        );
        
        shader_set_uniform_f_array(
            self.parameters.xwave.uniform,
            self.parameters.xwave.value
        );
        
        shader_set_uniform_f_array(
            self.parameters.ywave.uniform,
            self.parameters.ywave.value
        );
        
        shader_set_uniform_f(
            self.parameters.hue_shift.uniform,
            self.parameters.hue_shift.value
        );
        
        shader_set_uniform_f(
            self.parameters.noise.uniform,
            self.parameters.noise.value
        );
        
        shader_set_uniform_f(
            self.parameters.time.uniform,
            (current_time / 1000) * self.parameters.time.value
        )
    }
    
    function reset() {
        shader_reset();
        self.parameters = struct_copy(self.default_parameters);
    }
}