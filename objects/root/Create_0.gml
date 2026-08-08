events = new EventBus()

tween_mgr = new TweenManager()
shader_mgr = new ShaderManager()

particle_system = singleton(obj_particles)
cursor = singleton(obj_cursor)

application_surface_draw_enable(false)
show_debug_overlay(false)
audio_group_load(audiogroup_music)

day_ambiences = [
    msc_ambience_1,
    msc_ambience_2,
    msc_ambience_3,
    msc_ambience_4,
    msc_ambience_5,
    msc_ambience_6,
]

state = {
    // status gerais
    people: 10000,
    
    violence: 20,
    confidence: 60,
    seriousness: 80,
    
    day: 1,
    
    ending: function() {
        if(self.confidence < 10 || self.people < 1000000) {
            return 3
        } else if (self.violence > 80) {
            return 1
        } else if (self.seriousness < 20) {
            return 2
        } else {
            return 0
        }
    },
    
    // Upgrades
    upgrade_points: 0,
    upgrade_levels: [
        0, // Upgrades.CARTEIROS
        0, // Upgrades.TERMOS
        0, // Upgrades.BESTEIROL
        0, // Upgrades.APELATIVO
        0, // Upgrades.VOCABULARIO
        0 // Upgrades.BOAIMAGEM
    ],
    get_upgrade_effect: function(upgrade_id) {
        var up_level = self.upgrade_levels[upgrade_id]
        var upgrade = get_upgrades(upgrade_id)
        return (up_level > 1) ? upgrade.effect[up_level - 1] : upgrade.zero
    }
}

goto_day = function(num) {
    ROOT.state.day = num
    room_goto(rm_day)
    
    audio_stop_all()
    audio_play_sound(snd_brass, 0, 0)
    audio_play_sound(day_ambiences[num - 1], 1, 1)
    
    instance_create_depth(0, 0, 0, obj_dawn_to_day)
}

// código de init do jogo
randomise()
set_cursor(0)
window_set_cursor(cr_none)