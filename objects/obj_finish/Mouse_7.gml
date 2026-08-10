if(!GAME.playing || !active) exit;
ROOT.events.emit("next-stage")
image_index = 0
set_cursor(0)
unhover_scale()
audio_play_sound(snd_button_click, 0, 0)