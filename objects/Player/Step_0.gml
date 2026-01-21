/// @Constants
lay_id = layer_get_id("room_tiles");
tile_id =  layer_tilemap_get_id(lay_id);

gamepad_set_axis_deadzone(0, 0.2);

left = keyboard_check(ord("A")) || (gamepad_axis_value(0,gp_axislh) < 0);
right = keyboard_check(ord("D")) || (gamepad_axis_value(0, gp_axislh) > 0);
jump = keyboard_check(vk_space) || gamepad_button_check(0,gp_face1);
roll = keyboard_check(vk_control) || gamepad_button_check(0,gp_face2); 

hor_dir = right - left;
ver_dir = 0;

grounded = place_meeting(x, y + 1, tile_id);
on_wall = (place_meeting(x + 1, y, tile_id) || place_meeting(x - 1, y, tile_id)) && (left || right);

ani_falling = prev_y <= y && !on_wall && !grounded;
ani_jumping = prev_y > y && !on_wall && !grounded;

/// @Function handle_animation
/// @Description: change sprite and animation of player
function handle_animation()
{
	if (move_x != 0 && grounded)
	{
		sprite_index = running;
	}
	else if ani_jumping
	{
		sprite_index = player_jumping;
	}
	else if ani_falling
	{
		sprite_index =  player_falling;
	}
	else
	{
		sprite_index = base;
	}
	if (move_x != 0) image_xscale = sign(hor_dir);
	
}

/// @Function handle_movement()
/// @Description: move the player based on the keys pressed and movement
///  action taken
function handle_movement()
{
	prev_x = x;
	prev_y = y;
	
	move_x = hor_dir * move_speed;	
	if !on_wall 
	{
		move_y += player_gravity;
	}

	/// Deciding the jump height and power on how long the key is pressed
	if (grounded && !on_wall && jump)
	{
		jump_power = 0.1;
		move_y = -jump_speed * jump_power;
		falling = false;
		gamepad_set_vibration(0,0.2,0.2);
		ver_dir = 1;
	}
	if(!jump)
	{
		falling = true;	
		gamepad_set_vibration(0,0,0);
	}
	else if ((jump_power < 0.5) && (jump) && (!falling))
	{
		jump_power += 0.05;
		move_y = -jump_speed * jump_power;	
	}
	else
	{
		gamepad_set_vibration(0,0,0);
		
	}
	
	/// Collision for the x based on the movement	
	if(place_meeting(x + move_x, y, tile_id))
	{
		while(!place_meeting(x + sign(move_x), y, tile_id))
		{
			x += sign(move_x)
		}
		move_x = 0;
	}
	x += move_x;

	/// Collision for the y based on the movement
	if(place_meeting(x, y + move_y, tile_id))
	{
		while(!place_meeting(x, y + sign(move_y), tile_id))
		{
			y += sign(move_y)
		}
		move_y = 0;
	}
	if (!on_wall)
	{
		y += move_y;
	}
	
	handle_animation();

}

handle_movement()