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
/// @param {Enum.TermTypes} _type
/// @param {Struct.NewsModifiers} _modifiers
/// @param {Array<string>} _topics
function Term(
    _id,
    text,
    _type,
    _modifiers,
    _topics
) constructor {
    id = _id
    content = text
    type = _type
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

/// @param {Struct.Sentence} _sentence
function NewsResult(_sentence) constructor {
    str = _sentence.get_raw_text()
    terms = _sentence.get_terms()
    modifiers = _sentence.modifiers
    others = {
        corruption: 0,
        violence_increase: 0,
        confidence_increase: 0,
        seriousness_increase: 0,
        
        // outras infos
        additional_point: false,
        too_corrupt: false,
        unbiased: false,
        matching_topics: { } // { tópico: [lista-termos] }
    }
    
    factor = 0
    
    /// @param {Array<Struct.Term>} terms
    /// @param {Struct.NewsModifiers} news_modifiers
    calculate = function() {
        var modifiers = self.modifiers
        var bias_sum = 0
        
        for (var i = 0; i < array_length(self.terms); i++) {
        	var term = self.terms[i]
            modifiers.rage += term.modifiers.rage
            bias_sum += term.modifiers.bias // unico multiplicativo
            modifiers.ordinary += term.modifiers.ordinary
            modifiers.economy += term.modifiers.economy
            modifiers.celebrities += term.modifiers.celebrities
            modifiers.polemics += term.modifiers.polemics
            
            
        }
        
        bias_sum *= ROOT.state.get_upgrade_effect(Upgrades.TERMOS)
        modifiers.bias *= bias_sum
        
        self.modifiers = modifiers
        
        self.factor = get_factor()
        
        self.others.corruption = (self.modifiers.bias / 2) + ((self.modifiers.polemics) * (self.modifiers.economy + 1) / 5)
        self.others.violence_increase = (((self.modifiers.rage - 1) * 3) + (power(abs(self.others.corruption), 1.2) * (self.others.corruption < 0 ? -1 : 1))) * (1 + frac(ROOT.state.get_upgrade_effect(Upgrades.APELATIVO) / 5))
        self.others.confidence_increase = (self.modifiers.bias - 1) + self.others.corruption * 2
        
        var ordinary_final = self.modifiers.ordinary - (self.modifiers.economy * 0.5)
        self.others.seriousness_increase = -power(1 + abs(ordinary_final), 1.6) * sign(ordinary_final)
        
        // informações aleatórias
        if(self.factor > 2.5) {
            self.others.additional_point = true
        }
        
        if(self.others.corruption > 8) {
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
        
        var topic_terms = {}
        
        for (var i = 0; i < array_length(self.terms); i++) {
        	var term = self.terms[i]
            for (var t = 0; t < array_length(term.topics); t++) {
                var topic = term.topics[t]
                if (!variable_struct_exists(topic_terms, topic)) {
                    topic_terms[$ topic] = []
                }
                array_push(topic_terms[$ topic], term)
            }
        }
        
        var topic_names = struct_get_names(topic_terms)
        for (var i = 0; i < array_length(topic_names); i++) {
        	var topic = topic_names[i]
            if (array_length(topic_terms[$ topic]) >= 2) {
                self.others.matching_topics[$ topic] = topic_terms[$ topic]
            }
        }
        
        var matched_topics = struct_get_names(self.others.matching_topics)
        
        if (array_length(matched_topics) == 0) {
            self.factor *= 0.8
        } else {
            var bonus = 0
            for (var i = 0; i < array_length(matched_topics); i++) {
            	var topic = matched_topics[i]
                bonus += 0.02 * (array_length(self.others.matching_topics[$ topic]) - 1)
            }
            self.factor *= (1 + bonus)
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


// FRASES MONTAVEIS

/// @param {Array<Struct.SentenceBlock>} _blocks
function Sentence(_blocks, _modifiers = new NewsModifiers()) constructor {
    blocks = _blocks
    modifiers = _modifiers
    
    get_terms = function() {
        var terms = []
        
        for (var i = 0; i < array_length(blocks); i++) {
            var block = blocks[i]
            
        	if(!is_instanceof(block, SentenceSlot)) continue;
            
            if(block.term != undefined) {
                array_push(terms, block.term)
            }
        }
        
        return terms
    }
    
    get_raw_text = function() {
        var text = ""
        
        for (var i = 0; i < array_length(self.blocks); i++) {
            var block = self.blocks[i]
            var content = is_instanceof(block, SentenceSlot) 
                ? (block.has_content() ? block.content : "_") 
                : block.content
            
            var first_char = string_char_at(content, 1)
            var no_space = (text == "" || first_char == "," || first_char == "!" || first_char == ".")
            
            text += (no_space ? "" : " ") + content
        }
        
        return text
    }
}

/// @param {string} _content
function SentenceBlock(_content) constructor {
    content = _content
    
    has_content = function() {
        return self.content != ""
    }
    
    get_width = function(scale = 1) {
        if(self.has_content()) {
            return string_width(self.content) * scale
        } else {
            return 40 * scale
        }
    }
    
    get_height = function(scale = 1) {
        if(self.has_content()) {
            return string_height(self.content) * scale
        } else {
            return 14 * scale
        }
    }
}

/// @param {Enum.TermTypes} _type
function SentenceSlot(_type) : SentenceBlock("") constructor {
    type = _type
    term = undefined
    
    set_term = function(term) {
        self.term = term
        self.content = term.content
    }
    
    pop_term = function(term, take_content = true) {
        if(take_content) {
            self.content = ""
        }
        
        var term_ref = self.term
        self.term = undefined
        
        return term_ref
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
        new Term(38, "Canal 5", TermTypes.LOCATION, new NewsModifiers(1.0, 1.5, 1.5, 1, 1, 1), ["Cotidiano"]),
        new Term(7, "Motel", TermTypes.LOCATION, new NewsModifiers(0.25, 0, 1, 0, 0, 1), ["Cotidiano", "Romance"]),
        new Term(8, "Parque", TermTypes.LOCATION, new NewsModifiers(0, 0, 0.5, 0, 0, 0), ["Cotidiano"]),
        new Term(29, "Fronteiras", TermTypes.LOCATION, new NewsModifiers(0.5, 0, 0, 1, 0, 1), ["Guerra", "Fronteira"]),
        new Term(9, "Jato particular", TermTypes.LOCATION, new NewsModifiers(0.5, 0, 1, 2, 0, 1), ["Dinheiro"]),
        new Term(10, "Sir Plemin XVI", TermTypes.SUBJECT, new NewsModifiers(0, 1, 0, 1, 1, 0), ["Angistânia", "Guerra", "Pleméria", "Taquistão"]),
        new Term(11, "Gianno Angus", TermTypes.SUBJECT, new NewsModifiers(1.5, 3, 0, 1, 1, 1), ["Angistânia", "Guerra", "Taquistão"]),
        new Term(12, "Takalo Amali", TermTypes.SUBJECT, new NewsModifiers(2, -2, 0, 1, 1, 1), ["Angistânia", "Guerra"]),
        new Term(13, "João Pedro Jr. Jr.", TermTypes.SUBJECT, new NewsModifiers(0, 0, 2, 0.5, 1, 0), ["Rep. Abacates", "Paz"]),
        new Term(14, "Keine East", TermTypes.SUBJECT, new NewsModifiers(1, -1, 2, 1, 1, 1), ["Taquistão", "Música"]),
        new Term(15, "Lakira", TermTypes.SUBJECT, new NewsModifiers(0, 2, 1.5, 1, 1, 0), ["Angistânia", "Música", "Paz", "Heraldo", "Lakira"]),
        new Term(37, "Chico Duarte", TermTypes.SUBJECT, new NewsModifiers(-1, 1.5, 0, 1, 1, 1), ["Angistânia", "Música", "Paz", "Heraldo", "Lakira"]),
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
        new Term(31, "Banana", TermTypes.OBJECT, new NewsModifiers(0, 0, 1, -1, 0, 0), ["Cotidiano", "Rep. Abacates"]),
        new Term(32, "Colar da Amizade", TermTypes.OBJECT, new NewsModifiers(-1, 0, 1.5, 0, 0, 0), ["Cotidiano", "Paz"]),
        new Term(33, "Flores", TermTypes.OBJECT, new NewsModifiers(-0.5, 0, 0.5, 0, 0, 0), ["Cotidiano", "Paz", "Romance"]),
        new Term(34, "Bandeira Taquistã", TermTypes.OBJECT, new NewsModifiers(1.5, -2.0, -0.5, 1, 0, 1), ["Taquistão", "Guerra"]),
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

/// @param {real} num
/// @returns {Array<Struct.Newspaper>}
function get_newspaper(num) {
    static _newspapers = [
        // DIA 1 (0, 1)
        new Newspaper([
            new NewspaperDeco(),
            new Headline("Fronteiras fechadas entre Angistânia e Taquistão", [
                new HeadlineTerm(29),
                new HeadlineTerm(1),
                new HeadlineTerm(3),
            ]),
            new Headline("Lakira lança novo álbum \"Serviço de Lavanderia\"", [
                new HeadlineTerm(15),
            ])
        ]),
        new Newspaper([
            new Headline("Canal 5 exalta Bandeira Nacional em transmissão", [
                new HeadlineTerm(38),
                new HeadlineTerm(28),
            ]),
        ]),
        
        // DIA 2 (2, 3)
        new Newspaper([
            new NewspaperDeco(),
            new Headline("Pleméria envia suprimentos ao país", [
                new HeadlineTerm(2),
            ]),
            new Headline("Bandido levado à cadeia por contrabando de pedra", [
                new HeadlineTerm(20),
                new HeadlineTerm(5),
                new HeadlineTerm(27),
            ])
        ]),
        new Newspaper([
            new Headline("Criança aponta ausência de flores nas cidades", [
                new HeadlineTerm(19),
                new HeadlineTerm(33),
            ]),
            new Headline("O Ditador Gianno Angus fecha tratado com João Pedro Jr. Jr.", [
                new HeadlineTerm(11),
                new HeadlineTerm(13),
            ]),
        ]),
        
        // DIA 3 (4, 5)
        new Newspaper([
            new NewspaperDeco(),
            new Headline("Rep. Abacates recebe refugiados angistanos", [
                new HeadlineTerm(4),
            ]),
            new Headline("Heraldo, parceiro de Lakira, visto escorregando em banana dentro de parque", [
                new HeadlineTerm(16),
                new HeadlineTerm(15),
                new HeadlineTerm(31),
                new HeadlineTerm(8),
            ])
        ]),
        new Newspaper([
            new Headline("Empresária começa nova linha de perfume", [
                new HeadlineTerm(21),
                new HeadlineTerm(36),
            ]),
            new Headline("Atleta viaja em jato particular com Takalo Amali", [
                new HeadlineTerm(24),
                new HeadlineTerm(9),
                new HeadlineTerm(12),
            ]),
        ]),
        
        // DIA 4 (6, 7)
        new Newspaper([
            new NewspaperDeco(),
            new Headline("Jogador Richelon visto em motel", [
                new HeadlineTerm(17),
                new HeadlineTerm(7),
            ]),
            new Headline("Ativista da paz oferece abacate em parque", [
                new HeadlineTerm(22),
                new HeadlineTerm(23),
                new HeadlineTerm(8), 
            ]), 
            new Headline("Keine East insulta Chico Duarte no Canal 5", [
                new HeadlineTerm(14),
                new HeadlineTerm(37),
                new HeadlineTerm(38),
            ]),
        ]),
        new Newspaper([
            new NewspaperDeco(),
            new Headline("O Ditador Gianno Angus, durante palestra, foi atacado por sujeito taqustão carregando arma!", [
                new HeadlineTerm(11),
                new HeadlineTerm(35),
            ]),
            new Headline("Bandeira Taquistã queimada em cadeia!", [
                new HeadlineTerm(34),
                new HeadlineTerm(5),
            ]),
        ]),
        
        // DIA 5 (8, 9)
        new Newspaper([
            new NewspaperDeco(),
            new Headline("Criança divide colar da amizade em fronteiras", [
                new HeadlineTerm(19),
                new HeadlineTerm(32),
                new HeadlineTerm(29),
            ]),
            new Headline("Angistânia consegue apoio militar de nações intercontinentais", [
                new HeadlineTerm(1),
            ])
        ]),
        new Newspaper([
            new Headline("Sir Plemin XVI organiza ataque ao Taquistão", [
                new HeadlineTerm(10),
                new HeadlineTerm(3),
            ]),
            new Headline("Chico Duarte responde a críticas com nova música", [
                new HeadlineTerm(37),
            ]),
            new Headline("Rep. Abacates declara amizade à todos os envolvidos no conflito", [
                new HeadlineTerm(4),
            ]),
        ]),
        
        // DIA 6 (10, 11, 12)
        new Newspaper([
            new NewspaperDeco(),
            new Headline("Lakira descrobre traição de Heraldo com Richelon!", [
                new HeadlineTerm(15),
                new HeadlineTerm(16),
                new HeadlineTerm(17),
            ]),
            new Headline("Empresária e Atleta famosos viajam para Pleméria frente à crescimento dos conflitos", [
                new HeadlineTerm(21),
                new HeadlineTerm(24),
                new HeadlineTerm(2),
            ]),
        ]),
        new Newspaper([
            new Headline("João Pedro Jr. Jr. diz: \"Tremendamente desolado pela violência nesses tempos. Por favor, comam mais abacate.\"", [
                new HeadlineTerm(13),
                new HeadlineTerm(23),
            ])
        ]),
        new Newspaper([
            new NewspaperDeco(),
            new Headline("Rumores apontam que Takalo Amali pode começar a ceder frente à numerosa pressão externa", [
                new HeadlineTerm(12),
            ]),
            new Headline("Adorada seja Angistânia.", [
                new HeadlineTerm(1),
            ])
        ])
    ]
    
    return _newspapers[num]
}

/// @param {real} index
/// @returns {Struct.Sentence}
function get_sentence(index) {
    static _sentences = [
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("faz declaração polêmica em"),
            new SentenceSlot(TermTypes.LOCATION),
        ], new NewsModifiers(0.5, 1, 0.5, 0.0)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("critica o uso abusivo de"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("por"),
            new SentenceSlot(TermTypes.SUBJECT),
        ], new NewsModifiers(0.5, 1, 0.0, 0.0)),
        new Sentence([
            new SentenceBlock("Autoridades nacionais proíbem o uso de"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("em espaços públicos"),
        ], new NewsModifiers(1.0, 1, -1.0, 0.5)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("e"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock(", segundo cartomantes, são poderosos quando acompanhados"),
        ], new NewsModifiers(0.0, 1, 1.0, 0.0)),
        new Sentence([
            new SentenceSlot(TermTypes.LOCATION),
            new SentenceBlock("anuncia fechamento de"),
            new SentenceSlot(TermTypes.LOCATION),
        ], new NewsModifiers(0.5, -1, 0.0, 1.0)),
        new Sentence([
            new SentenceSlot(TermTypes.LOCATION),
            new SentenceBlock("oferece"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("gratuito."),
        ], new NewsModifiers(-0.5, 1, 0.0, -1.0)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("faz palestra pública e critica governo"),
        ], new NewsModifiers(0.5, 1, -1.0, 0.0)),
        new Sentence([
            new SentenceSlot(TermTypes.LOCATION),
            new SentenceBlock(","),
            new SentenceSlot(TermTypes.LOCATION),
            new SentenceBlock("e"),
            new SentenceSlot(TermTypes.LOCATION),
            new SentenceBlock("celebram o dia nacional de"),
            new SentenceSlot(TermTypes.OBJECT),
        ], new NewsModifiers(0.0, 1, 0.5, 0.5)),
        new Sentence([
            new SentenceBlock("Queima de estoque de"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("em"),
            new SentenceSlot(TermTypes.LOCATION),
            new SentenceBlock("!"),
        ], new NewsModifiers(-1.0, 1, 1.5, -1.5)),
        new Sentence([
            new SentenceBlock("Grupo compartilha"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock(","),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("e"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("em"),
            new SentenceSlot(TermTypes.LOCATION),
        ], new NewsModifiers(0.0, 1, 0.5, -1.0)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("ataca"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("com"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("em"),
            new SentenceSlot(TermTypes.LOCATION),
        ], new NewsModifiers(1.5, -1, 0.0, 0.0)),
        new Sentence([
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("roubado por"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("em"),
            new SentenceSlot(TermTypes.LOCATION),
        ], new NewsModifiers(1.0, -1, 0.0, 0.5)),
        new Sentence([
            new SentenceSlot(TermTypes.LOCATION),
            new SentenceBlock(", em parceria com"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock(", faz doações de"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("para todos."),
        ], new NewsModifiers(0.0, 1, 0.0, -1.0)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("denunciado por perturbar"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("em"),
            new SentenceSlot(TermTypes.LOCATION),
        ], new NewsModifiers(0.5, -1, 0.0, 0.0)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("termina viagem de três meses em"),
            new SentenceSlot(TermTypes.LOCATION),
        ], new NewsModifiers(0.0, 1, 1.0, 0.0)),
        new Sentence([
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock(", na verdade, é um ótimo utensílio culinário!"),
        ], new NewsModifiers(-0.5, 1, 2.5, -0.5)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("descobre novo elemento com fusão entre"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("e"),
            new SentenceSlot(TermTypes.OBJECT),
        ], new NewsModifiers(0.0, 1, 0.5, 0.0)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("e"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("fazem performance artística em"),
            new SentenceSlot(TermTypes.LOCATION),
        ], new NewsModifiers(0.0, 1, 0.5, 0.0)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("avista"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("roubando"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("e rouba o criminoso durante o ato!"),
        ], new NewsModifiers(0.0, -1, 0.5, 0.5)),
        new Sentence([
            new SentenceSlot(TermTypes.LOCATION),
            new SentenceBlock("e"),
            new SentenceSlot(TermTypes.LOCATION),
            new SentenceBlock("fecham parceria e inexplicavelmente vão à falência em poucas horas."),
        ], new NewsModifiers(0.0, -1, 1.0, 1.5)),
        new Sentence([
            new SentenceBlock("Instituição descobre que"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("e"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock(", juntos, podem criar bombas atômicas."),
        ], new NewsModifiers(0.0, 1, -0.5, 0.5)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("presenteia"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("com"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("estragado..."),
        ], new NewsModifiers(0.5, -1, 0.5, 0.0)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("encontra fóssil jurássico em exploração individual."),
        ], new NewsModifiers(0.0, 1, 1.0, 1.0)),
        new Sentence([
            new SentenceBlock("Autoridades encontram quantidades exorbitantes de"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("em espaço público!"),
        ], new NewsModifiers(0.0, 1, 1.0, 0.5)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("e"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("lideram manifestação em"),
            new SentenceSlot(TermTypes.LOCATION),
        ], new NewsModifiers(0.5, -1, -0.5, 0.0)),
        new Sentence([
            new SentenceBlock("Empresa fecha após descobrir que"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("desviara dinheiro para"),
            new SentenceSlot(TermTypes.SUBJECT),
        ], new NewsModifiers(0.5, 1, 0.0, 2.0)),
        new Sentence([
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("persegue"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("até esse puxar"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("de repente!"),
        ], new NewsModifiers(0.5, -1, 0.0, 0.0)),
        new Sentence([
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("encontrado em"),
            new SentenceSlot(TermTypes.LOCATION),
            new SentenceBlock(", e"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("secretamente o troca por"),
            new SentenceSlot(TermTypes.OBJECT),
        ], new NewsModifiers(0.0, 1, 1.0, 0.0)),
        new Sentence([
            new SentenceSlot(TermTypes.LOCATION),
            new SentenceBlock("desaparece, mas cópia quase idêntica criada por"),
            new SentenceSlot(TermTypes.SUBJECT),
            new SentenceBlock("usando"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("é encontrada em"),
            new SentenceSlot(TermTypes.LOCATION),
        ], new NewsModifiers(0.0, 1, 1.5, 1.0)),
        new Sentence([
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("e"),
            new SentenceSlot(TermTypes.OBJECT),
            new SentenceBlock("encontrados dentro de Railux."),
        ], new NewsModifiers(0.0, 1, 2.0, 0.5)),
        new Sentence([
            new SentenceSlot(TermTypes.LOCATION),
            new SentenceBlock("é transformado em centro turístico."),
        ], new NewsModifiers(0.0, 1, 2.0, 1)),
    ]
    
    return _sentences[index]
}

/// @param {real} id
/// @returns {Array<Struct>|Struct}
function get_upgrades(id = undefined) {
    static _upgrades = [
        {
            id: Upgrades.CARTEIROS,
            name: "Aumento aos Carteiros",
            description: "Aumenta o alcance geral das notícias em [c_verde]{0}%[/c]",
            flavor: "Não somos tão maus, nossos carteiros ganham muito bem!",
            effect: [1.2, 1.3, 1.45],
            zero: 1
        },
        {
            id: Upgrades.TERMOS,
            name: "Termos e Condições",
            description: "Notícias são [c_verde]{0}%[/c] menos enviesadas. Isso efetivamente reduz o ódio causado e ameniza alterações de confiança.",
            flavor: "Supostamente, supostamente, supostamente...",
            effect: [1.25, 1.4, 1.6],
            zero: 1
        },
        {
            id: Upgrades.BESTEIROL,
            name: "Besteirol",
            description: "Tópicos banais são [c_verde]{0}%[/c] mais efetivos. ",
            flavor: "O povo não quer saber de política! O povo quer...",
            effect: [1.15, 1.35, 1.55],
            zero: 1
        },
        {
            id: Upgrades.APELATIVO,
            name: "Apelativo",
            description: "Noticias com assuntos polêmicos ou que causem ódio são [c_verde]{0}%[/c] mais efetivas, mas também aumentam a violência em [c_verm]{1}%[/c]",
            flavor: "Choquei!",
            effect: [1.1, 1.25, 1.45],
            zero: 1,
        },
        {
            id: Upgrades.VOCABULARIO,
            name: "Vocabulário",
            description: "Aumenta a capacidade da caixa de termos para [c_verde]{0}[/c].",
            flavor: "Nosso jornal também é aprendizado, sabe.",
            effect: [7, 8, infinity],
            zero: 5
        },
        {
            id: Upgrades.BOAIMAGEM,
            name: "Boa Imagem",
            description: "Sua confiança desce [c_verde]{0}%[/c] mais devagar.",
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

