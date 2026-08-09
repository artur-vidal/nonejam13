var mb_pressed = mouse_check_button_pressed(mb_left);

image_speed = .05;
draw_set_halign(-1)
draw_set_valign(-1);
draw_set_font(fnt_paper);

switch (scene)
{
/////////////////////////////////////////////////////////////////////////////////////////
#region CENA 0
	case 0:
	
	switch (scene_step)
	{
		/////////////////////////////////////////////////////////////////////////////////////////
		#region CENA STEP 0
		case 0:
		
		draw_alarm--;
		
		if (draw_alarm <= 0)
		{
			draw_alarm = -1;
			
			if (draw_alpha <=1)
			{
				draw_alpha += draw_alpha_speed;
				alarm[0] = 60;
			}
			
			draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, draw_alpha);
		}

		break;
		#endregion
		/////////////////////////////////////////////////////////////////////////////////////////
		#region CENA STEP 1
		case 1:
		
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
		draw_alarm--;
		
		if (draw_alarm <= 0)
		{
			draw_alarm = -1;
			
			if (draw_alpha <=1)
			{
				draw_alpha += draw_alpha_speed;
			}
			
			draw_sprite_ext(spr_cs_tv, 0, 0, 0, 1, 1, 0, -1, draw_alpha);
			draw_sprite_ext(spr_cs_luz, image_index, 0, -4, 1, 1, 0, -1, draw_alpha);
			draw_sprite_ext(spr_cs_tv_efeito, image_index, 0, 0, 1, 1, 0, -1, draw_alpha);
		
			text_speed++;
			if (text_speed mod 20 == 0)
			{
				var len = string_length(text[0]);
				if (text_att >= len)
				{
					can_skip = 1;
					text_att = len;
				}
				text_att++;
			}

			draw_text_scribble(16, 120, text[0],  text_att);

		}
	
		if (can_skip)
		{
			if (mb_pressed)
			{
				scene_step++;
				can_skip = 0;
				text_att = 0;
				text_speed = 0;
			}
			draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
		}
		
		break;
		#endregion
		/////////////////////////////////////////////////////////////////////////////////////////
		#region CENA STEP 2
		case 2:
		
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
		draw_sprite(spr_cs_tv, 0, 0,0);
		draw_sprite(spr_cs_luz, image_index ,0, -4);
		draw_sprite(spr_cs_jornalista, image_index, 0, 0)
		
		text_speed++;
		if (text_speed mod 3 == 0)
		{
			var len = string_length(text[1]);
			if (text_att >= len)
			{
				can_skip = 1;
				text_att = len;
			}
			text_att++;
		}
		
		draw_text_scribble(16, 120, text[1],  text_att);
		
		if (can_skip)
		{
			if (mb_pressed)
			{
				scene_step++;
				can_skip = 0;
				text_att = 0;
				text_speed = 0;
			}
			draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
		}
		
		
		
		break;
		#endregion
		/////////////////////////////////////////////////////////////////////////////////////////
		#region CENA STEP 3
		case 3:
		
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
		draw_sprite(spr_cs_tv, 0, 0,0);
		draw_sprite(spr_cs_luz, image_index ,0, -4); 
		draw_sprite(spr_cs_mapa, image_index, 0, 0)
		
				text_speed++;
		if (text_speed mod 3 == 0)
		{
			var len = string_length(text[2]);
			if (text_att >= len)
			{
				can_skip = 1;
				text_att = len;
			}
			text_att++;
		}
		
		draw_text_scribble(16, 120, text[2],  text_att);
		
		if (can_skip)
		{
			if (mb_pressed)
			{
				scene_step++;
				can_skip = 0;
				text_att = 0;
				text_speed = 0;
			}
			draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
		}
		
		
		break;
		#endregion
		/////////////////////////////////////////////////////////////////////////////////////////
		#region CENA STEP 4
		case 4:
		
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
		draw_sprite(spr_cs_tv, 0, 0,0);
		draw_sprite(spr_cs_luz, image_index ,0, -4);
		draw_sprite(spr_cs_cobra, image_index, 0, 0)
		
        text_speed++;
		if (text_speed mod 3 == 0)
		{
			var len = string_length(text[3]);
			if (text_att >= len)
			{
				can_skip = 1;
				text_att = len;
			}
			text_att++;
		}
		
		draw_text_scribble(16, 120, text[3],  text_att);
		
		if (can_skip)
		{
			if (mb_pressed)
			{
				scene_step++;
				can_skip = 0;
				text_att = 0;
				text_speed = 0;
				draw_alpha = 0;
			}
			draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
		}
		
		
		break;
		#endregion
		/////////////////////////////////////////////////////////////////////////////////////////
		#region CENA STEP 5
		case 5:
		
		draw_sprite(spr_cs_tv, 0, 0,0);
		draw_sprite(spr_cs_luz, image_index ,0, -4);
		draw_sprite(spr_cs_cobra, image_index, 0, 0)
		
		if (draw_alpha <= 1)
		{
			draw_alpha += draw_alpha_speed;
			alarm[2] = 180;
		}
		
		draw_set_alpha(draw_alpha);
		draw_rectangle_colour(0,0, room_width, room_height, c_preto, c_preto, c_preto, c_preto, 0);
		draw_set_alpha(1);
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
		
		break;
		#endregion
		/////////////////////////////////////////////////////////////////////////////////////////
	}

	break;
#endregion
/////////////////////////////////////////////////////////////////////////////////////////
#region CENA 1
	case 1:
		
		switch (scene_step)
		{
			/////////////////////////////////////////////////////////////////////////////////////////
			#region CENA 0
			case 0:
			
				draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
			
				draw_alarm--;
		
				if (draw_alarm <= 0)
				{
					draw_alarm = -1;
			
					if (draw_alpha <=1)
					{
						draw_alpha += draw_alpha_speed;
					}
			
					draw_sprite_ext(spr_cs_tv, 0, 0, 0, 1, 1, 0, -1, draw_alpha);
					draw_sprite_ext(spr_cs_luz, image_index, 0, -4, 1, 1, 0, -1, draw_alpha);
					draw_sprite_ext(spr_cs_jornalista, image_index, 0, 0, 1, 1, 0, -1, draw_alpha);
		
					text_speed++;
					if (text_speed mod 3 == 0)
					{
						var len = string_length(text[4]);
						if (text_att >= len)
						{
							can_skip = 1;
							text_att = len;
						}
						text_att++;
					}

					draw_text_scribble(16, 120, text[4],  text_att);

				}
	
				if (can_skip)
				{
					if (mb_pressed)
					{
						scene_step++;
						can_skip = 0;
						text_att = 0;
						text_speed = 0;
					}
					draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
				}


			break;
			#endregion
			/////////////////////////////////////////////////////////////////////////////////////////
			#region CENA 1
			case 1:
			
			draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
			draw_sprite_ext(spr_cs_tv, 0, 0, 0, 1, 1, 0, -1, 1);
			draw_sprite_ext(spr_cs_luz, image_index, 0, -4, 1, 1, 0, -1, 1);
			draw_sprite_ext(spr_cs_gianno, image_index, 0, 0, 1, 1, 0, -1, 1);
			
						text_speed++;
					if (text_speed mod 3 == 0)
					{
						var len = string_length(text[5]);
						if (text_att >= len)
						{
							can_skip = 1;
							text_att = len;
						}
						text_att++;
					}

					draw_text_scribble(16, 120, text[5],  text_att);

		
	
				if (can_skip)
				{
					if (mb_pressed)
					{
						scene_step++;
						can_skip = 0;
						text_att = 0;
						text_speed = 0;
					}
					draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
				}
			
			
			break;
			#endregion
			/////////////////////////////////////////////////////////////////////////////////////////
			#region CENA 2
			case 2:
			draw_sprite(spr_cs_moldura, 0, 0, 0)
			draw_sprite(spr_cs_tv, 0, 0, 0)
			draw_sprite(spr_cs_luz, image_index, 0, -4); 
			draw_sprite(spr_cs_jornal, 0, 0, 0);
			
									text_speed++;
					if (text_speed mod 3 == 0)
					{
						var len = string_length(text[6]);
						if (text_att >= len)
						{
							can_skip = 1;
							text_att = len;
						}
						text_att++;
					}

					draw_text_scribble(16, 120, text[6],  text_att);

		
	
				if (can_skip)
				{
					if (mb_pressed)
					{
						scene_step++;
						can_skip = 0;
						text_att = 0;
						text_speed = 0;
						draw_alpha = 0;
					}
					draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
				}
			
			break;
			#endregion
			/////////////////////////////////////////////////////////////////////////////////////////
			#region CENA 3
			case 3:
			
			draw_sprite(spr_cs_tv, 0, 0, 0)
			draw_sprite(spr_cs_luz, image_index, 0, -4); 
			draw_sprite(spr_cs_jornal, 0, 0, 0);
			
			if (draw_alpha <= 1)
			{
				draw_alpha += draw_alpha_speed;
				alarm[2] = 180;
			}
		
			draw_set_alpha(draw_alpha);
			draw_rectangle_colour(0,0, room_width, room_height, c_preto, c_preto, c_preto, c_preto, 0);
			draw_set_alpha(1);
			draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
			
			break;
			#endregion
			/////////////////////////////////////////////////////////////////////////////////////////
		}
		
		
	break;
#endregion
/////////////////////////////////////////////////////////////////////////////////////////
#region CENA 2
case 2:

	switch (scene_step)
	{
		/////////////////////////////////////////////////////////////////////////////////////////
		#region CENA 0
		case 0:
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
		
		draw_alarm--;
		
				if (draw_alarm <= 0)
				{
					draw_alarm = -1;
			
					if (draw_alpha <=1)
					{
						draw_alpha += draw_alpha_speed;
					}
			
					draw_sprite_ext(spr_cs_tv, 0, 0, 0, 1, 1, 0, -1, draw_alpha);
					draw_sprite_ext(spr_cs_luz, image_index, 0, -4, 1, 1, 0, -1, draw_alpha);
					draw_sprite_ext(spr_cs_jornalista, image_index, 0, 0, 1, 1, 0, -1, draw_alpha);
		
					text_speed++;
					if (text_speed mod 3 == 0)
					{
						var len = string_length(text[7]);
						if (text_att >= len)
						{
							can_skip = 1;
							text_att = len;
						}
						text_att++;
					}

					draw_text_scribble(16, 120, text[7],  text_att);

				}
	
				if (can_skip)
				{
					if (mb_pressed)
					{
						scene_step++;
						can_skip = 0;
						text_att = 0;
						text_speed = 0;
					}
					draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
				}
		
		
		break;
		#endregion
		/////////////////////////////////////////////////////////////////////////////////////////
		#region CENA 1
		case 1:
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
		draw_sprite_ext(spr_cs_tv, 0, 0, 0, 1, 1, 0, -1, 1);
		draw_sprite_ext(spr_cs_luz, image_index, 0, -4, 1, 1, 0, -1, 1);
		draw_sprite_ext(spr_cs_carta, image_index, 0, 0, 1, 1, 0, -1, 1);
		
		text_speed++;
					if (text_speed mod 3 == 0)
					{
						var len = string_length(text[8]);
						if (text_att >= len)
						{
							can_skip = 1;
							text_att = len;
						}
						text_att++;
					}

					draw_text_scribble(16, 120, text[8],  text_att);

				
	
				if (can_skip)
				{
					if (mb_pressed)
					{
						scene_step++;
						can_skip = 0;
						text_att = 0;
						text_speed = 0;
					}
					draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
				}
		
		break;
		#endregion
		/////////////////////////////////////////////////////////////////////////////////////////
		#region CENA 2
		case 2:
		
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
		draw_sprite_ext(spr_cs_tv, 0, 0, 0, 1, 1, 0, -1, 1);
		draw_sprite_ext(spr_cs_luz, image_index, 0, -4, 1, 1, 0, -1, 1);
		draw_sprite_ext(spr_cs_gianno, image_index, 0, 0, 1, 1, 0, -1, 1);
		
		text_speed++;
					if (text_speed mod 3 == 0)
					{
						var len = string_length(text[9]);
						if (text_att >= len)
						{
							can_skip = 1;
							text_att = len;
						}
						text_att++;
					}

					draw_text_scribble(16, 120, text[9],  text_att);

				
	
				if (can_skip)
				{
					if (mb_pressed)
					{
						scene_step++;
						can_skip = 0;
						text_att = 0;
						text_speed = 0;
					}
					draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
				}
		
		break;
		#endregion
		/////////////////////////////////////////////////////////////////////////////////////////
		#region CENA 3
		case 3:
		draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
		draw_sprite_ext(spr_cs_tv, 0, 0, 0, 1, 1, 0, -1, 1);
		draw_sprite_ext(spr_cs_luz, image_index, 0, -4, 1, 1, 0, -1, 1);
		draw_sprite_ext(spr_cs_cobra, image_index, 0, 0, 1, 1, 0, -1, 1);
		
		text_speed++;
					if (text_speed mod 3 == 0)
					{
						var len = string_length(text[10]);
						if (text_att >= len)
						{
							can_skip = 1;
							text_att = len;
						}
						text_att++;
					}

					draw_text_scribble(16, 120, text[10],  text_att);

				
	
				if (can_skip)
				{
					if (mb_pressed)
					{
						scene_step++;
						can_skip = 0;
						text_att = 0;
						text_speed = 0;
						draw_alpha = 0;
					}
					draw_sprite(spr_cs_mouse, image_index, room_width-32, room_height-24);
				}
		
		break;
		#endregion
		/////////////////////////////////////////////////////////////////////////////////////////
		#region CENA 4
		case 4:
		
		draw_sprite(spr_cs_tv, 0, 0, 0)
			draw_sprite(spr_cs_luz, image_index, 0, -4); 
			draw_sprite(spr_cs_cobra, 0, 0, 0);
			draw_sprite_ext(spr_cs_moldura, 0, 0, 0, 1, 1, 0, -1, 1);
			if (draw_alpha <= 1)
			{
				draw_alpha += draw_alpha_speed;
				alarm[3] = 60;
			}
		
			draw_set_alpha(draw_alpha);
			draw_rectangle_colour(0,0, room_width, room_height, c_preto, c_preto, c_preto, c_preto, 0);
			draw_set_alpha(1);
			
		
		break;
		#endregion
	}


break;
#endregion
/////////////////////////////////////////////////////////////////////////////////////////
}