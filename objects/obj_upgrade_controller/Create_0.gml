current_id = -1

padding = 4
height = 60

get_content = function() {
    if(current_id == -1) {
        return "---"
    }
    
    var up = get_upgrades(current_id)
    var ef = ROOT.state.get_next_upgrade_effect(current_id)
    
    var str1 = $"[c_azul]{up.name}[/c] - {ROOT.state.upgrade_levels[up.id]}/3"
    var add_plus = (ROOT.state.upgrade_levels[up.id] < 3) ? "+" : ""
    
    var str2 = (up.id == Upgrades.APELATIVO) // lindo ternario
        ? string(up.description, add_plus + string(round(frac(ef) * 100)), add_plus + string(round((frac(ef) / 5) * 100)))
        : ((up.id == Upgrades.VOCABULARIO)
            ? string(up.description, string(ROOT.state.upgrade_levels[up.id] >= 2 ? "Infinito" : ef))
            : string(up.description, add_plus + string(round(frac(ef) * 100))))
    
    var str3 = up.flavor
    
    return $"{str1}\n{str2}\n\"{str3}\""
}

set = function(id) {
    current_id = id
}

unset = function() {
    current_id = -1
}

ROOT.events.connect("upgrade-hovered", set)
ROOT.events.connect("upgrade-unhovered", unset)


create_tween(id, "x", xstart, seconds(2))
    .delay(seconds(1))
    .from(x + room_width)
    .ease(ANIMATION_EASINGS.OUT_CUBIC)
    .fill(ANIMATION_FILL_MODES.BOTH)