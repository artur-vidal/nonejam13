var _x = 0
var _y = 0

if(shake_dur > 0) {
    _x = irandom_range(-3, 3)
    _y = irandom_range(-3, 3)
}

shake_dur--

shader_mgr.set_saturation((ROOT.state.day < 7 ? 1 - (ROOT.state.day / 6 / 2) : 0))
shader_mgr.apply()
draw_surface(application_surface, _x, _y)
shader_mgr.reset()