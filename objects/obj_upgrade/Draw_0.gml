var icon_w = sprite_get_width(spr_icone_upgrade)

draw_sprite(spr_icone_upgrade, upgrade_id, x, y)
draw_sprite(spr_grade_upgrade, 0, x + icon_w / 2, y)
for (var i = 0; i < get_points(); i++) {
	draw_sprite(spr_ponto_upgrade, 0, x + icon_w / 2 + upgrade_point_x[i], y)
}


var button_w = sprite_get_width(spr_botao_upgrade)
var button_h = sprite_get_height(spr_botao_upgrade)
draw_sprite(
    spr_botao_upgrade, 
    (hovering_upgrade_green_button() ? 0 : 2),
    x + 100 + button_gap,
    y - button_h / 2
)

draw_sprite(
    spr_botao_upgrade, 
    (hovering_upgrade_red_button() ? 1 : 3),
    x + 100 + button_gap,
    y + button_h / 2
)