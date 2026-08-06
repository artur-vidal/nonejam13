/// @description Cria uma TweenSequence
/// @returns {Struct.TweenSequence}
function tween_sequence() {
    var sq = new TweenSequence()
    ROOT.tween_mgr.add(sq)
    return sq
}

/// @description Cria um tween e o adiciona automaticamente no TweenManager global. Caso usado dentro de TweenSequence.next() ou .parallel(), é retirado do manager global e colocado na sequence.
/// @param {Id.Instance|Struct.Any} target Instância/Struct alvo da animação
/// @param {string} property Nome da propriedade a ser animada
/// @param {any} from Valor inicial da animação
/// @param {any} to Valor final da animação
/// @param {real} duration Duração da animação em steps
/// @returns {Struct.Tween}
function create_tween(target, property, to, duration_steps) {
    var tween = new Tween(target, property, to, duration_steps)
    ROOT.tween_mgr.add(tween)
    return tween
}

enum ANIMATION_EASINGS {
    LINEAR,
    IN_QUAD,
    OUT_QUAD,
    IN_OUT_QUAD,
    IN_CUBIC,
    OUT_CUBIC,
    IN_OUT_CUBIC,
    IN_QUART,
    OUT_QUART,
    IN_OUT_QUART,
    IN_QUINT,
    OUT_QUINT,
    IN_OUT_QUINT,
    IN_SINE,
    OUT_SINE,
    IN_OUT_SINE,
    IN_EXPO,
    OUT_EXPO,
    IN_OUT_EXPO,
    IN_CIRC,
    OUT_CIRC,
    IN_OUT_CIRC,
    IN_BACK,
    OUT_BACK,
    IN_OUT_BACK,
    IN_ELASTIC,
    OUT_ELASTIC,
    IN_OUT_ELASTIC,
    IN_BOUNCE,
    OUT_BOUNCE,
    IN_OUT_BOUNCE
}

enum ANIMATION_FILL_MODES {
    NONE,
    FORWARDS,
    BACKWARDS,
    BOTH
}

enum ANIMATION_DIRECTIONS {
    NORMAL,
    REVERSE,
    ALTERNATE,
    ALTERNATE_REVERSE
}

function TweenManager() constructor {
    tweens = []
    
    add = function(t) {
        array_push(self.tweens, t)
    }
    
    update = function() {
        // atualizando todos
        for (var i = 0; i < array_length(self.tweens); i++) {
        	var t = self.tweens[i]
            t.update()
        }
        
        // retirando tweens inativos
        for (var i = array_length(self.tweens) - 1; i >= 0; i--) {
            var t = self.tweens[i]
        	if(!t.active)
                array_delete(self.tweens, i, 1)
        }
    }
}

function TweenSequence() constructor {
    steps = []
    current_step = 0
    active = true
    paused = false
    
    initialized = false
    
    completion_callback = undefined
    
    // as configurações são aplicadas no início do step
    pending_config = {
        from_value: undefined,
        iteration_relative: false,
        easing: undefined,
        play_delay: undefined,
        play_direction: undefined,
        iteration_count: undefined,
        iteration_callback: undefined,
        tween_completion_callback: undefined,
    }
    
    on_complete = function(callback) {
        self.completion_callback = callback
        return self
    }
    
    prepare_tween_for_sequence = function(t) {
        t.pending = true
        t.in_sequence = true
        
        var tweens = ROOT.tween_mgr.tweens
        for (var i = array_length(tweens) - 1; i >= 0; i--) {
        	if(t == tweens[i]) {
                array_delete(tweens, i, 1)
                break
            }
        }
    }
    
    next = function(t) {
        self.prepare_tween_for_sequence(t)
        array_push(self.steps, [t])
        return self
    }
    
    parallel = function(t) {
        self.prepare_tween_for_sequence(t)
        
        var step_count = array_length(self.steps)
        if(step_count == 0) {
            array_push(self.steps, [t])
        } else {
            array_push(self.steps[step_count - 1], t)   
        }
        
        return self
    }
    
    last = function() {
        var group = array_last(self.steps)
        return array_last(group)
    }
    
    // aplica las configuraciones
    apply_pending_config = function(t) {
        var cfg = self.pending_config
        
        if(cfg.from_value != undefined)
            t.from(cfg.from_value)
        
        if(cfg.iteration_relative)
            t.iteration_relative()
        
        if(cfg.easing != undefined)
            t.ease(cfg.easing)
        
        if(cfg.play_delay != undefined)
            t.delay(cfg.play_delay)
        
        if(cfg.play_direction != undefined)
            t.direction(cfg.play_direction)
        
        if(cfg.iteration_count != undefined)
            t.loops(cfg.iteration_count)
        
        if(cfg.iteration_callback != undefined)
            t.on_iteration(cfg.iteration_callback)
        
        if(cfg.tween_completion_callback != undefined)
            t.on_complete(cfg.tween_completion_callback)
    }
    
    // gera uma "chave" pra cada par de alvo + propriedade
    // usado na próxima função pra identificar tweens "iguais"
    tween_identity_key = function(t) {
        return string(t.target) + ":" + string(t.property)
    }
    
    apply_initial_fills = function() {
        var seen = {}
        
        for (var s = 0; s < array_length(self.steps); s++) {
            var group = self.steps[s]
            
            for (var i = 0; i < array_length(group); i++) {
                var t = group[i]
                var key = self.tween_identity_key(t)
                
                if(variable_struct_exists(seen, key)) {
                    continue
                }
                
                variable_struct_set(seen, key, true)
                
                if(
                    (t.fill_mode == ANIMATION_FILL_MODES.BACKWARDS
                    || t.fill_mode == ANIMATION_FILL_MODES.BOTH)
                    && !t.relative_from
                ) {
                    t.set_value(t.play_from)
                }
            }
        }
    }
    
    find_last_tweens = function() {
        // funciona assim, cada iteração checa um novo tween na 
        // sequencia; adiciona ele em seen se ainda não estiver.
        
        // o valor da chave sempre é o tween em si, e sempre que é
        // definido um tween pra chave seu last_of_sequence vira true
        // e o last_of_sequence do tween anterior (se houver) vira false
        
        var seen = {}
        
        for (var s = 0; s < array_length(self.steps); s++) {
            var group = self.steps[s]
            
            for (var i = 0; i < array_length(group); i++) {
                var t = group[i]
                var key = self.tween_identity_key(t)
                
                if(variable_struct_exists(seen, key)) {
                    t.last_of_sequence = true
                    seen[$ key].last_of_sequence = false
                    seen[$ key] = t
                } else {
                    variable_struct_set(seen, key, t)   
                    t.last_of_sequence = true
                }
            }
        }
    }
    
    reset_all_properties = function() {
        var seen = {}
        
        for (var s = 0; s < array_length(self.steps); s++) {
            var group = self.steps[s]
            
            for (var i = 0; i < array_length(group); i++) {
                var t = group[i]
                var key = tween_identity_key(t)
                
                if(variable_struct_exists(seen, key)) {
                    continue
                }
                
                variable_struct_set(seen, key, true)
                
                t.set_value(t.base_from)
            }
        }
    }
    
    start_current_step = function() {
        var group = self.steps[self.current_step]
        
        for (var i = 0; i < array_length(group); i++) {
        	var t = group[i]
            t.start()
            self.apply_pending_config(t)
        }
    }
    
    is_current_step_finished = function() {
        var group = self.steps[self.current_step]
        
        var all_finished = true
        for (var i = 0; i < array_length(group); i++) {
            if(group[i].active) {
                all_finished = false
                break
            }
        }
        
        return all_finished
    }
    
    update = function() {
        if(!self.active || self.paused || array_length(self.steps) == 0) {
            return
        }
        
        if(!self.initialized) {
            self.apply_initial_fills()
            self.find_last_tweens()
            self.initialized = true
        }
        
        var group = self.steps[self.current_step]
        
        if(
            self.current_step == 0
            && array_any(group, function(t) { return t.pending })
        ) {
            start_current_step()
        }
        
        for (var i = 0; i < array_length(group); i++) {
        	group[i].update()
        }
        
        if(self.is_current_step_finished()) {
            self.current_step++
            
            if(self.current_step >= array_length(self.steps)) {
                if(self.completion_callback)
                    self.completion_callback()
                
                self.active = false
            } else {
                self.start_current_step()
            }
        }
    }
    
    // CHAINABLES
    from = function(value) {
        self.pending_config.from_value = value
        return self
    }
    
    iteration_relative = function() {
        self.pending_config.iteration_relative = true
        return self
    }
    
    ease = function(ease) {
        self.pending_config.easing = ease
        return self
    }
    
    fill = function(mode) {
        // só essa aplica tudo no início, pois a sequence
        // tem que ler tudo logo no primeiro update
        // (IGNORE A GAMBIARRA FEIA XOXA CAPENGA ;( )
        var data = { fill: mode, func: self.tween_foreach }
        var binded = method(data, function() {
            func(function(t) { t.fill(self.fill) })
        })
        binded()
        return self
    }
    
    delay = function(steps) {
        self.pending_config.play_delay = steps
        return self
    }
    
    direction = function(dir) {
        self.pending_config.play_direction = dir
        return self
    }
    
    loops = function(n = infinity) {
        self.pending_config.iteration_count = max(0, n)
        return self
    }
    
    on_iteration = function(callback) {
        self.pending_config.iteration_callback = callback
        return self
    }
    
    on_each_tween_complete = function(callback) {
        self.pending_config.tween_completion_callback = callback
        return self
    }
    
    // PLAYBACK
    
    pause = function() {
        self.paused = true
        self.tween_foreach(function(t) { t.pause() })
        return self
    }
    
    resume = function() {
        self.paused = false
        self.tween_foreach(function(t) { t.resume() })
        return self
    }
    
    stop = function() {
        self.paused = true
        self.initialized = false
        self.reset_all_properties()
        self.tween_foreach(function(t) { t.stop() })
        return self
    }
    
    cancel = function() {
        self.active = false
        self.tween_foreach(function(t) { t.cancel() })
        return self
    }
        
        
    tween_foreach = function(callback) {
        for (var s = 0; s < array_length(self.steps); s++) {
            var group = self.steps[s]
            for (var i = 0; i < array_length(group); i++) {
                callback(group[i])
            }
        }
    }
}

function Tween(target, property, to, duration_steps) constructor {
    
    get_value = function() {
        if(is_struct(self.target)) {
            return variable_struct_get(self.target, self.property)
        } else {
            return variable_instance_get(self.target, self.property)
        }
    }
    
    set_value = function(v) {
        //show_debug_message($"[{ptr(self)}] Valor \"{self.property}\" alterado de {variable_instance_get(self.target, self.property)} para {v}")
        
        if(is_struct(self.target))
            variable_struct_set(self.target, self.property, v)
        else
            variable_instance_set(self.target, self.property, v)
    }
    
    self.target = target
    self.property = property
    
    self.play_from = self.get_value()
    relative_from = true
    base_from = self.play_from // definido na construção do objeto
    relative_on_iteration = false
    
    self.to = to
    
    self.duration = max(1, duration_steps)
    
    pending = false
    paused = false
    
    progress = 0
    active = true
    reversing = false
    in_sequence = false
    last_of_sequence = false
    
    fill_mode = ANIMATION_FILL_MODES.FORWARDS
    easing = ease_linear
    play_delay = 0
    play_direction = ANIMATION_DIRECTIONS.NORMAL
    iteration_count = 0
    iteration_callback = undefined
    competion_callback = undefined
    
    base_iteration_count = 0 // usado ao reiniciar a animação
    
    // CHAINABLES
    from = function(value) {
        self.play_from = value
        self.relative_from = false
        return self
    }
    
    iteration_relative = function() {
        self.relative_on_iteration = true
        return self
    }
    
    ease = function(ease) {
        if(is_numeric(ease)) {
            switch(ease) {
                case ANIMATION_EASINGS.LINEAR: self.easing = ease_linear; break;
                case ANIMATION_EASINGS.IN_QUAD: self.easing = ease_in_quad; break;
                case ANIMATION_EASINGS.OUT_QUAD: self.easing = ease_out_quad; break;
                case ANIMATION_EASINGS.IN_OUT_QUAD: self.easing = ease_in_out_quad; break;
                case ANIMATION_EASINGS.IN_CUBIC: self.easing = ease_in_cubic; break;
                case ANIMATION_EASINGS.OUT_CUBIC: self.easing = ease_out_cubic; break;
                case ANIMATION_EASINGS.IN_OUT_CUBIC: self.easing = ease_in_out_cubic; break;
                case ANIMATION_EASINGS.IN_QUART: self.easing = ease_in_quart; break;
                case ANIMATION_EASINGS.OUT_QUART: self.easing = ease_out_quart; break;
                case ANIMATION_EASINGS.IN_OUT_QUART: self.easing = ease_in_out_quart; break;
                case ANIMATION_EASINGS.IN_QUINT: self.easing = ease_in_quint; break;
                case ANIMATION_EASINGS.OUT_QUINT: self.easing = ease_out_quint; break;
                case ANIMATION_EASINGS.IN_OUT_QUINT: self.easing = ease_in_out_quint; break;
                case ANIMATION_EASINGS.IN_SINE: self.easing = ease_in_sine; break;
                case ANIMATION_EASINGS.OUT_SINE: self.easing = ease_out_sine; break;
                case ANIMATION_EASINGS.IN_OUT_SINE: self.easing = ease_in_out_sine; break;
                case ANIMATION_EASINGS.IN_EXPO: self.easing = ease_in_expo; break;
                case ANIMATION_EASINGS.OUT_EXPO: self.easing = ease_out_expo; break;
                case ANIMATION_EASINGS.IN_OUT_EXPO: self.easing = ease_in_out_expo; break;
                case ANIMATION_EASINGS.IN_CIRC: self.easing = ease_in_circ; break;
                case ANIMATION_EASINGS.OUT_CIRC: self.easing = ease_out_circ; break;
                case ANIMATION_EASINGS.IN_OUT_CIRC: self.easing = ease_in_out_circ; break;
                case ANIMATION_EASINGS.IN_BACK: self.easing = ease_in_back; break;
                case ANIMATION_EASINGS.OUT_BACK: self.easing = ease_out_back; break;
                case ANIMATION_EASINGS.IN_OUT_BACK: self.easing = ease_in_out_back; break;
                case ANIMATION_EASINGS.IN_ELASTIC: self.easing = ease_in_elastic; break;
                case ANIMATION_EASINGS.OUT_ELASTIC: self.easing = ease_out_elastic; break;
                case ANIMATION_EASINGS.IN_OUT_ELASTIC: self.easing = ease_in_out_elastic; break;
                case ANIMATION_EASINGS.IN_BOUNCE: self.easing = ease_in_bounce; break;
                case ANIMATION_EASINGS.OUT_BOUNCE: self.easing = ease_out_bounce; break;
                case ANIMATION_EASINGS.IN_OUT_BOUNCE: self.easing = ease_in_out_bounce; break;
                default: self.easing = ease_linear; break;
            }
        } else if(is_method(ease)) {
            self.easing = ease
        }
        
        return self
    }
    
    fill = function(mode) {
        self.fill_mode = mode
        
        if(
            !self.in_sequence
            && (mode == ANIMATION_FILL_MODES.BACKWARDS || mode == ANIMATION_FILL_MODES.BOTH)
        ) {
            self.set_value(self.play_from)
        }
        
        return self
    }
    
    delay = function(steps) {
        self.play_delay = steps
        return self
    }
    
    direction = function(dir) {
        self.play_direction = dir
        
        if(
            dir == ANIMATION_DIRECTIONS.REVERSE
            || dir == ANIMATION_DIRECTIONS.ALTERNATE_REVERSE
        ) {
            self.progress = self.duration
            self.reversing = true
        }
        
        return self
    }
    
    loops = function(n = infinity) {
        self.iteration_count = max(0, n)
        return self
    }
    
    on_iteration = function(callback) {
        self.iteration_callback = callback
        return self
    }
    
    on_complete = function(callback) {
        self.competion_callback = callback
        return self
    }
    
    // UTILITÁRIAS DE CONTROLE DO PLAYBACK
    pause = function() {
        self.paused = true
    }
    
    resume = function() {
        self.paused = false
    }
    
    stop = function() {
        self.paused = true
        
        if(!self.in_sequence) {
            self.set_value(self.base_from)
            self.fill(self.fill_mode)
        }
        
        self.direction(self.play_direction)  
    }
    
    cancel = function() {
        self.active = false
    }
    
    start = function() { 
        self.pending = false
        
        if(
            self.relative_from
            && self.fill_mode != ANIMATION_FILL_MODES.NONE
        ) {
            self.play_from = self.get_value()
        }
    }
    
    // UPDATE UPDATE UPDATE UPDATE
    update = function() {
        if(self.pending || self.paused || !self.active) {
            return
        }
        
        self.play_delay = clamp(self.play_delay - 1, 0, infinity)
        
        if(self.play_delay > 0) {
            return
        }
        
        var delta = self.to - self.play_from
        var progress_percent = 0
        
        if(self.reversing) {
            self.progress = clamp(self.progress - 1, 0, self.duration)
            progress_percent = 1 - (self.progress / self.duration)
            self.set_value(self.to - delta * self.easing(progress_percent))
        } else {
            self.progress = clamp(self.progress + 1, 0, self.duration)
            progress_percent = self.progress / self.duration
            self.set_value(self.play_from + delta * self.easing(progress_percent))
        }
        
        // caso a animação tenha acabado
        if(progress_percent == 1) {
            var finished = self.iteration_count == 0
            
            if(!finished) {
                switch(self.play_direction) {
                    case ANIMATION_DIRECTIONS.NORMAL: 
                        self.progress = 0
                        break
                    case ANIMATION_DIRECTIONS.REVERSE:
                        self.progress = self.duration
                        break
                    case ANIMATION_DIRECTIONS.ALTERNATE:
                    case ANIMATION_DIRECTIONS.ALTERNATE_REVERSE:
                        if(self.reversing) {
                            self.progress = 0
                        } else {
                        	self.progress = self.duration
                        }
                        
                        reversing = !reversing
                        break
                }
                
                if(self.relative_on_iteration) {
                    self.play_from = self.to
                    self.to = self.get_value() + delta
                }
                
                if(self.iteration_callback) {
                    self.iteration_callback()
                }
                
                if(self.iteration_count != infinity) {
                    self.iteration_count--
                }
            }
            
            if(finished) {
                // resetando o valor final caso não seja FORWARDS ou BOTH
                // (ficou bem feinho esse if)
                if(
                    self.fill_mode == ANIMATION_FILL_MODES.BACKWARDS
                    || self.fill_mode == ANIMATION_FILL_MODES.NONE
                ) {
                    if(self.in_sequence) {
                        if(self.last_of_sequence) {
                            self.set_value(self.base_from)
                        }
                    } else {
                        self.set_value(self.play_from)
                    }
                }
                
                if(self.competion_callback) {
                    self.competion_callback()
                }
                
                self.active = false
            }
        }
    }
    
}
