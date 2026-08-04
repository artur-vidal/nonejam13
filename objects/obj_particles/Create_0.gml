//ParticleSystem1
poof_ps = part_system_create();
part_system_draw_order(poof_ps, true);
part_system_depth(poof_ps, -500);

//Emitter
poof_type = part_type_create();
part_type_shape(poof_type, pt_shape_disk);
part_type_size(poof_type, 0.05, 0.075, 0, 0);
part_type_scale(poof_type, 1, 1);
part_type_speed(poof_type, 1, 2, -0.05, 0);
part_type_direction(poof_type, 0, 360, 0, 0);
part_type_gravity(poof_type, 0, 0);
part_type_orientation(poof_type, 0, 0, 0, 0, false);
part_type_colour3(poof_type, $FFFFFF, $D8FFFB, $D3FBFF);
part_type_alpha3(poof_type, 1, 1, .5);
part_type_blend(poof_type, false);
part_type_life(poof_type, 20, 30);

poof_emitter = part_emitter_create(poof_ps);

poof = function(x, y) {
    part_emitter_burst(poof_ps, poof_emitter, poof_type, 30);
    part_system_position(poof_ps, x, y);
}