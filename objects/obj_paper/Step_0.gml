var is_hovering_now = is_hovered()
var holding = mouse_check_button(mb_left)

width = string_width(content) + padding * 2
height = string_height(content) + padding * 2

xto = mouse_x - width / 2
yto = mouse_y - height / 2

if(dragging) {
    angle = (xto - x) / 15
    spd = abs(point_distance(x, y, xto, yto) / 8)
} else {
    spd = lerp(spd, 0, 0.2)
}

// movimento
var dir = point_direction(x, y, xto, yto)
var lenx = lengthdir_x(spd, dir)
var leny = lengthdir_y(spd, dir)

x = (abs(xto - x) < lenx) ? xto : x + lenx
y = (abs(yto - y) < leny) ? yto : y + leny

depth = (dragging) ? -500 : -y