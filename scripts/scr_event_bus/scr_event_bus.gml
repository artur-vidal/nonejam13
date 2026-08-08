function EventBus() constructor {
    events = {}
    
    connect = function(event, callback) {
        if(!struct_exists(self.events, event))
            self.events[$ event] = []
        
        array_push(self.events[$ event], callback)
    }
    
    emit = function(event) {
        var arguments = []
        for (var i = 1; i < argument_count; i++) {
            array_push(arguments, argument[i])
        }
        
        if(!struct_exists(self.events, event)) {
            show_debug_message($"Evento '{event}' não registrado!")
            return
        }
        
        var methods = self.events[$ event]
        for (var i = 0; i < array_length(methods); i++) {
        	method_call(methods[i], arguments)
        }
    }
    
    disconnect = function(event, callback) {
        if(!struct_exists(self.events, event))
            return
        
        var methods = self.events[$ event]
        for (var i = 0; i < array_length(methods); i++) {
        	if(methods[i] == callback) {
                array_delete(methods, i, 1)
                return
            }
        }
    }
}