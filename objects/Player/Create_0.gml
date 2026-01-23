///@struct room_res
///@description: resources provided by the room
room_res = {
	tile_id :  layer_tilemap_get_id(layer_get_id("room_tiles"))
	
}

///@struct state
///@description: states the player is in
states = {
	wall :
		{
			mount : false,
			jump : false,
			jump_con : false,
			dir : 0
		},
	grapple: 
		{
			swing : false	
		},
	grounded : false,
	falling : false,
	jumping : false,
	jump_con : false,
	running : false
}

///@struct dir
///@description: direction the player is looking
dir = {
	hor : 0,
	ver : 0
}

///@struct input
///@description: keys that are pressed by the player
input = {
	left : keyboard_check(ord("A")) || (gamepad_axis_value(0,gp_axislh) < 0),
	right : keyboard_check(ord("D")) || (gamepad_axis_value(0, gp_axislh) > 0),
	up : keyboard_check(ord("W")) || (gamepad_axis_value(0,gp_axislv) < 0),
	down : keyboard_check(ord("S")) || (gamepad_axis_value(0, gp_axislv) > 0),
	roll : keyboard_check(vk_control) || gamepad_button_check(0,gp_face2), 
	jump : keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0,gp_face1),
	jump_hold : keyboard_check(vk_space) || gamepad_button_check(0,gp_face1),	
	dead_zone : gamepad_set_axis_deadzone(0, 0.2)
	
}

// Movement Constants
jump_speed = 16;
jump_power = 0;
move_y = 0;
prev_y = 0;

run_speed = 6;
run_power = 0;
move_x = 0;
prev_x = 0;

roll_dist = 18;
roll_speed = 0;

player_gravity = 0.3;
player_weight = 1.0;


// Word constants
global.pause = false;
global.player_hp = 100;
global.music = true;
