depth = -550
active = false
tween = undefined
alpha = 0
oscillate = false

surf = surface_create(sprite_width, sprite_height)

alpha_animation = function() {
    if(tween) {
        tween.cancel()
    }
    
    tween = tween_sequence()
        .next(
            create_tween(id, "alpha", 0.4, 1)
                .delay(ms(1200))
        )
        .next(
            create_tween(id, "alpha", 0, 1)
                .delay(ms(150))
        )
        .next(
            create_tween(id, "alpha", 0.7, 1)
                .delay(ms(150))
        )
        .next(
            create_tween(id, "alpha", 0, 1)
                .delay(ms(150))
        )
        .next(
            create_tween(id, "alpha", 1, 1)
                .delay(ms(75))
        )
        .on_complete(function() {
            oscillate = true
        })
}