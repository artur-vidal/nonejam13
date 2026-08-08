audio_play_sound(snd_coffee, 0, 0)
create_tween(id, "image_xscale", 1, seconds(.3))
    .from(1.4)
    .ease(ANIMATION_EASINGS.IN_OUT_BACK)

create_tween(id, "image_yscale", 1, seconds(.3))
    .from(0.7)
    .ease(ANIMATION_EASINGS.IN_OUT_BACK)