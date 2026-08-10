if(window_get_fullscreen()) {
    window_set_fullscreen(false)
    surface_resize(application_surface, 1280, 720)
} else {
    window_set_fullscreen(true)
    surface_resize(application_surface, display_get_width(), display_get_height())
}

audio_play_sound(snd_button_click, 0, 0)