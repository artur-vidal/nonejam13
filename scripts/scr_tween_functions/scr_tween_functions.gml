// Adaptações das funções de easing do site:
/// @url https://easings.net
/// O parâmetro "t" representa um valor entre 0 e 1, sendo esse
/// o progresso absoluto da animação.

#macro EASE_C1 1.70158
#macro EASE_C2 (EASE_C1 * 1.525)
#macro EASE_C3 (EASE_C1 + 1)
#macro EASE_C4 ((2 * pi) / 3)
#macro EASE_C5 ((2 * pi) / 4.5)

// LINEAR
function ease_linear(t) {
    return t
}

// QUAD
function ease_in_quad(t) {
    return t * t
}

function ease_out_quad(t) {
    return 1 - (1 - t) * (1 - t)
}

function ease_in_out_quad(t) {
    return t < 0.5 ? 2 * t * t : 1 - power(-2 * t + 2, 2) / 2
}

// CUBIC
function ease_in_cubic(t) {
    return t * t * t
}

function ease_out_cubic(t) {
    return 1 - power(1 - t, 3)
}

function ease_in_out_cubic(t) {
    return t < 0.5 ? 4 * t * t * t : 1 - power(-2 * t + 2, 3) / 2
}

// QUART
function ease_in_quart(t) {
    return t * t * t * t
}

function ease_out_quart(t) {
    return 1 - power(1 - t, 4)
}

function ease_in_out_quart(t) {
    return t < 0.5 ? 8 * t * t * t * t : 1 - power(-2 * t + 2, 4) / 2
}

// QUINT
function ease_in_quint(t) {
    return t * t * t * t * t
}

function ease_out_quint(t) {
    return 1 - power(1 - t, 5)
}

function ease_in_out_quint(t) {
    return t < 0.5 ? 16 * t * t * t * t * t : 1 - power(-2 * t + 2, 5) / 2
}

// SINE
function ease_in_sine(t) {
    return 1 - cos((t * pi) / 2)
}

function ease_out_sine(t) {
    return sin((t * pi) / 2)
}

function ease_in_out_sine(t) {
    return -(cos(t * pi) - 1) / 2
}

// EXPO
function ease_in_expo(t) {
    return t == 0 ? 0 : power(2, 10 * t - 10)
}

function ease_out_expo(t) {
    return t == 1 ? 1 : 1 - power(2, -10 * t)
}

function ease_in_out_expo(t) {
    if(t == 0)
        return 0
    
    if(t == 1)
        return 1
    
    return t < 0.5
        ? power(2, 20 * t - 10) / 2
        : (2 - power(2, -20 * t + 10)) / 2;
}

// CIRC
function ease_in_circ(t) {
    return 1 - sqrt(1 - power(t, 2))
}

function ease_out_circ(t) {
    return sqrt(1 - power(t - 1, 2))
}

function ease_in_out_circ(t) {
    return t < 0.5
        ? (1 - sqrt(1 - power(2 * t, 2))) / 2
        : (sqrt(1 - power(-2 * t + 2, 2)) + 1) / 2
}

// BACK
function ease_in_back(t) {
    return (EASE_C3 * t * t * t) - (EASE_C1 * t * t)
}

function ease_out_back(t) {
    return 1 + EASE_C3 * power(t - 1, 3) + EASE_C1 * power(t - 1, 2)
}

function ease_in_out_back(t) {
    return t < 0.5
        ? (power(2 * t, 2) * ((EASE_C2 + 1) * 2 * t - EASE_C2)) / 2
        : (power(2 * t - 2, 2) * ((EASE_C2 + 1) * (t * 2 - 2) + EASE_C2) + 2) / 2
}

// ELASTIC
function ease_in_elastic(t) {
    if(t == 0)
        return 0
    
    if(t == 1)
        return 1
    
    return -power(2, 10 * t - 10) * sin((t * 10 - 10.75) * EASE_C4)
}

function ease_out_elastic(t) {
    if(t == 0)
        return 0
    
    if(t == 1)
        return 1
    
    return power(2, -10 * t) * sin((t * 10 - 0.75) * EASE_C4) + 1
}

function ease_in_out_elastic(t) {
    if(t == 0)
        return 0
    
    if(t == 1)
        return 1
    
    return t < 0.5
        ? -(power(2, 20 * t - 10) * sin((20 * t - 11.125) * EASE_C5)) / 2
        : (power(2, -20 * t + 10) * sin((20 * t - 11.125) * EASE_C5)) / 2 + 1
}

// BOUNCE
// começo pelo "out" pois o "in" usa isso
function ease_out_bounce(t) {
    var n1 = 7.5625; 
    var d1 = 2.75;
    
    if (t < 1 / d1) { 
        return n1 * t * t; 
    } else if (t < 2 / d1) {
        t -= 1.5 / d1 
        return n1 * t * t + 0.75; 
    } else if (t < 2.5 / d1) {
        t -= 2.25 / d1 
        return n1 * t * t + 0.9375; 
    } else {
        t -= 2.625 / d1
        return n1 * t * t + 0.984375; 
    } 
}

function ease_in_bounce(t) {
    return 1 - ease_out_bounce(1 - t)
}

function ease_in_out_bounce(t) {
    return t < 0.5
        ? (1 - ease_out_bounce(1 - 2 * t)) / 2
        : (1 + ease_out_bounce(2 * t - 1)) / 2
}