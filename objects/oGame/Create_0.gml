/// @function: handle_camera
/// @description: set the view port of the camera and move to keep the player in view
function handle_camera()
{
	full_screen = false;
	view_enabled = true;
	view_visible[0] = true;

	view_xport[0] = 0;
	view_yport[0] = 0;
	view_wport[0] = 960;
	view_hport[0] = 540;

	view_camera[0] = camera_create_view(0, 0, view_wport[0], view_hport[0], 0, oPlayer, -1, -1, 480, 270);

	var display_width = display_get_width();
	var display_height = display_get_height();
	var x_pos = (display_width / 2) - 480;
	var y_pos = (display_height / 2) - 270;
	window_set_rectangle(x_pos, y_pos, view_wport[0], view_hport[0]);

	surface_resize(application_surface, view_wport[0], view_hport[0]);
	
	handle_interpolation()

}

/// @ function: handle_interpolation
/// @ description: turn off textuyre filtering depending on if it is on or not
function handle_interpolation(){
	if (gpu_get_texfilter())
	{
	    gpu_set_texfilter(false);
	}
	else
	{
	    gpu_set_texfilter(true);
	}
}

handle_camera();