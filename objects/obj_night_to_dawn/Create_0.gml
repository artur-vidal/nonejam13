depth = -1000

var i = 0
with(obj_paper) {
    var destroy = function() {
        instance_destroy(id)
    }
    
    create_tween(id, "x", -50, seconds(1.5))
        .delay(ms(20 * (i++)))
        .ease(ANIMATION_EASINGS.IN_BACK)
        .on_complete(destroy)
}

with(obj_sentence) {
    create_tween(id, "x", room_width + 20, seconds(1))
        .ease(ANIMATION_EASINGS.OUT_CIRC)
}

set_cursor(0)

var complete = function() { GAME.to_dawn(); instance_destroy(id); }

alpha = 0
create_tween(id, "alpha", 1, seconds(2))
    .delay(seconds(2))
    .ease(ANIMATION_EASINGS.OUT_CUBIC)
    .on_complete(complete)