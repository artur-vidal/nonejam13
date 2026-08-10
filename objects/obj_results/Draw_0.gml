draw_slot(sentence1, false, .7, "\"", "\"")
if(sentence2.value != "") {
    draw_slot(sentence2, false, .7, "\"", "\"")
}

draw_sprite(spr_pessoas, 0, x + people.x - 20, people.y - 2)
draw_slot(people_reach)
draw_set_colour(people_color.compute())
draw_slot(people, false)
draw_set_colour(c_white)
draw_slot(people_indicator)

draw_slot(conf_indicator, true, 1, "[c_verde]Confiança ", "[/c}")
draw_slot(viol_indicator, true, 1, "[c_verm]Violência ", "[/c}")
draw_slot(serie_indicator, true, 1, "[c_azul]Seriedade ", "[/c}")