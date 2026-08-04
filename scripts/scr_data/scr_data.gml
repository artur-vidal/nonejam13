enum UPGRADES {
    CARTEIROS,
    TERMOS,
    BESTEIROL,
    APELATIVO,
    VOCABULARIO,
    BOAIMAGEM
}

/// @param {string} text
/// @param {Struct.NewsModifiers} _modifiers
/// @param {Array<string>} _topics
function Term(
    text,
    _modifiers,
    _topics
) constructor {
    content = text
    modifiers = _modifiers
    topics = _topics
}

function NewsModifiers(
    _rage = 0,
    _bias = 0,
    _ordinary = 0,
    _economy = 0,
    _celebrities = 0,
    _polemics = 0
) constructor {
    // atributos arbitrarios
    rage = _rage
    bias = _bias
    ordinary = _ordinary
    economy = _economy
    
    // atributos de contagem
    celebrities = _celebrities
    polemics = _polemics
}

function NewsResult() constructor {
    modifiers = new NewsModifiers()
    others = {
        corruption: 0,
        violence_increase: 0,
        confidence_increase: 0,
        seriousness_increase: 0,
        off_topics: 0,
        
        // flags
        additional_point: false,
        too_corrupt: false,
        unbiased: {}
    }
    
    factor = 0
    
    /// @param {Array<Struct.Term>} terms
    /// @param {Struct.NewsModifiers} news_modifiers
    calculate = function(terms, news_modifiers) {
        var modifiers = news_modifiers
        
        for (var i = 0; i < array_length(terms); i++) {
        	var term = terms[i]
            modifiers.rage += term.modifiers.rage
            modifiers.bias += term.modifiers.bias
            modifiers.ordinary += term.modifiers.ordinary
            modifiers.economy += term.modifiers.economy
            modifiers.celebrities += term.modifiers.celebrities
            modifiers.polemics += term.modifiers.polemics
            
            modifiers.bias *= ROOT.state.get_upgrade_effect(UPGRADES.TERMOS)
        }
        
        self.modifiers = modifiers
        
        self.factor = get_factor()
        
        self.others.corruption = (self.modifiers.bias / 2) + ((self.modifiers.polemics) * (self.modifiers.economy + 1) / 5)
        self.others.violence_increase = ((self.modifiers.rage * 3) + (power(abs(self.others.corruption), 1.3) * (self.others.corruption < 0 ? -1 : 1))) * (ROOT.state.get_upgrade_effect(UPGRADES.APELATIVO) / 5)
        self.others.confidence_increase = (self.modifiers.bias - 2) + self.others.corruption
        self.others.seriousness_increase = power(self.modifiers.ordinary, 1.6)
        
        // informações aleatórias
        if(factor > 1) {
            self.others.additional_point = true
        }
        
        if(self.others.corruption > 2) {
            self.others.too_corrupt = true
        }
        
        if(self.modifiers.bias < -1) {
            var most_unbiased = {}
            for (var i = 0; i < array_length(terms); i++) {
            	var term = terms[i]
                if(
                    term.modifiers.bias < 0
                    && (
                        (variable_struct_exists(most_unbiased, "bias") && term.modifiers.bias < most_unbiased.bias)
                        || !variable_struct_exists(most_unbiased, "bias")
                    )
                ) {
                    most_unbiased = term
                }
            }
            
            self.others.unbiased = most_unbiased
        }
    }
    
    get_factor = function() {
        return sqrt(
            max(0.005, 
                (power(
                    abs(1 + self.modifiers.ordinary), 0.5) 
                    * max(1, (power(self.modifiers.celebrities, 0.4) * 0.3 + power((self.modifiers.rage < 0 ? abs(self.modifiers.rage / 3) : self.modifiers.rage), 0.6) * 0.3)) 
                    * ROOT.state.get_upgrade_effect(UPGRADES.BESTEIROL)
                )
                + ((self.modifiers.celebrities * 0.3) / (self.modifiers.celebrities + 0.5))
                - ((self.modifiers.economy * 0.7) / (self.modifiers.economy + 3))
                + (((self.modifiers.polemics - abs(self.modifiers.bias * 0.05) + (self.modifiers.rage * 0.2)) * power(self.modifiers.celebrities + 1, 0.4)) * ROOT.state.get_upgrade_effect(UPGRADES.APELATIVO))
                - 0.5
            )
        ) * ROOT.state.get_upgrade_effect(UPGRADES.CARTEIROS)
    }
}



function get_terms() {
    static _terms = [
        new Term("Angistânia", new NewsModifiers(1.0, 3.0, -2.0, 2.0, 0, 1), ["Angistânia", "Guerra", "Taquistão", "Fronteira"]),
        new Term("Pleméria", new NewsModifiers(0.5, 1.0, -1.0, 2.0, 0, 0), ["Angistânia", "Guerra", "Pleméria", "Taquistão"]),
        new Term("Taquistão", new NewsModifiers(2.0, -1.0, -1.5, 2.0, 0, 1), ["Angistânia", "Guerra", "Fronteira"]),
        new Term("Rep. Abacates", new NewsModifiers(0.0, 0.0, 1.0, 1.0, 0, 0), ["Rep. Abacates", "Paz"]),
        new Term("Cadeia", new NewsModifiers(0.0, 0.5, 0.5, 0.0, 0, 1), ["Cotidiano", "Crime"]),
        new Term("Casa", new NewsModifiers(0.0, 0.0, 0.25, 0.0, 0, 0), ["Cotidiano"]),
        new Term("Motel", new NewsModifiers(0.25, 0.0, 1.0, 0.0, 0, 1), ["Cotidiano", "Sapecagens"]),
        new Term("Jato particular", new NewsModifiers(0.5, 0.0, 1.0, 2.0, 0, 1), ["Cotidiano", "Dinheiro"]),
        new Term("Sir Plemin XVI", new NewsModifiers(0.0, 1.0, 0.0, 1.0, 1, 0), ["Angistânia", "Guerra", "Pleméria", "Taquistão"]),
        new Term("Giarno Angus", new NewsModifiers(1.5, 3.0, 0.0, 1.0, 1, 1), ["Angistânia", "Guerra", "Taquistão"]),
        new Term("Takalo Amali", new NewsModifiers(2.0, -2.0, 0.0, 1.0, 1, 1), ["Angistânia", "Guerra"]),
        new Term("João Pedro 52º", new NewsModifiers(0.0, 0.0, 2.0, 0.5, 1, 0), ["Rep. Abacates"]),
        new Term("Kanye East", new NewsModifiers(1.0, -1.0, 1.0, -0.5, 1, 1), ["Taquistão", "Música"]),
        new Term("Lakira", new NewsModifiers(0.0, 2.0, 0.5, -1.0, 1, 0), ["Angistânia", "Música", "Paz", "Heraldo", "Lakira"]),
        new Term("Heraldo", new NewsModifiers(0.5, 2.0, 1.5, 0.0, 1, 1), ["Angistânia", "Esporte", "Lakira", "Heraldo"]),
        new Term("Richelon", new NewsModifiers(1.0, -1.0, 1.5, 0.0, 1, 0), ["Taquistão", "Esporte"]),
        new Term("Idoso", new NewsModifiers(-0.5, 0.0, 0.5, 0.0, 0, 0), ["Cotidiano"]),
        new Term("Criança", new NewsModifiers(-1.0, 0.0, 0.5, 0.0, 0, 0), ["Cotidiano"]),
        new Term("Bandido", new NewsModifiers(1.5, 0.0, 0.25, 0.5, 0, 1), ["Cotidiano", "Crime"]),
        new Term("Empresária", new NewsModifiers(0.5, 0.0, 0.0, 1.5, 0, 1), ["Cotidiano", "Crime"]),
        new Term("Ativista da paz", new NewsModifiers(0.5, 1.0, 0.25, 0.0, 0, 0), ["Cotidiano", "Paz"]),
        new Term("Abacate", new NewsModifiers(-1.0, 0.0, 2.5, -1.0, 0, 0), ["Rep. Abacates", "Cotidiano", "Paz"]),
        new Term("Atleta", new NewsModifiers(0.0, 0.0, 1.0, -0.5, 0, 0), ["Cotidiano", "Esporte"]),
    ]
    
    return _terms
}

/// @param {int} id
/// @returns {Array.Struct|Struct}
function get_upgrades(id = undefined) {
    static _upgrades = [
        {
            id: UPGRADES.CARTEIROS,
            name: "Aumento aos Carteiros",
            description: "Aumenta o alcance geral das notícias em {0}%",
            flavor: "Não somos tão maus, nossos carteiros ganham muito bem!",
            effect: [1.1, 1.2, 1.35],
            zero: 1
        },
        {
            id: UPGRADES.TERMOS,
            name: "Termos e Condições",
            description: "Notícias são {0}% menos enviesadas.",
            flavor: "Supostamente, supostamente, supostamente...",
            effect: [1.25, 1.4, 1.6],
            zero: 1
        },
        {
            id: UPGRADES.BESTEIROL,
            name: "Besteirol",
            description: "Tópicos banais são {0}% mais efetivos.",
            flavor: "O povo não quer saber de política! O povo quer...",
            effect: [1.15, 1.35, 1.55],
            zero: 1
        },
        {
            id: UPGRADES.APELATIVO,
            name: "Apelativo",
            description: "Noticias com assuntos polêmicos ou que causem ódio são {0}% mais efetivas, mas também aumentam a violência em {0}%",
            flavor: "Choquei!",
            effect: [1.1, 1.25, 1.45],
            zero: 1
        },
        {
            id: UPGRADES.VOCABULARIO,
            name: "Vocabulário",
            description: "Aumenta a capacidade da caixa de termos para {0}.",
            flavor: "Nosso jornal também é aprendizado, sabe.",
            effect: [4, 5, infinity],
            zero: 3
        },
        {
            id: UPGRADES.BOAIMAGEM,
            name: "Boa Imagem",
            description: "Sua confiança desce {0}% mais devagar.",
            flavor: "Negócios são sobre \"parecer\".",
            effect: [1.1, 1.2, 1.4],
            zero: 1
        }
    ]
    
    if(id != undefined) {
        for (var i = 0; i < array_length(_upgrades); i++) {
        	var upgrade = _upgrades[i]
            if(upgrade.id == id) return upgrade;
        }
    } else {
        return _upgrades   
    }
}