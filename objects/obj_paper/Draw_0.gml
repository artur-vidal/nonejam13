var scribble_object = scribble(content)
    .starting_format("fnt_paper", #07070E)
    .align(fa_center, fa_middle)
    .padding(padding, padding, padding, padding)
    .transform(scale, scale, angle)

width = scribble_object.get_width()
height = scribble_object.get_height()

sprite.set_xscale(scale * (width / sprite_get_width(spr_paper)))
sprite.set_yscale(scale * (height / sprite_get_height(spr_paper)))
sprite.set_angle(angle)

sprite.draw_shadow(x + width / 2, y + height / 2 + 12, 0.025)
sprite.draw(x + width / 2, y + height / 2)
scribble_object.draw(x + width / 2, y + height / 4 + 4)