enum TermTypes {
    SUBJECT,
    LOCATION,
    OBJECT
}

enum Upgrades {
    CARTEIROS,
    TERMOS,
    BESTEIROL,
    APELATIVO,
    VOCABULARIO,
    BOAIMAGEM
}

/// @param {real} _id
/// @param {string} text
/// @param {Enum.TermTypes} type
/// @param {Struct.NewsModifiers} _modifiers
/// @param {Array<string>} _topics
function Term(
    _id,
    text,
    type,
    _modifiers,
    _topics
) constructor {
    id = _id
    content = text
    modifiers = _modifiers
    topics = _topics
}

/// @param {real} _rage
/// /// @param {real} _bias
/// /// @param {real} _ordinary
/// /// @param {real} _economy
/// /// @param {real} _celebrities
/// /// @param {real} _polemics
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
        
        // outras infos
        additional_point: false,
        too_corrupt: false,
        unbiased: {},
        matching_topics: { } // tópico: [lista termos]
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
            
            modifiers.bias *= ROOT.state.get_upgrade_effect(Upgrades.TERMOS)
        }
        
        self.modifiers = modifiers
        
        self.factor = get_factor()
        
        self.others.corruption = (self.modifiers.bias / 2) + ((self.modifiers.polemics) * (self.modifiers.economy + 1) / 5)
        self.others.violence_increase = ((self.modifiers.rage * 3) + (power(abs(self.others.corruption), 1.3) * (self.others.corruption < 0 ? -1 : 1))) * (ROOT.state.get_upgrade_effect(Upgrades.APELATIVO) / 5)
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
                    * ROOT.state.get_upgrade_effect(Upgrades.BESTEIROL)
                )
                + ((self.modifiers.celebrities * 0.3) / (self.modifiers.celebrities + 0.5))
                - ((self.modifiers.economy * 0.7) / (self.modifiers.economy + 3))
                + (((self.modifiers.polemics - abs(self.modifiers.bias * 0.05) + (self.modifiers.rage * 0.2)) * power(self.modifiers.celebrities + 1, 0.4)) * ROOT.state.get_upgrade_effect(Upgrades.APELATIVO))
                - 0.5
            )
        ) * ROOT.state.get_upgrade_effect(Upgrades.CARTEIROS)
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

/// @param {real} term_id
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

/// @param {real} id
/// @returns {Array<Struct.Term>|Struct.Term}
function get_terms(id = undefined) {
    static _terms = [
        new Term(1, "Angistânia", TermTypes.LOCATION, new NewsModifiers(1, 3, -2, 2, 0, 1), ["Angistânia", "Guerra", "Taquistão", "Fronteira"]),
        new Term(2, "Pleméria", TermTypes.LOCATION, new NewsModifiers(0.5, 1, -1, 2, 0, 0), ["Angistânia", "Guerra", "Pleméria", "Taquistão"]),
        new Term(3, "Taquistão", TermTypes.LOCATION, new NewsModifiers(2, -1, -1.5, 2, 0, 1), ["Angistânia", "Guerra", "Fronteira"]),
        new Term(4, "Rep. Abacates", TermTypes.LOCATION, new NewsModifiers(0, 0, 1, 1, 0, 0), ["Rep. Abacates", "Paz"]),
        new Term(5, "Cadeia", TermTypes.LOCATION, new NewsModifiers(0, 0.5, 0.5, 0, 0, 1), ["Cotidiano", "Crime"]),
        new Term(6, "Casa", TermTypes.LOCATION, new NewsModifiers(0, 0, 0.25, 0, 0, 0), ["Cotidiano"]),
        new Term(7, "Motel", TermTypes.LOCATION, new NewsModifiers(0.25, 0, 1, 0, 0, 1), ["Cotidiano", "Romance"]),
        new Term(8, "Rua", TermTypes.LOCATION, new NewsModifiers(0, 0, 0.5, 0, 0, 0), ["Cotidiano"]),
        new Term(29, "Fronteiras", TermTypes.LOCATION, new NewsModifiers(0.5, 0, 0, 1, 0, 1), ["Guerra", "Fronteira"]),
        new Term(9, "Jato particular", TermTypes.LOCATION, new NewsModifiers(0.5, 0, 1, 2, 0, 1), ["Dinheiro"]),
        new Term(10, "Sir Plemin XVI", TermTypes.SUBJECT, new NewsModifiers(0, 1, 0, 1, 1, 0), ["Angistânia", "Guerra", "Pleméria", "Taquistão"]),
        new Term(11, "Giarno Angus", TermTypes.SUBJECT, new NewsModifiers(1.5, 3, 0, 1, 1, 1), ["Angistânia", "Guerra", "Taquistão"]),
        new Term(12, "Takalo Amali", TermTypes.SUBJECT, new NewsModifiers(2, -2, 0, 1, 1, 1), ["Angistânia", "Guerra"]),
        new Term(13, "João Pedro 52º", TermTypes.SUBJECT, new NewsModifiers(0, 0, 2, 0.5, 1, 0), ["Rep. Abacates", "Paz"]),
        new Term(14, "Kanye East", TermTypes.SUBJECT, new NewsModifiers(1, -1, 2, 1, 1, 1), ["Taquistão", "Música"]),
        new Term(15, "Lakira", TermTypes.SUBJECT, new NewsModifiers(0, 2, 1.5, 1, 1, 0), ["Angistânia", "Música", "Paz", "Heraldo", "Lakira"]),
        new Term(16, "Heraldo", TermTypes.SUBJECT, new NewsModifiers(0.5, 2, 1.5, 0.5, 1, 1), ["Angistânia", "Esporte", "Lakira", "Heraldo"]),
        new Term(17, "Richelon", TermTypes.SUBJECT, new NewsModifiers(1, -1, 1.5, 0.5, 1, 0), ["Taquistão", "Esporte"]),
        new Term(18, "Idoso", TermTypes.SUBJECT, new NewsModifiers(-0.5, 0, 0.5, 0, 0, 0), ["Cotidiano"]),
        new Term(19, "Criança", TermTypes.SUBJECT, new NewsModifiers(-1, 0, 0.5, 0, 0, 0), ["Cotidiano"]),
        new Term(20, "Bandido", TermTypes.SUBJECT, new NewsModifiers(1.5, 0, 0.25, 0.5, 0, 1), ["Cotidiano", "Crime"]),
        new Term(21, "Empresária", TermTypes.SUBJECT, new NewsModifiers(0.5, 0, 0, 1.5, 0, 1), ["Cotidiano", "Crime"]),
        new Term(22, "Ativista da paz", TermTypes.SUBJECT, new NewsModifiers(0.5, 1, 0.25, 0, 0, 0), ["Cotidiano", "Paz"]),
        new Term(24, "Atleta", TermTypes.SUBJECT, new NewsModifiers(0, 0, 1, 0.5, 0, 0), ["Cotidiano", "Esporte"]),
        new Term(23, "Abacate", TermTypes.OBJECT, new NewsModifiers(-1, 0, 2.5, -1, 0, 0), ["Rep. Abacates", "Cotidiano", "Paz"]),
        new Term(25, "Carteira", TermTypes.OBJECT, new NewsModifiers(0, 0, 0, 1, 0, 0), ["Cotidiano", "Dinheiro", "Crime"]),
        new Term(26, "Faca", TermTypes.OBJECT, new NewsModifiers(0.5, -0.25, 0, 0, 0, 0), ["Cotidiano", "Crime"]),
        new Term(27, "Pedra", TermTypes.OBJECT, new NewsModifiers(0, 0, 0.25, 0, 0, 0), ["Cotidiano"]),
        new Term(28, "Bandeira Nacional", TermTypes.OBJECT, new NewsModifiers(1, 1.5, -0.5, 1, 0, 1), ["Angistânia", "Guerra"]),
        new Term(30, "Joias", TermTypes.OBJECT, new NewsModifiers(0, 0, 1, 1.5, 0, 0), ["Cotidiano", "Dinheiro"]),
        new Term(31, "Banana", TermTypes.OBJECT, new NewsModifiers(0, 0, 1, -1, 0, 0), ["Cotidiano", "Rep. Abacates"]),
        new Term(32, "Colar da Amizade", TermTypes.OBJECT, new NewsModifiers(-1, 0, 1.5, 0, 0, 0), ["Cotidiano", "Paz"]),
        new Term(33, "Flores", TermTypes.OBJECT, new NewsModifiers(-0.5, 0, 0.5, 0, 0, 0), ["Cotidiano", "Paz", "Romance"]),
        new Term(34, "Bandeira Taquistana", TermTypes.OBJECT, new NewsModifiers(1.5, -2.0, -0.5, 1, 0, 1), ["Taquistão", "Guerra"]),
        new Term(35, "Arma", TermTypes.OBJECT, new NewsModifiers(1.5, -1, -0.5, 0, 0, 1), ["Crime"]),
        new Term(36, "Perfume", TermTypes.OBJECT, new NewsModifiers(0, 0, 1, 0.5, 0, 0), ["Cotidiano", "Romance"]),
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

/// @param {real} id
/// @returns {Array<Struct>|Struct}
function get_Upgrades(id = undefined) {
    static _Upgrades = [
        {
            id: Upgrades.CARTEIROS,
            name: "Aumento aos Carteiros",
            description: "Aumenta o alcance geral das notícias em {0}%",
            flavor: "Não somos tão maus, nossos carteiros ganham muito bem!",
            effect: [1.1, 1.2, 1.35],
            zero: 1
        },
        {
            id: Upgrades.TERMOS,
            name: "Termos e Condições",
            description: "Notícias são {0}% menos enviesadas.",
            flavor: "Supostamente, supostamente, supostamente...",
            effect: [1.25, 1.4, 1.6],
            zero: 1
        },
        {
            id: Upgrades.BESTEIROL,
            name: "Besteirol",
            description: "Tópicos banais são {0}% mais efetivos.",
            flavor: "O povo não quer saber de política! O povo quer...",
            effect: [1.15, 1.35, 1.55],
            zero: 1
        },
        {
            id: Upgrades.APELATIVO,
            name: "Apelativo",
            description: "Noticias com assuntos polêmicos ou que causem ódio são {0}% mais efetivas, mas também aumentam a violência em {0}%",
            flavor: "Choquei!",
            effect: [1.1, 1.25, 1.45],
            zero: 1
        },
        {
            id: Upgrades.VOCABULARIO,
            name: "Vocabulário",
            description: "Aumenta a capacidade da caixa de termos para {0}.",
            flavor: "Nosso jornal também é aprendizado, sabe.",
            effect: [4, 5, infinity],
            zero: 3
        },
        {
            id: Upgrades.BOAIMAGEM,
            name: "Boa Imagem",
            description: "Sua confiança desce {0}% mais devagar.",
            flavor: "Negócios são sobre \"parecer\".",
            effect: [1.1, 1.2, 1.4],
            zero: 1
        }
    ]
    
    if(id != undefined) {
        for (var i = 0; i < array_length(_Upgrades); i++) {
        	var upgrade = _Upgrades[i]
            if(upgrade.id == id) return upgrade;
        }
    } else {
        return _Upgrades   
    }
}