shader_mgr.set_saturation((ROOT.state.day < 7 ? 1 - (ROOT.state.day / 6 / 3) : 0))
shader_mgr.apply()
draw_surface(application_surface, 0, 0)
shader_mgr.reset()