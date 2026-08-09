depth = -100

enabled = true

intro = true
alpha = 0

logo_y = {
    mentes: -200,
    de: -200,
    papel: -200,
}

logo_y_target = 40

to_menu = function() {
    room_goto(rm_menu)
    
    alpha = 1
    intro = false
    
    audio_play_sound(msc_main_menu, 0, 1)
    audio_sound_gain(msc_main_menu, 0, 0)
    audio_sound_gain(msc_main_menu, 1, 3000)
    
    create_tween(id, "alpha", 0, seconds(1.5))
    
    create_tween(logo_y, "mentes", logo_y_target, seconds(2))
        .delay(seconds(1))
        .ease(ANIMATION_EASINGS.OUT_CIRC)
    create_tween(logo_y, "de", logo_y_target, seconds(2))
        .delay(seconds(1.5))
        .ease(ANIMATION_EASINGS.OUT_CIRC)
    create_tween(logo_y, "papel", logo_y_target, seconds(2))
        .delay(seconds(2))
        .ease(ANIMATION_EASINGS.OUT_CIRC)
}

tween_sequence()
    .next(
        create_tween(id, "alpha", 1, seconds(1))
    )
    .next(
        create_tween(id, "alpha", 0, seconds(1))
            .delay(seconds(4))
    )
    .on_complete(to_menu)



to_game = function() {
    if(!enabled) return;
    
    audio_sound_gain(msc_main_menu, 0, 1000)
    
    create_tween(id, "alpha", 1, seconds(4))
        .on_complete(function() {
            audio_stop_all()
            instance_destroy(id)
            room_goto(rm_cutscene_intro)
            set_cursor(0)
            ROOT.state.played_game = true
        })
    enabled = false
}

to_credits = function() {
    if(!enabled) return;
        
    audio_stop_all()
    room_goto(rm_cutscene_outro)
    set_cursor(0)
    instance_destroy(id)
}

quit_game = function() {
    if(!enabled) return;
    
    audio_sound_gain(msc_main_menu, 0, 1000)
    
    create_tween(id, "alpha", 1, seconds(3))
        .on_complete(function() {
            game_end()
        })
    
    enabled = false
}


ROOT.events.connect("start-game", to_game)
ROOT.events.connect("credits", to_credits)
ROOT.events.connect("quit-game", quit_game)