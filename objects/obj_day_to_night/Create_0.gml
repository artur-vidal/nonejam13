depth = -1000

alpha = 0
show_text = false

show_on = function() { show_text = true; GAME.to_night(); }
destroy = function() { instance_destroy(id); GAME.resume(); }

tween_sequence()
    .next(
        create_tween(id, "alpha", 1, seconds(2))
            .ease(ANIMATION_EASINGS.OUT_CUBIC)
            .on_complete(show_on)
    )
    .next(
        create_tween(id, "alpha", 0, seconds(3))
            .ease(ANIMATION_EASINGS.OUT_CUBIC)
            .delay(seconds(2))
            .on_complete(destroy)
    )