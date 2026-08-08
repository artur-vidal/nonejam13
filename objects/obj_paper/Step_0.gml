var is_hovering_now = is_hovered()
var holding = mouse_check_button(mb_left)

set_dimensions()

if(dragging) {
    if(hovering_slot)  {
        xto = hovering_slot.gx + hovering_slot.width / 2
        yto = hovering_slot.gy + hovering_slot.height / 2
    } else {
        xto = mouse_x
        yto = mouse_y
    }
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

// empurrõezinhos
var push_x = 0
var push_y = 0
if(!dragging) {
    var min_distance = collision_radius * 2 // diametrico
    
    with(obj_paper) {
        if(other.id == id) {
            continue // sou eu
        }
        
        var dist = point_distance(other.x, other.y, x, y)
        if(dist < min_distance) {
            var opposite_dir = (dist > 0) ? point_direction(x, y, other.x, other.y) : random(360)
            var ratio = (min_distance - dist) / min_distance
            
            push_x = lengthdir_x(ratio * other.collision_force, opposite_dir)
            push_y = lengthdir_y(ratio * other.collision_force, opposite_dir)
        }
    }
    
    if (push_x != 0 || push_y != 0) {
        var drag_area = singleton(obj_paper_controller).get_drag_area()
        
        xto = clamp(xto + push_x, drag_area.x1 + collision_force, drag_area.x2 - collision_force)
        yto = clamp(yto + push_y, drag_area.y1 + collision_force, drag_area.y2 - collision_force)
    }
}