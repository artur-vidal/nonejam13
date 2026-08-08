scene_step++;
draw_alarm = 30;
draw_alpha = 0;

audio_play_sound(msc_intro, 0, 1)
audio_sound_gain(msc_intro, 0.5)
audio_sound_gain(msc_intro, 1, 3000)