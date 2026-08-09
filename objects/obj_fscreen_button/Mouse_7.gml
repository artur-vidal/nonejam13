if(blocked()) exit;

// eu acho que isso ta logicamente invertido mas funciona :)
if(toggle) {
    window_set_fullscreen(false)
    surface_resize(application_surface, 1280, 720)
    toggle = false
} else {
    window_set_fullscreen(true)
    surface_resize(application_surface, display_get_width(), display_get_height())
    toggle = true
}

audio_play_sound(snd_button_click, 0, 0)