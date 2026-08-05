function create_paper(term, x, y, sound = true) {
    var inst = instance_create_depth(x, y, 0, obj_paper)
    inst.term = term
    
    if(sound) {
        audio_play_sound(choose(snd_paper_rip_1, snd_paper_rip_2), 0, 0)
    }
}

function create_newspaper(index) {
    var news = get_newspaper(index)
    var inst = instance_create_depth(0, 0, 0, obj_newspaper)
    inst.init(news)
}