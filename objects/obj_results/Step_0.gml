if(rising) {
    rising_c++
    
    if(rising_c % 4 == 0) {
        audio_play_sound(snd_people, 0, 0, .7, 0, 0.9 + (rising_c / 300))
    }
}