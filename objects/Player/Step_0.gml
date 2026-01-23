/// @struct input, defined in the create even
input.left = keyboard_check(ord("A")) || (gamepad_axis_value(0,gp_axislh) < 0)
input.right = keyboard_check(ord("D")) || (gamepad_axis_value(0, gp_axislh) > 0)
input.up = keyboard_check(ord("W")) || (gamepad_axis_value(0,gp_axislv) < 0)
input.down = keyboard_check(ord("S")) || (gamepad_axis_value(0, gp_axislv) > 0)
input.roll = keyboard_check(vk_control) || gamepad_button_check(0,gp_face2) 
input.jump = keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0,gp_face1)
input.jump_hold = keyboard_check(vk_space) || gamepad_button_check(0,gp_face1)

/// @struct dir, defined in the create event
dir.hor = input.right - input.left;
dir.ver = input.up - input.down;

/// @struct state, defined in the create event
state.grounded = place_meeting(x, y + 1, room_res.tile_id)
state.on_wall = (place_meeting(x + 1, y, room_res.tile_id) || place_meeting(x - 1, y, room_res.tile_id)) && (input.left || input.right) && !state.grounded
state.falling = prev_y < y && !state.on_wall && !state.grounded;
state.jumping = prev_y >= y && !state.on_wall && !state.grounded;
state.running = move_x != 0 && state.grounded;

/// @Function handle_animation
/// @Description: change sprite and animation of player
function handle_animation()
{
	if state.running
	{
		sprite_index = player_running;
	}
	else if state.jumping
	{
		sprite_index = player_jumping;
	}
	else if state.falling
	{
		sprite_index =  player_falling;
	}
	else if state.on_wall
	{
		sprite_index =  player_hanging;
	}
	else
	{
		sprite_index = base;
	}
	if (move_x != 0) image_xscale = sign(dir.hor);
	
}

/// @Function handle_movement()
/// @Description: move the player 
function handle_movement()
{
	prev_x = x;
	prev_y = y;
	
	if (!state.jump_wall)
	{
		move_x = dir.hor * move_speed;	
	}
	else
	{
		move_x = dir.hor * -1 * move_speed;	
	}
	
	if (!state.on_wall)
	{
		move_y += player_gravity;
	}
	if (input.jump && (state.grounded || state.on_wall))
	{
			if (state.grounded)
			{
				jump_power = 0.1;
			}
			else if (state.on_wall)
			{
				dir.hor *= -1;
				move_x = move_speed * dir.hor;
				jump_power = 0.25;
				state.jump_wall = true;
			}
			move_y = -jump_speed * jump_power;
			gamepad_set_vibration(0,0.2,0.2);
			state.jump_con = true;
			
	}
	if ((jump_power < 0.25) && input.jump_hold && state.jump_con && state.jump_wall)
	{
		jump_power += 0.08;
		move_y = -jump_speed * jump_power;
		gamepad_set_vibration(0,0.2,0.2);
	}
	else if ((jump_power < 0.5) && input.jump_hold && state.jump_con)
	{
		jump_power += 0.08;
		move_y = -jump_speed * jump_power;
		gamepad_set_vibration(0,0.2,0.2);
	}
	else
	{
		state.jump_con = false;
		state.jump_wall = false;
		gamepad_set_vibration(0,0,0);
		
	}
	
	/// moving the player in the x direction
	if(place_meeting(x + move_x, y, room_res.tile_id))
	{
		while(!place_meeting(x + sign(move_x), y, room_res.tile_id))
		{
			x += sign(move_x)
		}
		move_x = 0;
	}
	x += move_x;

	/// moving the player in the y direction
	if(place_meeting(x, y + move_y, room_res.tile_id))
	{
		while(!place_meeting(x, y + sign(move_y), room_res.tile_id))
		{
			y += sign(move_y)
		}
		move_y = 0;
	}
	if (!state.on_wall)
	{
		y += move_y;
	}
	
	handle_animation();

}

handle_movement()