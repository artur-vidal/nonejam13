//ParticleSystem1
poof_ps = part_system_create();
part_system_draw_order(poof_ps, true);
part_system_depth(poof_ps, -500);

//Emitter
poof_type = part_type_create();
part_type_shape(poof_type, pt_shape_disk);
part_type_size(poof_type, 0.025, 0.05, 0, 0);
part_type_scale(poof_type, 1, 1);
part_type_speed(poof_type, 1.1, 2.5, -0.07, 0);
part_type_direction(poof_type, 0, 360, 0, 0);
part_type_gravity(poof_type, 0.025, -90);
part_type_orientation(poof_type, 0, 0, 0, 0, false);
part_type_colour2(poof_type, #ffffff, #ffffff);
part_type_alpha2(poof_type, 1, 0);
part_type_blend(poof_type, false);
part_type_life(poof_type, 15, 25);

poof_emitter = part_emitter_create(poof_ps);

poof = function(x, y) {
    part_particles_clear(poof_ps)
    part_emitter_burst(poof_ps, poof_emitter, poof_type, 200);
    part_system_position(poof_ps, x, y);
}