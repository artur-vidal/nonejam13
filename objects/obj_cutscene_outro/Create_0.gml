scene_f = ROOT.state.ending()

switch(scene_f) {
    case 0: audio_play_sound(msc_angistania_wins, 0, 1); break;
    case 1: audio_play_sound(msc_taquistao_wins, 0, 1); break;
    case 2: audio_play_sound(msc_abacate_wins, 0, 1); break;
    case 3: audio_play_sound(msc_you_lost, 0, 1); break;
}

alarm[0] = 120;

draw_alpha_f = 0;
draw_alpha_s = .025;
can_draw = 0;

can_skip_f = 0;

text_speed_f = 0;
text_att_f = 0;

c_verm_f = make_colour_rgb(148, 36, 56);
c_azul_f = make_colour_rgb(32, 85, 104);
c_verde_f = make_colour_rgb(102, 136, 34);
c_cinza_f = make_colour_rgb(109, 130, 124);
scribble_color_set("c_verm", c_verm_f);
scribble_color_set("c_azul", c_azul_f);
scribble_color_set("c_verde", c_verde_f);
scribble_color_set("c_cinza", c_cinza_f);


text_f =
[
"[c_verm]Data[/c]: 07 de Fevereiro, 1984.\nA [c_verm]Grande Nação de Angistânia[/c]\nse tornou a maior potência mundial!\nAdorada seja [c_verm]Angistânia[/c]!",
"[c_azul]Data[/c]: 07 de Fevereiro, 1984.\nA [c_azul]Grande Nação de Angistânia[/c]\nfoi bombardeada pelo [c_azul]Taquistão[/c]!\nPaz para [c_azul]Angistânia[/c]!",
"[c_verde]Data[/c]: 07 de Fevereiro, 1984.\nA [c_verde]Grande Nação de Angistânia[/c]\nfoi anexada pela [c_verde]República dos Abacates[/c]!\nFuturo para [c_verde]Angistânia[/c] e o Mundo!",
"[c_cinza]Data[/c]: 07 de Fevereiro 1984.\nA [c_cinza]Grande Nação de Angistânia[/c] não é mais\nlevada a sério!\nVocê perdeu seu emprego[c_cinza]...[/c] Talvez a vida[c_cinza]...[/c]",

"Obrigado por jogar!\n\n[c_cinza]Artes[/c]: Azeddo   [c_cinza]Programação[/c]: Tuta\n\nJogo criado para [c_cinza]NoneJam 13[/c]."
];
