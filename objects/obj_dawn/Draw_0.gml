var prev_font = draw_get_font()
draw_set_font(fnt_paper)
draw_text(10, 10, $"Pessoas alcançadas: {ROOT.state.people}")
draw_set_font(prev_font)