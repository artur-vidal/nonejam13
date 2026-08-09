dialogues= [ // por dia
    [
        "Bom dia, novo empregado.",
        "Me chamo Olivia. Sou eu quem vai trazer-lhe as notícias.",
        "Mas antes, irei explicar seu ciclo de trabalho.",
        "...",
        "...Ah! Não te avisaram o que precisa fazer?",
        "Não se preocupe, não é nada demais. Você apenas precisa criar novas notícias.",
        "Com as notícias na mesa, demarcamos algumas palavras que você pode retirar.",
        "Retire [c_azul]todas as palavras[/c], e decida à direita se vai utilizá-las ou não.",
        "Você precisa [c_azul]encher a caixa verde[/c] antes de terminar seu turno diurno.",
        "E caso decida incorretamente, o botão azul irá lhe auxiliar.",
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
        "Sabe, que bom que temos o [c_cinza]Reino da Pleméria[/c] do nosso lado.",
        "Aqui, as notícias do dia."
    ],
    [
        "Bom dia, novo empregado.",
        "Estava lendo as notícias... [c_verm]Lakira[/c] e [c_azul]Heraldo[/c] são um lindo casal, não acha?",
        "As pessoas costumam preferir assuntos mais leves.",
        "Aqui, as notícias do dia.",
    ],
    [
        "Bom dia, empregado.",
        "Esses cantores deveriam tomar mais cuidado na televisão.",
        "Aqueles taquistães..! São [c_verm]violentos[/c] por natureza.",
        "Cuidado com o teor das notícias, empregado.",
        "Aliás, nosso departamento está sendo mais reconhecido.",
        "[c_azul]Essa noite, você terá de montar uma notícia a mais.[/c]",
        "Aqui, as notícias do dia."
    ],
    [
        "Bom dia, empregado.",
        "A [c_verde]República dos Abacates...[/c] Parece que vêem o mundo de maneira diferente.",
        "A paz é apenas uma ilusão.",
        "Nossa secretaria é bem séria, empregado. [c_verm]A realidade é dura.[/c]",
        "Aqui, as notícias do dia."
    ],
    [
        "Bom dia, empregado.",
        "Finalmente, parece que os taquistães vão desistir.",
        "Espero que tenha tido bons resultados.",
        "Amanhã acontecerá uma grande conferência entre as nações.",
        "Se tudo ir bem, manteremos nosso emprego.",
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
    x2: 115,
    y2: 60
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