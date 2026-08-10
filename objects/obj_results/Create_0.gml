results = []

sentence1 = {
    x: -300,
    y: 20,
    alpha: 1,
    value: ""
}

sentence2 = {
    x: 400,
    y: 40,
    alpha: 1,
    value: ""
}

people_reach = {
    x: -200,
    y: 60,
    alpha: 1,
    value: "Cidadãos persuadidos:"
}

people = {
    x: -200,
    y: 76,
    alpha: 1,
    value: ROOT.state.people
}

people_indicator = {
    x: -200,
    y: 96,
    alpha: 1,
    value: 0
}

conf_indicator = {
    x: -200,
    y: 100,
    alpha: 1,
    value: 0
}

viol_indicator = {
    x: -200,
    y: 114,
    alpha: 1,
    value: 0
}

serie_indicator = {
    x: -200,
    y: 132,
    alpha: 1,
    value: 0
}

rising = false
rising_c = 0

people_color = new RGB()

sequence = undefined

draw_slot = function(_struct, _op = true, scale = 1, _prefix = "", _suffix = "") {
    var op_string = ""
    if(is_real(_struct.value) && _op) {
        op_string = (_struct.value < 0 ? "-" : "+")
    }
    var total_string = _prefix + (is_real(_struct.value) ? op_string + string_format_dots(abs(round(_struct.value))) : _struct.value) + _suffix
    
    var scribble_object = scribble(total_string)
        .starting_format("fnt_paper", c_white)
        .blend(draw_get_colour(), _struct.alpha)
        .transform(scale, scale, 0)
        .wrap(280)
        .line_spacing(12)
    
    scribble_object.draw(x + _struct.x, y + _struct.y)
}

whoosh = function() { audio_play_sound(snd_whoosh, 0, 0) }

/// @param {Array<Struct.NewsResult>} _results
init = function(_sentences, _additional_people, _raw_results) {
    results = _raw_results
    
    var conf = 0
    var viol = 0
    var serie = 0
    for (var i = 0; i < array_length(_raw_results); i++) {
    	var res = _raw_results[i]
        conf += res.others.confidence_increase
        viol += res.others.violence_increase
        serie += res.others.seriousness_increase
    }
    
    sentence1.value = _sentences[0]
    if(array_length(_sentences) > 1) sentence2.value = _sentences[1]
    
    people_indicator.value = _additional_people
    conf_indicator.value = round(conf)
    viol_indicator.value = round(viol)
    serie_indicator.value = round(serie)
    
    create_tween(sentence1, "x", 10, seconds(3))
        .ease(ANIMATION_EASINGS.OUT_BACK)
    
    create_tween(sentence2, "x", 128, seconds(3))
        .delay(seconds(1))
        .ease(ANIMATION_EASINGS.OUT_BACK)
    
    sequence = tween_sequence()
        .next(
            create_tween(people_reach, "x", 12, seconds(1))
                .delay(seconds(3))
                .ease(ANIMATION_EASINGS.OUT_CUBIC)
        )
        .parallel(
            create_tween(people, "x", 32, seconds(1))
                .delay(seconds(3.5))
                .ease(ANIMATION_EASINGS.OUT_CUBIC)
        )
        .parallel(
            create_tween(people_indicator, "x", 44, seconds(1))
                .delay(seconds(4))
                .ease(ANIMATION_EASINGS.OUT_CUBIC)
                .on_complete(function() { audio_play_sound(snd_people_riser, 0, 0) })
        )
        .next(
            create_tween(people_indicator, "y", 108, ms(700))
                .ease(ANIMATION_EASINGS.OUT_CUBIC)
        )
        .next(
            create_tween(people_indicator, "y", 64, ms(200))
                .ease(ANIMATION_EASINGS.IN_CUBIC)
                .on_complete(function() {
                    audio_stop_sound(snd_people_riser)
                    people_indicator.alpha = 0
                    rising = true
                })
        )
        .next(
            create_tween(people, "value", people.value + _additional_people, ms(4000))
                .ease(ANIMATION_EASINGS.OUT_CIRC)
                .on_complete(function() {
                    rising = false
                    audio_play_sound(snd_blink, 0, 0)
                    create_tween(people_color, "r", 255, seconds(2))
                        .from(160)
                    
                    create_tween(people_color, "b", 255, seconds(2))
                        .from(160)
                })
        )
        .next(
            create_tween(conf_indicator, "x", 24, ms(1500))
                .ease(ANIMATION_EASINGS.OUT_CUBIC)
        )
        .next(
            create_tween(viol_indicator, "x", 24, ms(1500))
                .ease(ANIMATION_EASINGS.OUT_CUBIC)
        )
        .next(
            create_tween(serie_indicator, "x", 24, ms(1500))
                .ease(ANIMATION_EASINGS.OUT_CUBIC)
        )
        .fill(ANIMATION_FILL_MODES.BOTH)
}