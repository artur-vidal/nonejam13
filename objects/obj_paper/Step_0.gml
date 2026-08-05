var is_hovering_now = is_hovered()
var holding = mouse_check_button(mb_left)

width = (string_width(term.content) + padding * 2) * (scale - scale_decrement)
height = (string_height(term.content) + padding * 2) * (scale - scale_decrement)

if(dragging /* && GAME.mouse_in_area() */) {
    xto = mouse_x
    yto = mouse_y
} else {
    //spd = lerp(spd, 0, 0.2)
}

angle = (xto - x) / 12
spd = abs(point_distance(x, y, xto, yto) / 6)

// movimento
var dir = point_direction(x, y, xto, yto)
var lenx = lengthdir_x(spd, dir)
var leny = lengthdir_y(spd, dir)

x = (abs(xto - x) < lenx) ? xto : x + lenx
y = (abs(yto - y) < leny) ? yto : y + leny

depth = (dragging) ? -500 : -y

// efeitos das caixas
on_green = position_meeting(x, y, obj_greenbox)
on_red = position_meeting(x, y, obj_redbox)

// cor
color.r = lerp(color.r, (on_green) ? 200 : 255, 0.2)
color.g = lerp(color.g, (on_red) ? 200 : 255, 0.2)

scale_decrement = lerp(scale_decrement, (on_red || on_green) ? base_scale * 0.2 : 0, 0.3)