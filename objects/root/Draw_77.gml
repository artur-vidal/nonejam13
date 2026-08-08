shader_mgr.set_saturation(max(0.5, 1 - ROOT.state.day / 6))
shader_mgr.apply()
draw_surface(application_surface, 0, 0)
shader_mgr.reset()