scene = 0;
scene_step = 0;

draw_alarm = 120;
draw_alpha = 0;
draw_alpha_speed = .025;

text_speed = 1;
text_att = 0;

can_skip = 0;

c_preto = make_colour_rgb(26, 22, 29);
c_verm = make_colour_rgb(148, 36, 56);
c_azul = make_colour_rgb(32, 85, 104);
c_verde_f = make_colour_rgb(102, 136, 34);
c_cinza_f = make_colour_rgb(109, 130, 124);

scribble_color_set("c_preto", c_preto);
scribble_color_set("c_verm", c_verm);
scribble_color_set("c_azul", c_azul);
scribble_color_set("c_verde", c_verde_f);
scribble_color_set("c_cinza", c_cinza_f);
text = 
[
". . .", "[c_azul]Data[/c]: 03 de Novembro, 1983.", "[c_azul]Anúncio diário[/c]: As relações globais estão\nfragilizadas!\nPerigosos conflitos estão emergindo.", "[c_verm]A Grande Nação[/c] está trabalhando para\ngarantir sua posição de liderança.\nAdorada seja [c_verm]Angistânia[/c]!",
"[c_azul]Data[/c]: 31 de Dezembro, 1983.", "[c_azul]Anúncio diário[/c]: Graças ao Ditador Gianno Angus,\no Governo da [c_verm]República Autoritária da Angistânia[/c]\nabre novas vagas, destinadas à Secretaria da\nVeracidade Nacional.", "Concorra e colabore para a glória\nda [c_verm]Grande Nação[/c].\nAdorada seja [c_verm]Angistânia[/c]!",
"[c_azul]Data[/c]: 01 de Fevereiro, 1984.", "[c_azul]Anúncio diário[/c]: Parabéns! Você foi selecionado\npara a equipe da Secretaria de Veracidade Nacional.", "Seu trabalho é reescrever notícias comuns,\na fim de beneficiar a soberania da [c_verm]Grande Nação[/c]!", "[c_azul]Mas lembre-se[/c]: Seja convincente, o governo apenas\ngarante sua saúde e segurança\nenquanto trouxer resultados...\nAdorada seja [c_verm]Angistânia[/c]!"
]

if(skip) {
    alarm[3] = 1
}