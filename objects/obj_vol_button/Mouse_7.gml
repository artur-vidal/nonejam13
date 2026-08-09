if(blocked()) exit;

// eu acho que isso ta logicamente invertido mas funciona :)
if(toggle) {
    audio_master_gain(0.5)
    toggle = false
} else {
    audio_master_gain(0)
    toggle = true
}

audio_play_sound(snd_button_click, 0, 0)