#
# Author: Slavutinsky Victor
#

# TDU stage computer
# Accouts maneur engines thrusts of tdu engine
# due to control position
# weights and tanks contents

#tdu_computer.init_computer(); gotta be called on manual aircraft restart

# helper 
stop_computer = func 
	{
	}

computer = func 
	{
		var in_service = getprop("fdm/jsbsim/systems/tdu_computer/serviceable" );
		if (in_service == nil)
		{
			stop_computer();
			return ( settimer(computer, 0.1) ); 
		}
		if ( in_service != 1 )
		{
			stop_computer();
			return ( settimer(computer, 0.1) ); 
		}
		var on=getprop("fdm/jsbsim/systems/tdu_computer/on");
		var handle_button=getprop("fdm/jsbsim/systems/controlhandle/button-switch");
		var stabilize=getprop("fdm/jsbsim/systems/tdu_computer/stabilize");

		var current_time=getprop("fdm/jsbsim/sim-time-sec");
		var previous_time=getprop("fdm/jsbsim/systems/tdu_computer/previous-time");
		var repeat_time=getprop("fdm/jsbsim/systems/tdu_computer/repeat-time");

		var aileron_cmd=getprop("fdm/jsbsim/systems/controlhandle/aileron-pos");
		var elevator_cmd=getprop("fdm/jsbsim/systems/controlhandle/elevator-pos");
		var rudder_cmd=getprop("fdm/jsbsim/systems/controlhandle/rudder-pos");

		var pitch_rad=getprop("fdm/jsbsim/systems/tdu_computer/pitch-rad");
		var roll_rad=getprop("fdm/jsbsim/systems/tdu_computer/roll-rad");
		var yaw_rad=getprop("fdm/jsbsim/systems/tdu_computer/yaw-rad");

	#Note what axises rotated and roll and yaw speeds swapped

		var pitch_speed=getprop("fdm/jsbsim/velocities/q-rad_sec");
		var roll_speed=getprop("fdm/jsbsim/velocities/r-rad_sec");
		var yaw_speed=getprop("fdm/jsbsim/velocities/p-rad_sec");

		var tdu_stage=getprop("fdm/jsbsim/stages/unit[4]/active");

		var tank=[0,0,0,0,0,0];
		tank[0]=getprop("fdm/jsbsim/propulsion/tank[16]/contents-lbs");
		tank[1]=getprop("fdm/jsbsim/propulsion/tank[17]/contents-lbs");
		tank[2]=getprop("fdm/jsbsim/propulsion/tank[18]/contents-lbs");
		tank[3]=getprop("fdm/jsbsim/propulsion/tank[19]/contents-lbs");
		tank[4]=getprop("fdm/jsbsim/propulsion/tank[20]/contents-lbs");
		tank[5]=getprop("fdm/jsbsim/propulsion/tank[21]/contents-lbs");

		var weight=[0,0,0,0,0,0];
		#tdu stage engine
		weight[0]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[24]");
		weight[1]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[25]");
		#tdu stage
		weight[2]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[26]");
		weight[3]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[27]");
		#Spacecraft
		weight[4]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[28]");
		weight[5]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[29]");

		var z_pos=[0,0,0,0,0,0];
		#tdu stage engine
		z_pos[0]=getprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[24]");
		z_pos[1]=getprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[25]");
		#tdu stage
		z_pos[2]=getprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[26]");
		z_pos[3]=getprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[27]");
		#Spacecraft
		z_pos[4]=getprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[22]");
		z_pos[5]=getprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[23]");

		var x_pos=[0,0,0,0,0,0];
		#tdu stage engine
		x_pos[0]=getprop("fdm/jsbsim/inertia/pointmass-location-X-inches[24]");
		x_pos[1]=getprop("fdm/jsbsim/inertia/pointmass-location-X-inches[25]");
		#tdu stage
		x_pos[2]=getprop("fdm/jsbsim/inertia/pointmass-location-X-inches[26]");
		x_pos[3]=getprop("fdm/jsbsim/inertia/pointmass-location-X-inches[27]");
		#Spacecraft
		x_pos[4]=getprop("fdm/jsbsim/inertia/pointmass-location-X-inches[28]");
		x_pos[5]=getprop("fdm/jsbsim/inertia/pointmass-location-X-inches[29]");

		pitch_factor=getprop("fdm/jsbsim/systems/tdu_computer/pitch-factor");
		pitch_speed_factor=getprop("fdm/jsbsim/systems/tdu_computer/pitch-speed-factor");
		pitch_speed_limit=getprop("fdm/jsbsim/systems/tdu_computer/pitch-speed-limit");

		roll_factor=getprop("fdm/jsbsim/systems/tdu_computer/roll-factor");
		roll_speed_factor=getprop("fdm/jsbsim/systems/tdu_computer/roll-speed-factor");
		roll_speed_limit=getprop("fdm/jsbsim/systems/tdu_computer/roll-speed-limit");

		command_factor=getprop("fdm/jsbsim/systems/tdu_computer/command-factor");

		if ((on==nil)
			or (handle_button==nil)
			or (stabilize==nil)
			or (current_time==nil)
			or (previous_time==nil)
			or (repeat_time==nil)
			or (aileron_cmd==nil)
			or (elevator_cmd==nil)
			or (rudder_cmd==nil)
			or (pitch_rad==nil)
			or (roll_rad==nil)
			or (yaw_rad==nil)
			or (pitch_speed==nil)
			or (roll_speed==nil)
			or (yaw_speed==nil)
			or (tdu_stage==nil)

			or (tank[0]==nil)
			or (tank[1]==nil)
			or (tank[2]==nil)
			or (tank[3]==nil)
			or (tank[4]==nil)
			or (tank[5]==nil)

			or (weight[0]==nil)
			or (weight[1]==nil)
			or (weight[2]==nil)
			or (weight[3]==nil)
			or (weight[4]==nil)
			or (weight[5]==nil)

			or (x_pos[0]==nil)
			or (x_pos[1]==nil)
			or (x_pos[2]==nil)
			or (x_pos[3]==nil)
			or (x_pos[4]==nil)
			or (x_pos[5]==nil)

			or (z_pos[0]==nil)
			or (z_pos[1]==nil)
			or (z_pos[2]==nil)
			or (z_pos[3]==nil)
			or (z_pos[4]==nil)
			or (z_pos[5]==nil)

			or (pitch_factor==nil)
			or (pitch_speed_factor==nil)
			or (pitch_speed_limit==nil)

			or (roll_factor==nil)
			or (roll_speed_factor==nil)
			or (roll_speed_limit==nil)

			or (command_factor==nil)

			)
		{
			stop_computer();
			setprop("fdm/jsbsim/systems/tdu_computer/error", 1);
			return ( settimer(computer, 0.1) ); 
		}
		if (on==0)
		{
			stop_computer();
			setprop("fdm/jsbsim/systems/tdu_computer/error", 2);
			return ( settimer(computer, 0.1) ); 
		}
		setprop("fdm/jsbsim/systems/tdu_computer/error", 0);
		if (previous_time==0)
		{
			previous_time=current_time;
			setprop("fdm/jsbsim/systems/tdu_computer/previous-time", previous_time);
		}
		if (current_time>previous_time)
		{

			if (tdu_stage==0)
			{
				setprop("fdm/jsbsim/systems/tdu_computer/pitch-forward", 0);
				setprop("fdm/jsbsim/systems/tdu_computer/pitch-back", 0);
				setprop("fdm/jsbsim/systems/tdu_computer/yaw-left", 0);
				setprop("fdm/jsbsim/systems/tdu_computer/yaw-right", 0);
				setprop("fdm/jsbsim/systems/tdu_computer/roll-forward-left", 0);
				setprop("fdm/jsbsim/systems/tdu_computer/roll-back-right", 0);
				setprop("fdm/jsbsim/systems/tdu_computer/roll-forward-right", 0);
				setprop("fdm/jsbsim/systems/tdu_computer/roll-back-left", 0);
				return ( settimer(computer, 0.1) ); 
			}

			#Account mass moments for correct egines angles account
			#Because FG do not translate all JSB properties it's needed to add constants in text anyway

			#Note, if mass account is too complicated for You You can check angular speed as angle lock computer do

			var roll_moment_quote=
			(
				weight[0]*x_pos[0]+
				weight[1]*x_pos[1]+
				weight[2]*x_pos[2]+
				weight[3]*x_pos[3]+
				weight[4]*x_pos[4]+
				weight[5]*x_pos[5]+

				(tank[0]+tank[1]+tank[2]+tank[3])*10.19+
				(tank[4]+tank[5])*40.55
			)
			/
			(
				weight[0]*x_pos[0]+
				weight[1]*x_pos[1]+
				weight[2]*x_pos[2]+
				weight[3]*x_pos[3]+
				weight[4]*x_pos[4]+
				weight[5]*x_pos[5]+

				(242.5*2+66.13*2)*10.19+
				(55.11*2)*40.55
			);

			setprop("fdm/jsbsim/systems/tdu_computer/roll-moment-quote", roll_moment_quote);

			var pitch_yaw_moment_quote=
			(
				weight[0]*z_pos[0]+
				weight[1]*z_pos[1]+
				weight[2]*z_pos[2]+
				weight[3]*z_pos[3]+
				weight[4]*z_pos[4]+
				weight[5]*z_pos[5]+

				(tank[0]+tank[1])*47.51+
				(tank[2]+tank[3])*33.89+
				(tank[4]+tank[5])*4.251
			)
			/
			(
				weight[0]*x_pos[0]+
				weight[1]*x_pos[1]+
				weight[2]*x_pos[2]+
				weight[3]*x_pos[3]+
				weight[4]*x_pos[4]+
				weight[5]*x_pos[5]+

				(242.5*2)*47.51+
				(66.13*2)*33.89+
				(55.11*2)*4.251

			);

			setprop("fdm/jsbsim/systems/tdu_computer/pitch-yaw-moment-quote", pitch_yaw_moment_quote);

			#Stored angles for auto control system
			if (
				((aileron_cmd==0) and (handle_button==1))
				or (stabilize==1)
			)
			{
				roll_rad=roll_rad+roll_speed*(current_time-previous_time);
			}
			else
			{
				roll_rad=0;
			}

			if (
				((elevator_cmd==0) and (handle_button==1))
				or (stabilize==1)
			)
			{
				pitch_rad=pitch_rad+pitch_speed*(current_time-previous_time);
			}
			else
			{
				pitch_rad=0;
			}

			if (
				((rudder_cmd==0) and (handle_button==1))
				or (stabilize==1)
			)
			{
				yaw_rad=yaw_rad+yaw_speed*(current_time-previous_time);
			}
			else
			{
				yaw_rad=0;
			}
			setprop("fdm/jsbsim/systems/tdu_computer/roll-rad", roll_rad);
			setprop("fdm/jsbsim/systems/tdu_computer/pitch-rad", pitch_rad);
			setprop("fdm/jsbsim/systems/tdu_computer/yaw-rad", yaw_rad);

			#Account commands

			#Command roll
			var roll_cmd=0;
			if ((aileron_cmd==0) or (stabilize==1))
			{
				roll_cmd=(-roll_rad*roll_factor-roll_speed_factor*roll_speed*(current_time-previous_time))/math.pi;
			}
			else
			{
				roll_cmd=aileron_cmd;
			}
			#Limit angle speed
			if (math.abs(roll_speed)>(roll_speed_limit/180*math.pi))
			{
				roll_cmd=roll_cmd-roll_speed_factor*roll_speed*(current_time-previous_time)/math.pi;
			}
			roll_cmd=roll_cmd*roll_moment_quote;
			setprop("fdm/jsbsim/systems/tdu_computer/cmd-roll", roll_cmd);

			#Command yaw
			var yaw_cmd=0;
			if ((rudder_cmd==0) or (stabilize==1))
			{
				#As addition, axis is inverted
				yaw_cmd=(yaw_rad*pitch_factor+pitch_speed_factor*yaw_speed*(current_time-previous_time))/math.pi;
			}
			else
			{
				yaw_cmd=rudder_cmd;
			}
			#Limit angle speed
			if (math.abs(yaw_speed)>(pitch_speed_limit/180*math.pi))
			{
				yaw_cmd=yaw_cmd+pitch_speed_factor*yaw_speed*(current_time-previous_time)/math.pi;
			}
			yaw_cmd=yaw_cmd*pitch_yaw_moment_quote;
			setprop("fdm/jsbsim/systems/tdu_computer/cmd-yaw", yaw_cmd);

			#Command pitch
			var pitch_cmd=0;
			if ((elevator_cmd==0) or (stabilize==1))
			{
				#Axis is inverted
				pitch_cmd=(pitch_rad*pitch_factor+pitch_speed_factor*pitch_speed*(current_time-previous_time))/math.pi;
			}
			else
			{
				pitch_cmd=elevator_cmd;
			}
			#Limit angle speed
			if (math.abs(pitch_speed)>(pitch_speed_limit/180*math.pi))
			{
				pitch_cmd=pitch_cmd+pitch_speed_factor*pitch_speed*(current_time-previous_time)/math.pi;
			}
			pitch_cmd=pitch_cmd*pitch_yaw_moment_quote;
			setprop("fdm/jsbsim/systems/tdu_computer/cmd-pitch", pitch_cmd);

			#Real engines throttles

			var pitch_back=0;
			var pitch_forward=0;
			var yaw_right=0;
			var yaw_left=0;
			var roll_left=0;
			var roll_right=0;
			if ((handle_button==1) or (stabilize==1))
			{

				#Forward and back pitch engines
				pitch_back=pitch_cmd*command_factor;
				if (pitch_back>1)
				{
					pitch_back=1;
				}
				if (pitch_back<0)
				{
					pitch_back=0;
				}
				pitch_forward=-pitch_cmd*command_factor;
				if (pitch_forward>1)
				{
					pitch_forward=1;
				}
				if (pitch_forward<0)
				{
					pitch_forward=0;
				}

				#Left and right yaw engines
				yaw_right=yaw_cmd*command_factor;
				if (yaw_right>1)
				{
					yaw_right=1;
				}
				if (yaw_right<0)
				{
					yaw_right=0;
				}
				yaw_left=-yaw_cmd*command_factor;
				if (yaw_left>1)
				{
					yaw_left=1;
				}
				if (yaw_left<0)
				{
					yaw_left=0;
				}

				#Roll engines
				roll_left=roll_cmd*command_factor;
				if (roll_left>1)
				{
					roll_left=1;
				}
				if (roll_left<0)
				{
					roll_left=0;
				}
				roll_right=-roll_cmd*command_factor;
				if (roll_right>1)
				{
					roll_right=1;
				}
				if (roll_right<0)
				{
					roll_right=0;
				}
			}

			setprop("fdm/jsbsim/systems/tdu_computer/pitch-forward", pitch_forward);
			setprop("fdm/jsbsim/systems/tdu_computer/pitch-back", pitch_back);

			setprop("fdm/jsbsim/systems/tdu_computer/yaw-left", yaw_left);
			setprop("fdm/jsbsim/systems/tdu_computer/yaw-right", yaw_right);

			setprop("fdm/jsbsim/systems/tdu_computer/roll-forward-left", roll_left);
			setprop("fdm/jsbsim/systems/tdu_computer/roll-back-right", roll_left);
			setprop("fdm/jsbsim/systems/tdu_computer/roll-forward-right", roll_right);
			setprop("fdm/jsbsim/systems/tdu_computer/roll-back-left", roll_right);

			setprop("fdm/jsbsim/systems/tdu_computer/previous-time", current_time);
		}
		settimer(computer, repeat_time);
	}

# set startup configuration
init_computer=func
	{
		setprop("fdm/jsbsim/systems/tdu_computer/serviceable", 1);
		setprop("fdm/jsbsim/systems/tdu_computer/on", 1);
		setprop("fdm/jsbsim/systems/tdu_computer/stabilize", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/repeat-time", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/previous-time", 0);
	
		setprop("fdm/jsbsim/systems/tdu_computer/pitch-rad", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/yaw-rad", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/roll-rad", 0);

		setprop("fdm/jsbsim/systems/tdu_computer/pitch-forward", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/pitch-back", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/yaw-left", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/yaw-right", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/roll-forward-left", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/roll-back-right", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/roll-forward-right", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/roll-back-left", 0);
	}

# set startup configuration
start_computer=func
{
	init_computer();
	var time_elapsed=getprop("fdm/jsbsim/simulation/sim-time-sec");
	if (time_elapsed!=nil)
	{
		if (time_elapsed>0)
		{
			computer();
		}
		else
		{
			return ( settimer(start_computer, 0.1) ); 
		}
	}
	else
	{
		return ( settimer(start_computer, 0.1) ); 
	}
}
