full_key = keyboard_check_pressed(vk_f11);
display_width = display_get_width();
display_height = display_get_height();

if (full_key) 
{
	full_screen = !full_screen
	window_set_fullscreen(full_screen);
	
	surface_resize(application_surface, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]));
}