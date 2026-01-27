x = oPlayer.x;
y = oPlayer.y;

if oPlayer.input.special
{
	if place_meeting(x, y, oPlayer.room_res.hooks)
	{
		hook_found = true;
	}
	else 
	{
		hook_found = false;	
	}
}
