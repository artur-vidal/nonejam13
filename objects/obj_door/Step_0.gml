switch (state) {
    case "knocking":
        if (knocked) {
            secretary_alpha = clamp(secretary_alpha + 0.01, 0, 1)
            
            if (sound_cd < 0) {
                audio_play_sound(snd_knock, 0, 0)
                sound_cd = seconds(irandom_range(2, 7))
                ROOT.events.emit("shake-screen", ms(150))
            }
            
            sound_cd--
        }
        break
    
    case "talking":
        talking_cd--
        
        if (talking_cd < 0) {
            var len = string_length(current_dialogue())
            text_pos = clamp(text_pos + text_speed, 0, len)
            if(text_pos % 3 == 0 && !ended()) {
                audio_play_sound(snd_olivia, 0, 0, 1, 0, random_range(0.9, 1.1))
            }
        }
        break
}