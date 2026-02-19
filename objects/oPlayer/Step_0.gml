/// @struct input, defined in the create even
input.left = keyboard_check(ord("A")) || (gamepad_axis_value(0,gp_axislh) < 0);
input.right = keyboard_check(ord("D")) || (gamepad_axis_value(0, gp_axislh) > 0);
input.up = keyboard_check(ord("W")) || (gamepad_axis_value(0,gp_axislv) < 0);
input.down = keyboard_check(ord("S")) || (gamepad_axis_value(0, gp_axislv) > 0);

input.roll = keyboard_check_pressed(vk_shift) || gamepad_button_check_pressed(0,gp_face2);
input.jump = keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0,gp_face1);
input.jump_hold = keyboard_check(vk_space) || gamepad_button_check(0,gp_face1);
input.special = keyboard_check_pressed(ord("Z"));

/// @struct dir, defined in the create event
dir.hor = input.right - input.left;
dir.ver = input.up - input.down;

/// @struct state, defined in the create event
states.grounded = place_meeting(x, y + 1, room_res.tile_id)
states.wall.mount = 
	(((place_meeting(x + 1, y, room_res.tile_id) && input.right)
	|| (place_meeting(x - 1, y, room_res.tile_id) && input.left)))
	&& !states.grounded
	&& !(states.jumping && input.jump_hold)
	&& !states.roll.rolling
	&& !input.roll;

states.grapple.able = place_meeting(x, y+ states.grapple.dist_y, room_res.hooks) 
	|| place_meeting(x + states.grapple.dist_x, y, room_res.hooks)
	|| place_meeting(x - states.grapple.dist_x, y, room_res.hooks);
	
states.falling = prev_y < y && !states.wall.mount && !states.grounded;
states.jumping = prev_y >= y && !states.wall.mount && !states.grounded;
states.running = move_x != 0 && states.grounded && !states.roll.rolling;

if (states.wall.mount) 
{
	states.wall.dir = dir.hor;
}

/// @Function handle_animation
/// @Description: change sprite and animation of player
function handle_animation()
{
	if states.running
	{
		sprite_index = player_running;
	}
	else if states.jumping
	{
		sprite_index = player_jumping;
	}
	else if states.falling
	{
		sprite_index =  player_falling;
	}
	else if states.wall.mount
	{
		sprite_index =  player_hanging;
	}
	else if states.roll.rolling
	{
		sprite_index =  player_rolling;
	}
	else
	{
		sprite_index = base;
	}
	if (move_x != 0) && !states.roll.rolling image_xscale = sign(dir.hor);
	
	
}

/// @Function handle_movement()
/// @Description: move the player 
function handle_movement()
{
	prev_x = x;
	prev_y = y;
	
	if ((dir.hor != 0) && !states.roll.rolling)
	{
		states.face.hor = dir.hor;
	}
	
	handle_roll();
	handle_grapple();
	if (!states.wall.mount && !states.wall.jump && (states.wall.dir == 0))
	{
		if !states.roll.rolling
		{
			move_x = dir.hor * run_speed;
		}
		move_y += player_gravity;
		
	}
	else if(states.wall.mount && (states.wall.grav > states.wall.grav_count))
	{
		move_y = player_gravity
	}
	else if (states.wall.mount && (states.wall.grav <= states.wall.grav_count))
	{
		states.wall.grav += 1;
	}
	
	if (input.jump && !states.roll.rolling && (states.grounded || states.wall.mount))
	{
		jump_power = 0.1;
		if states.wall.mount
		{
			states.wall.jump = true;
			states.wall.grav = 0
		}
		if (states.wall.jump)
		{
			move_x = -states.wall.dir * run_speed;
		}
		move_y = -jump_speed * jump_power;
		gamepad_set_vibration(0,0.2,0.2);
		states.jump_con = true;
			
	}
	if ((jump_power < 0.5) && input.jump_hold && states.jump_con)
	{
		jump_power += 0.08;
		move_y = -jump_speed * jump_power;
		states.jump_con = true;
		gamepad_set_vibration(0,0.2,0.2);
	}
	else
	{
		states.wall.jump = false;
		states.jump_con = false;
		states.wall.dir = 0;
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
	if (!states.wall.mount || (states.wall.grav > states.wall.grav_count))
	{
		y += move_y;
	}
	handle_animation();
}

/// @Function handle_grapple()
/// @Description: determine and execture grappling hooks or enemies
function handle_grapple()
{	
	
	if input.special && oGrapple.hook_found
	{
		show_debug_message($"Hook found:\n\t grapple_x{oGrapple.x} grapple_y{oGrapple.y}\n\t player_x{x} player_y{y}")	
	}
	else if input.special
	{
		show_debug_message($"Hook layer id {room_res.hooks} {layer_exists("hook")}")	
	}
	
}

/// @Function handle_roll()
/// @Description: do a roll event if the key is pressed, giving i-frames to the player
function handle_roll()
{
	
	if (input.roll && states.grounded && !states.roll.rolling)
	{
		states.roll.roll_power = 0.5;
		move_x = states.face.hor * states.roll.roll_power * states.roll.roll_speed
		states.roll.rolling = true;
		
	}
	else if (states.roll.rolling && states.roll.roll_power > 0.1)
	{
		states.roll.roll_power -= 0.01;
		move_x = states.face.hor * states.roll.roll_power * states.roll.roll_speed;
		states.roll.rolling = true;
		
	}
	else
	{
		states.roll.rolling = false;
	}		
}

handle_movement();