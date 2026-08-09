if((once && clicked) || !singleton(obj_menu).enabled) exit
    
ROOT.events.emit(event)
audio_play_sound(snd_button_click, 0, 0)