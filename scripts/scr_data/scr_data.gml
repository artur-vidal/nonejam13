enum UPGRADES {
    CARTEIROS,
    TERMOS,
    BESTEIROL,
    APELATIVO,
    VOCABULARIO,
    BOAIMAGEM
}

/// @param {int} _id
/// @param {string} text
/// @param {Struct.NewsModifiers} _modifiers
/// @param {Array<string>} _topics
function Term(
    _id,
    text,
    _modifiers,
    _topics
) constructor {
    id = _id
    content = text
    modifiers = _modifiers
    topics = _topics
}

/// @param {int} _rage
/// /// @param {int} _bias
/// /// @param {int} _ordinary
/// /// @param {int} _economy
/// /// @param {int} _celebrities
/// /// @param {int} _polemics
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


// JORNAIS COMPLETOS
/// @param {Array<Struct.HeadlineTerm>|Array<Struct.HeadlineDeco>} _blocks
function Newspaper(_blocks) constructor {
    blocks = _blocks
}

/// @param {string} text
/// @param {Array<Struct.HeadlineTerm>} headline_terms
function Headline(text, headline_terms) constructor {
    content = text    
    terms = headline_terms
}

/// @param {int} term_id
function HeadlineTerm(term_id) constructor {
    termo_id = term_id
    
    get_term = function() {
        return get_terms(self.termo_id)
    }
}

/// @param {Struct.Term} _termo
/// @param {bool} secret
function NewspaperDeco() constructor { 
    sprite = spr_icone_jornal
    index = irandom_range(4, 7)
    logo_left = choose(true, false)
    
    function draw_logo(x, y) {
        for (var i = 0; i < 5; i++) {
            var index = i
            var xmod = 0
            if(self.logo_left && i == 0) {
                xmod = -4
                index = self.index + 1
            } else if(!self.logo_left && i == 4) {
                xmod = 4
            }
            
            draw_sprite(self.sprite, index - logo_left, x + (i * 16) + xmod, y)
        }
    }
}

/// @param {int} id
/// @returns {Array<Struct.Term>|Struct.Term}
function get_terms(id = undefined) {
    static _terms = [
        new Term(1, "Angistânia", new NewsModifiers(1, 3, -2, 2, 0, 1), ["Angistânia", "Guerra", "Taquistão", "Fronteira"]),
        new Term(2, "Pleméria", new NewsModifiers(0.5, 1, -1, 2, 0, 0), ["Angistânia", "Guerra", "Pleméria", "Taquistão"]),
        new Term(3, "Taquistão", new NewsModifiers(2, -1, -1.5, 2, 0, 1), ["Angistânia", "Guerra", "Fronteira"]),
        new Term(4, "Rep. Abacates", new NewsModifiers(0, 0, 1, 1, 0, 0), ["Rep. Abacates", "Paz"]),
        new Term(5, "Cadeia", new NewsModifiers(0, 0.5, 0.5, 0, 0, 1), ["Cotidiano", "Crime"]),
        new Term(6, "Casa", new NewsModifiers(0, 0, 0.25, 0, 0, 0), ["Cotidiano"]),
        new Term(7, "Motel", new NewsModifiers(0.25, 0, 1, 0, 0, 1), ["Cotidiano", "Sapecagens"]),
        new Term(8, "Jato particular", new NewsModifiers(0.5, 0, 1, 2, 0, 1), ["Cotidiano", "Dinheiro"]),
        new Term(9, "Rua", new NewsModifiers(0, 0, 0, 0.5, 0, 0), ["Cotidiano"]),
        new Term(10, "Sir Plemin XVI", new NewsModifiers(0, 1, 0, 1, 1, 0), ["Angistânia", "Guerra", "Pleméria", "Taquistão"]),
        new Term(11, "Giarno Angus", new NewsModifiers(1.5, 3, 0, 1, 1, 1), ["Angistânia", "Guerra", "Taquistão"]),
        new Term(12, "Takalo Amali", new NewsModifiers(2, -2, 0, 1, 1, 1), ["Angistânia", "Guerra"]),
        new Term(13, "João Pedro 52º", new NewsModifiers(0, 0, 2, 0.5, 1, 0), ["Rep. Abacates"]),
        new Term(14, "Kanye East", new NewsModifiers(1, -1, 1, -0.5, 1, 1), ["Taquistão", "Música"]),
        new Term(15, "Lakira", new NewsModifiers(0, 2, 0.5, -1, 1, 0), ["Angistânia", "Música", "Paz", "Heraldo", "Lakira"]),
        new Term(16, "Heraldo", new NewsModifiers(0.5, 2, 1.5, 0, 1, 1), ["Angistânia", "Esporte", "Lakira", "Heraldo"]),
        new Term(17, "Richelon", new NewsModifiers(1, -1, 1.5, 0, 1, 0), ["Taquistão", "Esporte"]),
        new Term(18, "Idoso", new NewsModifiers(-0.5, 0, 0.5, 0, 0, 0), ["Cotidiano"]),
        new Term(19, "Criança", new NewsModifiers(-1, 0, 0.5, 0, 0, 0), ["Cotidiano"]),
        new Term(20, "Bandido", new NewsModifiers(1.5, 0, 0.25, 0.5, 0, 1), ["Cotidiano", "Crime"]),
        new Term(21, "Empresária", new NewsModifiers(0.5, 0, 0, 1.5, 0, 1), ["Cotidiano", "Crime"]),
        new Term(22, "Ativista da paz", new NewsModifiers(0.5, 1, 0.25, 0, 0, 0), ["Cotidiano", "Paz"]),
        new Term(23, "Abacate", new NewsModifiers(-1, 0, 2.5, -1, 0, 0), ["Rep. Abacates", "Cotidiano", "Paz"]),
        new Term(24, "Atleta", new NewsModifiers(0, 0, 1, -0.5, 0, 0), ["Cotidiano", "Esporte"]),
    ]
    
    if(id) {
        for (var i = 0; i < array_length(_terms); i++) {
        	var term = _terms[i]
            if(term.id == id) {
                return term
            }
        }
    } else {
        return _terms   
    }
}

/// @param {int} id
/// @returns {Array<Struct>|Struct}
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

function get_newspaper(num) {
    static _newspapers = [
        new Newspaper([
            new NewspaperDeco(),
            new Headline("Bandido rouba idoso no meio da rua", [
                new HeadlineTerm(20),
                new HeadlineTerm(18),
                new HeadlineTerm(9)
            ])
        ]),
        new Newspaper([
            new NewspaperDeco(),
            new Headline("Giarno Angus faz resenha com Sir Plemin XVI", [
                new HeadlineTerm(11),
                new HeadlineTerm(10)
            ]),
            new Headline("Preço do abacate desce muito!", [
                new HeadlineTerm(23)
            ])
        ]),
    ]
    
    return _newspapers[num]
}