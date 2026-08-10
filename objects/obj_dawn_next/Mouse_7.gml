if(!active) exit;

ROOT.events.emit("dawn-next-stage")
audio_play_sound(snd_button_click, 0, 0)
image_index = 0
unhover_scale()
set_cursor(0)
active = false