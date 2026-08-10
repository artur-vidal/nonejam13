dialogues = [ // por dia
    [
        "Bom dia, novo empregado.",
        "Me chamo Olivia. Sou eu quem vai trazer-lhe as notícias.",
        "Mas antes, irei explicar seu ciclo de trabalho.",
        "...",
        "...Ah! Não te avisaram o que precisa fazer?",
        "Não se preocupe, não é nada demais. Você apenas precisa criar novas notícias.",
        "Mas ouça bem. Não gosto de repetir.",
        "Com as notícias na mesa, demarcamos algumas palavras que você pode usar.",
        "Retire [c_azul]todas as palavras[/c] marcadas, e decida à direita se vai utilizá-las ou não.",
        "Você precisa [c_azul]encher a caixa verde[/c] antes de terminar seu turno diurno.",
        "E caso mude alguma decisão, o botão azul irá lhe auxiliar.",
        "...",
        "Durante a noite.",
        "Você apenas precisa montar novas notícias usando quantas palavras quiser.",
        "Não é necessário utilizar de todas elas. Mas recomendo utilizá-las ao máximo.",
        "E se quiser, podemos te oferecer algumas regalias antes do dia seguinte.",
        "Isso é tudo. No fim da semana, seu trabalho será revisado.",
        "Você pode observar seu desempenho na [c_azul]tela retrátil à sua direita.[/c]",
        "Ah, e aqui estão os papéis. Com licença."
    ],
    [
        "Bom dia, novo empregado.",
        "Espero que esteja se ambientando bem.",
        "Trouxe as notícias do dia...",
        "...",
        "Refletindo agora, acho que não esclareci muito bem as consequências do que propagamos.",
        "Se não quiser ser demitido, ouça bem.",
        "O objetivo de nossa [c_verm]Grande Nação[/c] é alcançar o poder por meio da informação.",
        "Para isso, um balanço é necessário.",
        "Civis não leriam um jornal que só fala de economia ou investimentos.",
        "Mas os governantes, que também precisamos agradar, não leriam as notícias sobre romances alheios.",
        "E além disso, assuntos polêmicos sempre vão desagradar alguém. E um povo enchido de ódio é incontrolável.",
        "E temos que fazer isso enquanto engrandecemos minimamente as personalidades de nossa nação.",
        "Caso contrário, os superiores podem ficar insatisfeitos.",
        "Não é tanta coisa.",
        "Até o fim da semana, o Alto Escalão definiu uma meta.",
        "15.000.000 de pessoas.",
        "Não se preocupe, nosso alcance é grande. Quanto mais pessoas lêem, mais outras pessoas vão ler. [c_azul]Como dominós.[/c]",
        "Agora que entendeu melhor como as coisas funcionam... As notícias do dia.",
        "Com licença. E boa sorte."
    ],
    [
        "Bom dia, empregado.",
        "Estava lendo as notícias... [c_verm]Lakira[/c] e [c_azul]Heraldo[/c] são um lindo casal, não acha?",
        "Civis comuns costumam preferir assuntos mais leves. Mas não exagere.",
        "Aqui, as notícias do dia.",
    ],
    [
        "Bom dia, empregado.",
        "Esses cantores deveriam tomar mais cuidado na televisão.",
        "Aqueles taquistãos..! São [c_verm]violentos[/c] por natureza.",
        "Cuidado com o teor das notícias, empregado. Ao agradar muito um grupo você desagrada outro.",
        "Aliás, nosso departamento está sendo mais reconhecido.",
        "[c_azul]Essa noite, você terá de montar uma notícia a mais.[/c]",
        "Aqui, as notícias do dia."
    ],
    [
        "Bom dia, colega.",
        "A [c_verde]República dos Abacates...[/c] Parece que vêem o mundo de maneira diferente.",
        "Nesses tempos, paz é apenas uma ilusão.",
        "Nossa secretaria é bem séria, empregado. [c_verm]A realidade é dura.[/c]",
        "Aqui, as notícias do dia."
    ],
    [
        "Bom dia, colega.",
        "Finalmente, parece que os taquistães vão desistir.",
        "Eles são muito poderosos. Sem toda essa pressão acima deles, nosso povo estaria em perigo.",
        "...",
        "Não conte para ninguém que eu falei isso.",
        "Enfim, espero que tenha tido bons resultados.",
        "Amanhã acontecerá uma grande conferência entre as nações. E nossos superiores fazem parte dela.",
        "Se tudo ir bem, manteremos nossos empregos.",
        "Aqui estão as notícias do dia. [c_verm]Adorada seja Angistânia,[/c] colega."
    ]
]

state = "knocking"
knocked = false

secretary_alpha = 0
sound_cd = 0

talking_cd = seconds(1)
text_speed = 0.5

text_pos = 0
d_index = 0

text_area = {
    x1: 12,
    y1: 12,
    x2: 114,
    y2: 66
}

day_dialogue = function() {
    return dialogues[ROOT.state.day - 1]
}

current_dialogue = function() {
    return day_dialogue()[d_index]
}

door_knock = function() {
    knocked = true
}

open_door = function() {
    state = "talking"
    secretary_alpha = 0
    set_cursor(0)
    audio_stop_sound(snd_knock)
    audio_play_sound(snd_door_open, 0, 0)
    ROOT.events.emit("shake-screen", ms(150))
}

next = function() {
    if(ended()) {
        text_pos = 0
        d_index++
    } else {
        text_pos = string_length(current_dialogue()) - 1
    }
    
    if (d_index >= array_length(day_dialogue())) {
        finish()
    }
}

ended = function() {
    return text_pos == string_length(current_dialogue())
}

finish = function() {
    state = "talked"
    audio_play_sound(snd_door_close, 0, 0)
    ROOT.events.emit("shake-screen", ms(500))
    ROOT.events.emit("next-news")
}

ROOT.events.connect("door-knock", door_knock)