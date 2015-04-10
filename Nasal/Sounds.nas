#
# Author: Slavutinsky Victor
#

#--------------------------------------------------------------------
# Sound timer

# helper 
var stop_sounds = func {
}

var sounds = func 
	{
		# inflight time
		var time = getprop("fdm/jsbsim/simulation/sim-time-sec");
		var prev_time = getprop("fdm/jsbsim/systems/sounds/prev-time");
		var click = getprop("fdm/jsbsim/systems/sounds/click/on");
		var click_time = getprop("fdm/jsbsim/systems/sounds/click/time-sec");
		var pilot_g=getprop("fdm/jsbsim/accelerations/Nz");
		var maximum_g=getprop("fdm/jsbsim/accelerations/Nz-max");
		var cracking_on=getprop("fdm/jsbsim/systems/sounds/g-cracking/on");
		var cracking_next_time=getprop("fdm/jsbsim/systems/sounds/g-cracking/next-time");
		var p_psf=getprop("fdm/jsbsim/atmosphere/P-psf");
		if (
			(time == nil) 
			or (prev_time == nil) 
			or (click == nil) 
			or (click_time == nil)
			or (pilot_g==nil)
			or (maximum_g==nil)
			or (cracking_on==nil)
			or (cracking_next_time==nil)
			or (p_psf==nil)
		)
		{
			stop_sounds();
			return ( settimer(sounds, 0.1) ); 
		}
		var time_step=0;
		if ((prev_time>0) and ((time-prev_time)>0))
		{
			time_step=time-prev_time;
		}

		if (click==1)
		{
			click_time=click_time+time_step;
			if (click_time>0.5)
			{
				click_time=0;
				setprop("fdm/jsbsim/systems/sounds/click/on", 0);
			}
			setprop("fdm/jsbsim/systems/sounds/click/time-sec", click_time);
		}

		var crack_volume_internal=0;
		var crack_volume_external=0;
		if (pilot_g>(maximum_g*0.5))
		{
			if (pilot_g>maximum_g)
			{
				crack_volume_internal=1;
				setprop("fdm/jsbsim/systems/sounds/g-cracking/volume-internal", crack_volume_internal);
			}
			else
			{
				if (pilot_g>(maximum_g*0.75))
				{
					crack_volume_internal=math.sqrt((pilot_g-(maximum_g*0.5))/(maximum_g*0.5));
					setprop("fdm/jsbsim/systems/sounds/g-cracking/volume-internal", crack_volume_internal);
				}
				else
				{
					crack_volume=0;
					setprop("fdm/jsbsim/systems/sounds/g-cracking/volume-internal", crack_volume_internal);
				}
			}
			if (cracking_on==0)
			{
				if (cracking_next_time<=0)
				{
					cracking_next_time=rand()+(1-crack_volume_internal);
					setprop("fdm/jsbsim/systems/sounds/g-cracking/next-time", cracking_next_time);
					crack_sound();
				}
				else
				{
					cracking_next_time=cracking_next_time-0.1;
					setprop("fdm/jsbsim/systems/sounds/g-cracking/next-time", cracking_next_time);
				}
			}
		}
		else
		{
			crack_volume_internal=0;
			setprop("fdm/jsbsim/systems/sounds/g-cracking/volume-internal", crack_volume_internal);
		}
		crack_volume_external=crack_volume_internal*(p_psf/2110);
		setprop("fdm/jsbsim/systems/sounds/g-cracking/volume-external", crack_volume_external);
		settimer(sounds, 0.0);
	}

var crack_sound = func
	{
		setprop("fdm/jsbsim/systems/sounds/g-cracking/on", 1);
		settimer(end_crack_sound, 1);
	}

var end_crack_sound = func
	{
		setprop("fdm/jsbsim/systems/sounds/g-cracking/on", 0);
	}

# set startup configuration
var init_sounds = func
{
}
