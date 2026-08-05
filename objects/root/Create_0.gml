events = new EventBus()

tween_mgr = new TweenManager()
shader_mgr = new ShaderManager()

particle_system = singleton(obj_particles)
cursor = singleton(obj_cursor)

application_surface_draw_enable(false)
show_debug_overlay(true)

state = {
    // status gerais
    violence: 20,
    confidence: 60,
    seriousness: 80,
    
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
        var upgrade = get_Upgrades(upgrade_id)
        return (up_level > 1) ? upgrade.effect[up_level - 1] : upgrade.zero
    }
}

// código de init do jogo
randomise()
set_cursor(0)
window_set_cursor(cr_none)