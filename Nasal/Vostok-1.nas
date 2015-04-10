#
# Author: Slavutinsky Victor
#

# Vostok-1 main Nasal script

#--------------------------------------------------------------------
#Common bit swap function
var bitswap = func (bit_name)
	{
		set_pos=getprop(bit_name);
		if (set_pos==nil)
		{
			return (0); 
		}
		else
		{
			if (set_pos<0.5)
			{
				swap_pos=1;
			}
			else
			{
				swap_pos=0;
			}
			setprop(bit_name, swap_pos);
			return (1); 
		}
	}

#--------------------------------------------------------------------
#Init FDM
var init_fdm=func
{
	setprop("fdm/jsbsim/fcs/throttle-cmd-norm", 0);
	setprop("fdm/jsbsim/fcs/throttle-pos-norm", 0);

	setprop("fdm/jsbsim/fcs/elevator-cmd-norm", 0);
	setprop("fdm/jsbsim/fcs/elevator-pos-norm", 0);

	setprop("fdm/jsbsim/fcs/roll-pos-norm", 0);

	setprop("fdm/jsbsim/fcs/aileron-cmd-norm", 0);
	setprop("fdm/jsbsim/fcs/aileron-pos-norm", 0);

	setprop("fdm/jsbsim/fcs/rudder-cmd-norm", 0);
	setprop("fdm/jsbsim/fcs/rudder-pos-norm", 0);

	setprop("fdm/jsbsim/fcs/flap-cmd-norm", 0);
	setprop("fdm/jsbsim/fcs/flap-pos-norm", 0);

	setprop("fdm/jsbsim/gear/gear-cmd-norm", 1);

	setprop("fdm/jsbsim/gear/unit[0]/pos-norm", 1);
	setprop("fdm/jsbsim/gear/unit[1]/pos-norm", 1);
	setprop("fdm/jsbsim/gear/unit[2]/pos-norm", 1);
	setprop("fdm/jsbsim/gear/unit[3]/pos-norm", 1);
}

init_fdm();

#--------------------------------------------------------------------
#Init Controls
var init_controls=func
{
	setprop("controls/gear/brake-parking", 0);
	setprop("controls/gear/gear-down", 1);
	setprop("controls/flight/aileron", 0);
	setprop("controls/flight/elevator", 0);
	setprop("controls/flight/rudder", 0);
	setprop("controls/flight/flaps", 0);
}

init_controls();

#--------------------------------------------------------------------
#Init positions
var init_positions=func
{
	setprop("surface-positions/elevator-pos-norm", 0);
	setprop("surface-positions/left-aileron-pos-norm", 0);
	setprop("surface-positions/right-aileron-pos-norm", 0);
	setprop("surface-positions/rudder-pos-norm", 0);
	setprop("surface-positions/flap-pos-norm", 0);

	setprop("gear/gear[0]/wow", 0);
	setprop("gear/gear[1]/wow", 0);
	setprop("gear/gear[2]/wow", 0);
	setprop("gear/gear[3]/wow", 0);
}

#--------------------------------------------------------------------
#Init views
var init_views=func
{
	setprop("sim/view[3]/enabled", 0);
	setprop("sim/view[4]/enabled", 0);
}


#--------------------------------------------------------------------
#Aircraft refuel
var aircraft_start_refuel=func
	{
	}

var aircraft_end_refuel=func
	{
	}

var aircraft_refuel=func
	{
		aircraft_start_refuel();
		settimer(aircraft_end_refuel, 1);
	}

#--------------------------------------------------------------------
#Init position
var init_position=func
	{
		#Get startup orbital speed
		var initial_orbital_speed=getprop("fdm/jsbsim/velocities/eci-velocity-mag-fps");
		if (
			(initial_orbital_speed!=nil)
		)
		{
			setprop("fdm/jsbsim/velocities/initial-orbital-speed-fps", initial_orbital_speed);
		}
		else
		{
			setprop("fdm/jsbsim/velocities/initial-orbital-speed-fps", -1);
		}
	}

#--------------------------------------------------------------------
#Init instrumentation
var init_instrumentation=func
	{
		setprop("fdm/jsbsim/systems/arthorizon/on", 1);
		mainpanel.init_orbit();
	}

#--------------------------------------------------------------------
#Aircraft restart
var end_aircraftrestart=func
	{
		init_position();
		aircraft_end_refuel();
		#Restart throttle handle
		throttle_handle.init_handle();
		#Restart stanges changer
		stages.init_changer();
		#Restart first stage computer
		first_computer.init_computer();
		#Restart second stage computer
		second_computer.init_computer();
		#Restart third stage computer
		third_computer.init_computer();
		#Restart tdu stage computer
		tdu_computer.init_computer();
		#Restart crash checked
		crashes.init_crashes();
		#Unlock replay
		setprop("sim/replay/disable", 0);
		setprop("sim/menubar/default/menu[1]/item[8]/enabled", 1);
	}

var aircraft_restart=func
	{
		#Lock replay
		setprop("sim/replay/disable", 1);
		setprop("sim/menubar/default/menu[1]/item[8]/enabled", 0);
		#Additional gears restart
		setprop("fdm/jsbsim/gear/gear-pos-norm", 1);
		setprop("gear/gear[0]/position-norm", 1);
		setprop("gear/gear[1]/position-norm", 1);
		setprop("gear/gear[2]/position-norm", 1);
		setprop("gear/gear[3]/position-norm", 1);
		#Aircraft initialization
		init_controls();
		init_fdm();
		init_positions();
		aircraft_start_refuel();
		setprop("fdm/jsbsim/simulation/reset", 1);
		setprop("sim/freeze/clock", 0);
		setprop("sim/freeze/master", 0);
		settimer(end_aircraftrestart, 1);
	}

setprop("sim/freeze/state-saved/clock", 0);
setprop("sim/freeze/state-saved/master", 0);

#Init aircraft
#--------------------------------------------------------------------
var start_init=func
	{
		setprop("fdm/jsbsim/init/on", 1);
		setprop("fdm/jsbsim/init/finally-initialized", 0);
		setprop("gear/gear[0]/position-norm", 1);
		setprop("gear/gear[1]/position-norm", 1);
		setprop("gear/gear[2]/position-norm", 1);
		final_init();
	}

var init_craft=func
	{
		init_views();
		init_position();
		init_instrumentation();
	}

var final_init=func
	{
		var initialization=getprop("fdm/jsbsim/init/on");
		var time_elapsed=getprop("fdm/jsbsim/simulation/sim-time-sec");
		if (
			(initialization!=nil)
			and
			(time_elapsed!=nil)
		)
		{
			if (time_elapsed>0)
			{
				init_craft();
				setprop("fdm/jsbsim/init/on", 0);
				setprop("fdm/jsbsim/init/finally-initialized", 1);
			}
			else
			{
		 		return ( settimer(final_init, 0.1) ); 
			}
		}
	}

start_init();
