depth = -1000

alpha = 1

destroy = function() {
    GAME.resume()
    ROOT.events.emit("next-news")
    instance_destroy(id)
}

create_tween(id, "alpha", 0, seconds(3))
    .delay(seconds(2))
    .ease(ANIMATION_EASINGS.OUT_CUBIC)
    .on_complete(destroy)