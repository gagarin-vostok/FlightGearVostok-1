#
# Author: Slavutinsky Victor
#

# First stage computer
# Accouts changes of first stage engine angles
# due to control position
# weights and tanks contents

#first_computer.init_computer(); gotta be called on manual aircraft restart

# helper 
stop_computer = func 
	{
	}

computer = func 
	{
		var in_service = getprop("fdm/jsbsim/stages/unit[2]/computer/serviceable" );
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
		var on=getprop("fdm/jsbsim/stages/unit[2]/computer/on");

		var handle_button=getprop("fdm/jsbsim/systems/controlhandle/button-switch");
		var stabilize=getprop("fdm/jsbsim/stages/unit[2]/computer/stabilize");

		var current_time=getprop("fdm/jsbsim/sim-time-sec");
		var previous_time=getprop("fdm/jsbsim/stages/unit[2]/computer/previous-time");
		var repeat_time=getprop("fdm/jsbsim/stages/unit[2]/computer/repeat-time");

		var aileron_cmd=getprop("fdm/jsbsim/systems/controlhandle/aileron-pos");
		var elevator_cmd=getprop("fdm/jsbsim/systems/controlhandle/elevator-pos");
		var rudder_cmd=getprop("fdm/jsbsim/systems/controlhandle/rudder-pos");

		var pitch_rad=getprop("fdm/jsbsim/stages/unit[2]/computer/pitch-rad");
		var roll_rad=getprop("fdm/jsbsim/stages/unit[2]/computer/roll-rad");
		var yaw_rad=getprop("fdm/jsbsim/stages/unit[2]/computer/yaw-rad");

	#Note what axises rotated and roll and yaw speeds swapped

		var pitch_speed=getprop("fdm/jsbsim/velocities/q-rad_sec");
		var roll_speed=getprop("fdm/jsbsim/velocities/r-rad_sec");
		var yaw_speed=getprop("fdm/jsbsim/velocities/p-rad_sec");

		var stage_active=getprop("fdm/jsbsim/stages/unit[2]/active");

		var tank=[0,0,0,0,0,0,0,0,0,0,0,0];
		tank[0]=getprop("fdm/jsbsim/propulsion/tank[0]/contents-lbs");
		tank[1]=getprop("fdm/jsbsim/propulsion/tank[1]/contents-lbs");
		tank[2]=getprop("fdm/jsbsim/propulsion/tank[2]/contents-lbs");
		tank[3]=getprop("fdm/jsbsim/propulsion/tank[3]/contents-lbs");
		tank[4]=getprop("fdm/jsbsim/propulsion/tank[4]/contents-lbs");
		tank[5]=getprop("fdm/jsbsim/propulsion/tank[5]/contents-lbs");
		tank[6]=getprop("fdm/jsbsim/propulsion/tank[6]/contents-lbs");
		tank[7]=getprop("fdm/jsbsim/propulsion/tank[7]/contents-lbs");
		tank[8]=getprop("fdm/jsbsim/propulsion/tank[8]/contents-lbs");
		tank[9]=getprop("fdm/jsbsim/propulsion/tank[9]/contents-lbs");
		tank[10]=getprop("fdm/jsbsim/propulsion/tank[10]/contents-lbs");
		tank[11]=getprop("fdm/jsbsim/propulsion/tank[11]/contents-lbs");

		var weight=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		weight[0]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[0]");
		weight[1]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[1]");
		weight[2]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[2]");
		weight[3]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[3]");
		weight[4]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]");
		weight[5]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[5]");
		weight[6]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[6]");
		weight[7]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[7]");
		weight[8]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[8]");
		weight[9]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[9]");
		weight[10]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[10]");
		weight[11]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[11]");
		weight[12]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[12]");
		weight[13]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[13]");
		weight[14]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[14]");
		weight[15]=getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[15]");

		pitch_factor=getprop("fdm/jsbsim/stages/unit[2]/computer/pitch-factor");
		pitch_speed_factor=getprop("fdm/jsbsim/stages/unit[2]/computer/pitch-speed-factor");
		pitch_speed_limit=getprop("fdm/jsbsim/stages/unit[2]/computer/pitch-speed-limit");

		roll_factor=getprop("fdm/jsbsim/stages/unit[2]/computer/roll-factor");
		roll_speed_factor=getprop("fdm/jsbsim/stages/unit[2]/computer/roll-speed-factor");
		roll_speed_limit=getprop("fdm/jsbsim/stages/unit[2]/computer/roll-speed-limit");

		if ((on==nil)
			or (stage_active==nil)
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

			or (tank[0]==nil)
			or (tank[1]==nil)
			or (tank[2]==nil)
			or (tank[3]==nil)
			or (tank[4]==nil)
			or (tank[5]==nil)
			or (tank[6]==nil)
			or (tank[7]==nil)
			or (tank[8]==nil)
			or (tank[9]==nil)
			or (tank[10]==nil)
			or (tank[11]==nil)

			or (weight[0]==nil)
			or (weight[1]==nil)
			or (weight[2]==nil)
			or (weight[3]==nil)
			or (weight[4]==nil)
			or (weight[5]==nil)
			or (weight[6]==nil)
			or (weight[7]==nil)
			or (weight[8]==nil)
			or (weight[9]==nil)
			or (weight[10]==nil)
			or (weight[11]==nil)
			or (weight[12]==nil)
			or (weight[13]==nil)
			or (weight[14]==nil)
			or (weight[15]==nil)

			or (pitch_factor==nil)
			or (pitch_speed_factor==nil)
			or (pitch_speed_limit==nil)

			or (roll_factor==nil)
			or (roll_speed_factor==nil)
			or (roll_speed_limit==nil)

			)
		{
			stop_computer();
			setprop("fdm/jsbsim/stages/unit[2]/computer/error", 1);
			return ( settimer(computer, 0.1) ); 
		}
		if (on==0)
		{
			stop_computer();
			setprop("fdm/jsbsim/stages/unit[2]/computer/error", 2);
			return ( settimer(computer, 0.1) ); 
		}
		setprop("fdm/jsbsim/stages/unit[2]/computer/error", 0);
		if (previous_time==0)
		{
			previous_time=current_time;
			setprop("fdm/jsbsim/stages/unit[2]/computer/previous-time", previous_time);
		}
		if (current_time>previous_time)
		{

			#Account mass moments for correct egines angles account
			#Because FG do not translate all JSB properties it's needed to add constants in text anyway

			#Note, if mass account is too complicated for You You can check angular speed as angle lock

			var roll_moment_quote=
			(
				(weight[0]+weight[1]+weight[2]+weight[3])*105.94+
				(weight[4]+weight[5]+weight[6]+weight[7])*101.574+

				(weight[8]+weight[9])*15.05+
				(weight[10]+weight[11])*50.82+
				(weight[12]+weight[13])*35.27+
				(weight[14]+weight[15])*51.29+

				(tank[0]+tank[2]+tank[4]+tank[6])*84.52+
				(tank[1]+tank[3]+tank[5]+tank[7])*90.39+
				(tank[8]+tank[9])*26.96+
				(tank[10]+tank[11])*21.53
			)
			/
			(
				(2623.0*4)*105.94+
				(5643.0*4)*101.574+

				(1408.0*2)*15.05+
				(6748.0*2)*50.82+
				(13828.0*2)*35.27+
				(716.50*2)*51.29+

				(61147.0*4)*84.52+
				(24724.0*4)*90.39+
				(71633.0*2)*26.96+
				(29359.0*2)*21.53
			);
			roll_moment_quote=roll_moment_quote*(3.813+1.125)/(1.125);

			setprop("fdm/jsbsim/stages/unit[2]/computer/roll-moment-quote", roll_moment_quote);

			var pitch_yaw_moment_quote=(
				(weight[0]+weight[1]+weight[2]+weight[3])*562.03+
				(weight[4]+weight[5]+weight[6]+weight[7])*343.3+

				(weight[8]+weight[9])*562.03+
				(weight[10]+weight[11])*97.83+
				(weight[12]+weight[13])*685.35+
				(weight[14]+weight[15])*772.986+

				(tank[0]+tank[2]+tank[4]+tank[6])*151.2+
				(tank[1]+tank[3]+tank[5]+tank[7])*331.64+
				(tank[8]+tank[9])*330.17+
				(tank[10]+tank[11])*146.28
			)
			/
			(
				(2623.0*4)*562.03+
				(5643.0*4)*343.3+

				(1408.0*2)*562.03+
				(6748.0*2)*97.83+
				(13828.0*2)*685.35+
				(716.50*2)*772.986+

				(61147.0*4)*151.2+
				(24724.0*4)*331.64+
				(71633.0*2)*330.17+
				(29359.0*2)*146.28
			);
			pitch_yaw_moment_quote=pitch_yaw_moment_quote*4;

			setprop("fdm/jsbsim/stages/unit[2]/computer/pitch-yaw-moment-quote", pitch_yaw_moment_quote);

			#Cosmonaut controlled command angles
			var aileron_cmd_rad=0;
			var elevator_cmd_rad=0;
			var rudder_cmd_rad=0;
			if (handle_button==0)
			{
				aileron_cmd_rad=aileron_cmd*math.pi/4;
				elevator_cmd_rad=elevator_cmd*math.pi/4;
				rudder_cmd_rad=rudder_cmd*math.pi/4;
			}

			#Stored angles for auto control system
			if (aileron_cmd_rad==0)
			{
				roll_rad=roll_rad+roll_speed*(current_time-previous_time);
			}
			else
			{
				roll_rad=0;
			}

			if (elevator_cmd_rad==0)
			{
				pitch_rad=pitch_rad+pitch_speed*(current_time-previous_time);
			}
			else
			{
				pitch_rad=0;
			}

			if (rudder_cmd_rad==0)
			{
				yaw_rad=yaw_rad+yaw_speed*(current_time-previous_time);
			}
			else
			{
				yaw_rad=0;
			}
			setprop("fdm/jsbsim/stages/unit[2]/computer/roll-rad", roll_rad);
			setprop("fdm/jsbsim/stages/unit[2]/computer/pitch-rad", pitch_rad);
			setprop("fdm/jsbsim/stages/unit[2]/computer/yaw-rad", yaw_rad);

				#Account command angles

				#Command roll
				var roll_cmd_rad=0;
				if (stage_active==1)
				{
					if (aileron_cmd_rad==0)
					{
						roll_cmd_rad=-roll_rad*roll_factor-roll_speed_factor*roll_speed*(current_time-previous_time);
					}
					else
					{
						roll_cmd_rad=aileron_cmd_rad;
					}
					#Limit angle speed
					if (math.abs(roll_speed)>(roll_speed_limit/180*math.pi))
					{
						roll_cmd_rad=roll_cmd_rad-roll_speed_factor*roll_speed*(current_time-previous_time);
					}
					roll_cmd_rad=roll_cmd_rad*roll_moment_quote;
				}
				setprop("fdm/jsbsim/stages/unit[2]/computer/cmd-roll-rad", roll_cmd_rad);

				#Command pitch
				var pitch_cmd_rad=0;
				if (stage_active==1)
				{
					if (elevator_cmd_rad==0)
					{
						#Axis is inverted
						pitch_cmd_rad=pitch_rad*pitch_factor+pitch_speed_factor*pitch_speed*(current_time-previous_time);
					}
					else
					{
						pitch_cmd_rad=elevator_cmd_rad;
					}
					#Limit angle speed
					if (math.abs(pitch_speed)>(pitch_speed_limit/180*math.pi))
					{
						pitch_cmd_rad=pitch_cmd_rad+pitch_speed_factor*pitch_speed*(current_time-previous_time);
					}
					pitch_cmd_rad=pitch_cmd_rad*pitch_yaw_moment_quote;
				}
				setprop("fdm/jsbsim/stages/unit[2]/computer/cmd-pitch-rad", pitch_cmd_rad);
				setprop("fdm/jsbsim/stages/unit[2]/computer/pitch-cmd-norm", elevator_cmd);

				#Command yaw
				var yaw_cmd_rad=0;
				if (stage_active==1)
				{
					if (rudder_cmd_rad==0)
					{
						#As addition, axis is inverted
						yaw_cmd_rad=yaw_rad*pitch_factor+pitch_speed_factor*yaw_speed*(current_time-previous_time);
					}
					else
					{
						yaw_cmd_rad=rudder_cmd_rad;
					}
					#Limit angle speed
					if (math.abs(yaw_speed)>(pitch_speed_limit/180*math.pi))
					{
						yaw_cmd_rad=yaw_cmd_rad+pitch_speed_factor*yaw_speed*(current_time-previous_time);
					}
					yaw_cmd_rad=yaw_cmd_rad*pitch_yaw_moment_quote;
				}
				setprop("fdm/jsbsim/stages/unit[2]/computer/cmd-yaw-rad", yaw_cmd_rad);

				#Real engines angles

				#Forward engine
				var forward_engine_rad=-yaw_cmd_rad-roll_cmd_rad;
				if (forward_engine_rad>(math.pi/4))
				{
					forward_engine_rad=math.pi/4;
				}
				if (forward_engine_rad<(-math.pi/4))
				{
					forward_engine_rad=-math.pi/4;
				}
				setprop("fdm/jsbsim/stages/unit[2]/computer/forward-engine-rad", forward_engine_rad);

				#Back engine
				var back_engine_rad=yaw_cmd_rad-roll_cmd_rad;
				if (back_engine_rad>(math.pi/4))
				{
					back_engine_rad=math.pi/4;
				}
				if (back_engine_rad<(-math.pi/4))
				{
					back_engine_rad=-math.pi/4;
				}
				setprop("fdm/jsbsim/stages/unit[2]/computer/back-engine-rad", back_engine_rad);

				#Left engine
				var left_engine_rad=pitch_cmd_rad-roll_cmd_rad;
				if (left_engine_rad>(math.pi/4))
				{
					left_engine_rad=math.pi/4;
				}
				if (left_engine_rad<(-math.pi/4))
				{
					left_engine_rad=-math.pi/4;
				}
				setprop("fdm/jsbsim/stages/unit[2]/computer/left-engine-rad", left_engine_rad);


				#Right engine
				var right_engine_rad=-pitch_cmd_rad-roll_cmd_rad;
				if (right_engine_rad>(math.pi/4))
				{
					right_engine_rad=math.pi/4;
				}
				if (right_engine_rad<(-math.pi/4))
				{
					right_engine_rad=-math.pi/4;
				}
				setprop("fdm/jsbsim/stages/unit[2]/computer/right-engine-rad", right_engine_rad);

			setprop("fdm/jsbsim/stages/unit[2]/computer/previous-time", current_time);
		}
		settimer(computer, repeat_time);
	}

# set startup configuration
init_computer=func
	{
		setprop("fdm/jsbsim/stages/unit[2]/computer/serviceable", 1);
		setprop("fdm/jsbsim/stages/unit[2]/computer/on", 1);
		setprop("fdm/jsbsim/stages/unit[2]/computer/stabilize", 0);
		setprop("fdm/jsbsim/stages/unit[2]/computer/repeat-time", 0);
		setprop("fdm/jsbsim/stages/unit[2]/computer/previous-time", 0);
	
		setprop("fdm/jsbsim/stages/unit[2]/computer/pitch-rad", 0);
		setprop("fdm/jsbsim/stages/unit[2]/computer/yaw-rad", 0);
		setprop("fdm/jsbsim/stages/unit[2]/computer/roll-rad", 0);

		setprop("fdm/jsbsim/stages/unit[2]/computer/pitch-factor", 4);
		setprop("fdm/jsbsim/stages/unit[2]/computer/pitch-speed-factor", 100);
		setprop("fdm/jsbsim/stages/unit[2]/computer/pitch-speed-limit", 5);

		setprop("fdm/jsbsim/stages/unit[2]/computer/roll-factor", 1);
		setprop("fdm/jsbsim/stages/unit[2]/computer/roll-speed-factor", 10);
		setprop("fdm/jsbsim/stages/unit[2]/computer/roll-speed-limit", 5);

		setprop("fdm/jsbsim/stages/unit[2]/computer/right-engine-rad", 0);
		setprop("fdm/jsbsim/stages/unit[2]/right-engine-delayed-rad", 0);
		setprop("fdm/jsbsim/stages/unit[2]/right-engine-rotated-rad", 0);
		setprop("fdm/jsbsim/stages/unit[2]/computer/left-engine-rad", 0);
		setprop("fdm/jsbsim/stages/unit[2]/left-engine-delayed-rad", 0);
		setprop("fdm/jsbsim/stages/unit[2]/left-engine-rotated-rad", 0);
		setprop("fdm/jsbsim/stages/unit[2]/computer/forward-engine-rad", 0);
		setprop("fdm/jsbsim/stages/unit[2]/forward-engine-delayed-rad", 0);
		setprop("fdm/jsbsim/stages/unit[2]/computer/back-engine-rad", 0);
		setprop("fdm/jsbsim/stages/unit[2]/back-engine-delayed-rad", 0);
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
