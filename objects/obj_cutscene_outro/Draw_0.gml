var mb_press_f = mouse_check_button_pressed(mb_left);

draw_set_halign(-1)
draw_set_valign(-1);
draw_set_font(fnt_paper);

switch (scene_f)
{
	/////////////////////////////////////////////////////////////////////////////////////////
	case 0: //ANGISTANIA SOBERANA
	
	if (can_draw)
	{
		if (draw_alpha_f <= 1)
		{
			draw_alpha_f += draw_alpha_s;
		}
		
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, draw_alpha_f);
		draw_sprite_ext(spr_cs_tv, 0, 0, 0, 1, 1, 0, -1, draw_alpha_f);
		draw_sprite_ext(spr_cs_mapa_1, 0, 0, 0, 1, 1, 0, -1, draw_alpha_f);
	}
	
		if (draw_alpha_f >= 1)
		{
			text_speed_f++;
			if (text_speed_f mod 3 == 0)
			{
				var len = string_length(text_f[0]);
				if (text_att_f >= len)
				{
					can_skip_f = 1;
					text_att_f = len;
				}
				text_att_f++;
			}
		
			draw_text_scribble(16, 120, text_f[0],  text_att_f);
			}
	
		if (can_skip_f) 
		{
			if (mb_press_f)
			{
				can_skip_f = 0;
				text_att_f = 0;				
				text_speed_f = 0;
                
				scene_f = 4;
                audio_stop_all()
                audio_play_sound(msc_ending, 1, 1)
			}
			draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
		}
		
	break;
	/////////////////////////////////////////////////////////////////////////////////////////
	
	case 1: //TAQUISTAO SOBERANO
	
	if (can_draw)
	{
		if (draw_alpha_f <= 1)
		{
			draw_alpha_f += draw_alpha_s;
		}
		
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, draw_alpha_f);
		draw_sprite_ext(spr_cs_tv, 0, 0, 0, 1, 1, 0, -1, draw_alpha_f);
		draw_sprite_ext(spr_cs_mapa_2, 0, 0, 0, 1, 1, 0, -1, draw_alpha_f);
	}
	
	if (draw_alpha_f >= 1)
		{
			text_speed_f++;
			if (text_speed_f mod 3 == 0)
			{
				var len = string_length(text_f[1]);
				if (text_att_f >= len)
				{
					can_skip_f = 1;
					text_att_f = len;
				}
				text_att_f++;
			}
		
			draw_text_scribble(16, 120, text_f[1],  text_att_f);
			}
			
		if (can_skip_f) 
		{
			if (mb_press_f)
			{
				can_skip_f = 0;
				text_att_f = 0;				
				text_speed_f = 0;
                
				scene_f = 4;
                audio_stop_all()
                audio_play_sound(msc_ending, 1, 1)
			}
			draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
		}
	
	break;
	/////////////////////////////////////////////////////////////////////////////////////////
	
	case 2: //ABACATE SOBERANO
	
	if (can_draw)
	{
		if (draw_alpha_f <= 1)
		{
			draw_alpha_f += draw_alpha_s;
		}
		
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, draw_alpha_f);
		draw_sprite_ext(spr_cs_tv, 0, 0, 0, 1, 1, 0, -1, draw_alpha_f);
		draw_sprite_ext(spr_cs_mapa_3, 0, 0, 0, 1, 1, 0, -1, draw_alpha_f);
	}
	

	if (draw_alpha_f >= 1)
		{
			text_speed_f++;
			if (text_speed_f mod 3 == 0)
			{
				var len = string_length(text_f[2]);
				if (text_att_f >= len)
				{
					can_skip_f = 1;
					text_att_f = len;
				}
				text_att_f++;
			}
		
			draw_text_scribble(16, 120, text_f[2],  text_att_f);
			}
			
		if (can_skip_f) 
		{
			if (mb_press_f)
			{
				can_skip_f = 0;
				text_att_f = 0;				
				text_speed_f = 0;	
                
				scene_f = 4;
                audio_stop_all()
                audio_play_sound(msc_ending, 1, 1)
			}
			draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
		}
	
	break;
	/////////////////////////////////////////////////////////////////////////////////////////
	
	case 3: //BAIXA CONFIANÇA
	
	if (can_draw)
	{
		if (draw_alpha_f <= 1)
		{
			draw_alpha_f += draw_alpha_s;
		}
		
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, draw_alpha_f);
		draw_sprite_ext(spr_cs_tv, 0, 0, 0, 1, 1, 0, -1, draw_alpha_f);
		draw_sprite_ext(spr_cs_mapa_4, 0, 0, 0, 1, 1, 0, -1, draw_alpha_f);
	}
	
	if (draw_alpha_f >= 1)
		{
			text_speed_f++;
			if (text_speed_f mod 3 == 0)
			{
				var len = string_length(text_f[3]);
				if (text_att_f >= len)
				{
					can_skip_f = 1;
					text_att_f = len;
				}
				text_att_f++;
			}
		
			draw_text_scribble(16, 120, text_f[3],  text_att_f);
			}
			
		if (can_skip_f) 
		{
			if (mb_press_f)
			{
				can_skip_f = 0;
				text_speed_f = 0;
				text_att_f = 0;
                
				scene_f = 4;
                audio_stop_all()
                audio_play_sound(msc_ending, 1, 1)
			}
			draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
		}
		
	
	
	break;
	/////////////////////////////////////////////////////////////////////////////////////////

case 4: //OBRIGADO POR JOGAR

draw_set_halign(1)
draw_set_valign(1);

text_speed_f++;
			if (text_speed_f mod 3 == 0)
			{
				var len = string_length(text_f[4]);
				if (text_att_f >= len)
				{
					can_skip_f = 1;
					text_att_f = len;
				}
				text_att_f++;
			}
		
			draw_text_scribble(room_width/2, room_height/2, text_f[4],  text_att_f);
			
		if (can_skip_f) 
		{
			if (mb_press_f)
			{
                if(ROOT.state.played_game) {
                    game_end();
                } else {
                    audio_stop_all()
                    room_goto(rm_nox);
                }
			}
			draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
		}

break;

}
