#
# Author: Slavutinsky Victor
#

# Crash crashes. Gives a message and stops simulation if crash occured

#crashes.init_crashes(); gotta be called on manual aircraft restart

# helper 
var end_crashes = func 
	{
	}

var crashes = func 
	{
		var in_service = getprop("fdm/jsbsim/systems/crashes/serviceable" );
		if (in_service == nil)
		{
			end_crashes();
			return ( settimer(crashes, 0.1) ); 
		}
		if ( in_service != 1 )
		{
			end_crashes();
			return ( settimer(crashes, 0.1) ); 
		}
		var repeat_time=getprop("fdm/jsbsim/systems/crashes/repeat-time");

		var g_force=getprop("fdm/jsbsim/accelerations/Nz");
		var mach=getprop("fdm/jsbsim/velocities/mach");
		var speed=getprop("fdm/jsbsim/velocities/vt-fps");
		var vertical_speed=getprop("fdm/jsbsim/velocities/v-down-fps");
		var altitude=getprop("fdm/jsbsim/position/h-sl-ft");
		var altitude_ground=getprop("fdm/jsbsim/position/h-agl-ft");
		var qbar=getprop("fdm/jsbsim/aero/qbar-modified-kgm2");
		var maximum_altitude_ft=getprop("fdm/jsbsim/aero/maximum-altitude-ft");
		var p_rad_sec=getprop("fdm/jsbsim/velocities/p-aero-rad_sec");
		var q_rad_sec=getprop("fdm/jsbsim/velocities/q-aero-rad_sec");
		var r_rad_sec=getprop("fdm/jsbsim/velocities/r-aero-rad_sec");
		var ground_contact=getprop("fdm/jsbsim/systems/spacecraft/ground-contact");

		var stage_active=[0,0,0,0,0,0];
		stage_active[0]=getprop("fdm/jsbsim/stages/unit[0]/active");
		stage_active[1]=getprop("fdm/jsbsim/stages/unit[1]/active");
		stage_active[2]=getprop("fdm/jsbsim/stages/unit[2]/active");
		stage_active[3]=getprop("fdm/jsbsim/stages/unit[3]/active");
		stage_active[4]=getprop("fdm/jsbsim/stages/unit[4]/active");
		stage_active[5]=getprop("fdm/jsbsim/stages/unit[5]/active");

		var stage_ignited=[0,0,0,0,0,0];
		stage_ignited[0]=getprop("fdm/jsbsim/stages/unit[0]/ignited");
		stage_ignited[1]=getprop("fdm/jsbsim/stages/unit[1]/ignited");
		stage_ignited[2]=getprop("fdm/jsbsim/stages/unit[2]/ignited");
		stage_ignited[3]=getprop("fdm/jsbsim/stages/unit[3]/ignited");
		stage_ignited[4]=getprop("fdm/jsbsim/stages/unit[4]/ignited");
		stage_ignited[5]=getprop("fdm/jsbsim/stages/unit[5]/ignited");

		var chute_cover_dropped=getprop("fdm/jsbsim/systems/spacecraft/chute-cover-dropped");
		var brake_chute_extracted=getprop("fdm/jsbsim/systems/spacecraft/brake-chute-extracted");
		var brake_chute_dropped=getprop("fdm/jsbsim/systems/spacecraft/brake-chute-dropped");
		var brake_chute_teared=getprop("fdm/jsbsim/systems/spacecraft/brake-chute-teared");
		var brake_qbar_max=getprop("fdm/jsbsim/systems/spacecraft/brake-qbar-max");
		var brake_rot_max=getprop("fdm/jsbsim/systems/spacecraft/brake-rot-max");
		var main_chute_extracted=getprop("fdm/jsbsim/systems/spacecraft/main-chute-extracted");
		var main_chute_dropped=getprop("fdm/jsbsim/systems/spacecraft/main-chute-dropped");
		var main_chute_teared=getprop("fdm/jsbsim/systems/spacecraft/main-chute-teared");
		var main_qbar_max=getprop("fdm/jsbsim/systems/spacecraft/main-qbar-max");
		var landing_engine_set=getprop("fdm/jsbsim/systems/spacecraft/landing-engine-set");
		var engine_sensor_teared=getprop("fdm/jsbsim/systems/spacecraft/engine-sensor-teared");
		var engine_qbar_max=getprop("fdm/jsbsim/systems/spacecraft/engine-qbar-max");
		var engine_rot_max=getprop("fdm/jsbsim/systems/spacecraft/engine-rot-max");

		var g_allowed=[0,0,0,0,0,0];
		g_allowed[0]=getprop("fdm/jsbsim/stages/unit[0]/g-allowed");
		g_allowed[1]=getprop("fdm/jsbsim/stages/unit[1]/g-allowed");
		g_allowed[2]=getprop("fdm/jsbsim/stages/unit[2]/g-allowed");
		g_allowed[3]=getprop("fdm/jsbsim/stages/unit[3]/g-allowed");
		g_allowed[4]=getprop("fdm/jsbsim/stages/unit[4]/g-allowed");
		g_allowed[5]=getprop("fdm/jsbsim/stages/unit[5]/g-allowed");

		var g_break_psec=[0,0,0,0,0,0];
		g_break_psec[0]=getprop("fdm/jsbsim/stages/unit[0]/g-break-psec");
		g_break_psec[1]=getprop("fdm/jsbsim/stages/unit[1]/g-break-psec");
		g_break_psec[2]=getprop("fdm/jsbsim/stages/unit[2]/g-break-psec");
		g_break_psec[3]=getprop("fdm/jsbsim/stages/unit[3]/g-break-psec");
		g_break_psec[4]=getprop("fdm/jsbsim/stages/unit[4]/g-break-psec");
		g_break_psec[5]=getprop("fdm/jsbsim/stages/unit[5]/g-break-psec");

		var qbar_allowed=[0,0,0,0,0,0];
		qbar_allowed[0]=getprop("fdm/jsbsim/stages/unit[0]/qbar-allowed-kgm2");
		qbar_allowed[1]=getprop("fdm/jsbsim/stages/unit[1]/qbar-allowed-kgm2");
		qbar_allowed[2]=getprop("fdm/jsbsim/stages/unit[2]/qbar-allowed-kgm2");
		qbar_allowed[3]=getprop("fdm/jsbsim/stages/unit[3]/qbar-allowed-kgm2");
		qbar_allowed[4]=getprop("fdm/jsbsim/stages/unit[4]/qbar-allowed-kgm2");
		qbar_allowed[5]=getprop("fdm/jsbsim/stages/unit[5]/qbar-allowed-kgm2");

		var qbar_break_psec=[0,0,0,0,0,0];
		qbar_break_psec[0]=getprop("fdm/jsbsim/stages/unit[0]/g-break-psec");
		qbar_break_psec[1]=getprop("fdm/jsbsim/stages/unit[1]/g-break-psec");
		qbar_break_psec[2]=getprop("fdm/jsbsim/stages/unit[2]/g-break-psec");
		qbar_break_psec[3]=getprop("fdm/jsbsim/stages/unit[3]/g-break-psec");
		qbar_break_psec[4]=getprop("fdm/jsbsim/stages/unit[4]/g-break-psec");
		qbar_break_psec[5]=getprop("fdm/jsbsim/stages/unit[5]/g-break-psec");

		var stage_broken=[0,0,0,0,0,0];
		stage_broken[0]=getprop("fdm/jsbsim/stages/unit[0]/broken");
		stage_broken[1]=getprop("fdm/jsbsim/stages/unit[1]/broken");
		stage_broken[2]=getprop("fdm/jsbsim/stages/unit[2]/broken");
		stage_broken[3]=getprop("fdm/jsbsim/stages/unit[3]/broken");
		stage_broken[4]=getprop("fdm/jsbsim/stages/unit[4]/broken");
		stage_broken[5]=getprop("fdm/jsbsim/stages/unit[5]/broken");

		var first_broken_block=[0,0,0,0];
		first_broken_block[0]=getprop("fdm/jsbsim/stages/unit[0]/broken-block[0]");
		first_broken_block[1]=getprop("fdm/jsbsim/stages/unit[0]/broken-block[1]");
		first_broken_block[2]=getprop("fdm/jsbsim/stages/unit[0]/broken-block[2]");
		first_broken_block[3]=getprop("fdm/jsbsim/stages/unit[0]/broken-block[3]");

		var spacecraft_broken_part=[0,0,0,0];
		spacecraft_broken_part[0]=getprop("fdm/jsbsim/stages/unit[5]/broken-part[0]");
		spacecraft_broken_part[1]=getprop("fdm/jsbsim/stages/unit[5]/broken-part[1]");
		spacecraft_broken_part[2]=getprop("fdm/jsbsim/stages/unit[5]/broken-part[2]");
		spacecraft_broken_part[3]=getprop("fdm/jsbsim/stages/unit[5]/broken-part[3]");

		var sim_clock=getprop("sim/freeze/clock");
		var sim_master=getprop("sim/freeze/master");

		var simulation_time=getprop("fdm/jsbsim/sim-time-sec");
		var prev_time=getprop("fdm/jsbsim/systems/crashes/prev-time");

		if (
			(repeat_time==nil)

			or (g_force==nil)
			or (mach==nil)
			or (speed==nil)
			or (vertical_speed==nil)
			or (altitude==nil)
			or (altitude_ground==nil)
			or (qbar==nil)
			or (maximum_altitude_ft==nil)
			or (p_rad_sec==nil)
			or (q_rad_sec==nil)
			or (r_rad_sec==nil)
			or (ground_contact==nil)

			or (stage_active[0]==nil)
			or (stage_active[1]==nil)
			or (stage_active[2]==nil)
			or (stage_active[3]==nil)
			or (stage_active[4]==nil)
			or (stage_active[5]==nil)

			or (stage_ignited[0]==nil)
			or (stage_ignited[1]==nil)
			or (stage_ignited[2]==nil)
			or (stage_ignited[3]==nil)
			or (stage_ignited[4]==nil)
			or (stage_ignited[5]==nil)

			or (chute_cover_dropped==nil)
			or (brake_chute_extracted==nil)
			or (brake_chute_dropped==nil)
			or (brake_chute_teared==nil)
			or (brake_qbar_max==nil)
			or (brake_rot_max==nil)
			or (main_chute_extracted==nil)
			or (main_chute_dropped==nil)
			or (main_chute_teared==nil)
			or (main_qbar_max==nil)
			or (landing_engine_set==nil)
			or (engine_sensor_teared==nil)
			or (engine_qbar_max==nil)
			or (engine_rot_max==nil)

			or (g_allowed[0]==nil)
			or (g_allowed[1]==nil)
			or (g_allowed[2]==nil)
			or (g_allowed[3]==nil)
			or (g_allowed[4]==nil)
			or (g_allowed[5]==nil)

			or (g_break_psec[0]==nil)
			or (g_break_psec[1]==nil)
			or (g_break_psec[2]==nil)
			or (g_break_psec[3]==nil)
			or (g_break_psec[4]==nil)
			or (g_break_psec[5]==nil)

			or (qbar_allowed[0]==nil)
			or (qbar_allowed[1]==nil)
			or (qbar_allowed[2]==nil)
			or (qbar_allowed[3]==nil)
			or (qbar_allowed[4]==nil)
			or (qbar_allowed[5]==nil)

			or (qbar_break_psec[0]==nil)
			or (qbar_break_psec[1]==nil)
			or (qbar_break_psec[2]==nil)
			or (qbar_break_psec[3]==nil)
			or (qbar_break_psec[4]==nil)
			or (qbar_break_psec[5]==nil)

			or (stage_broken[0]==nil)
			or (stage_broken[1]==nil)
			or (stage_broken[2]==nil)
			or (stage_broken[3]==nil)
			or (stage_broken[4]==nil)
			or (stage_broken[5]==nil)

			or (first_broken_block[0]==nil)
			or (first_broken_block[1]==nil)
			or (first_broken_block[2]==nil)
			or (first_broken_block[3]==nil)

			or (spacecraft_broken_part[0]==nil)
			or (spacecraft_broken_part[1]==nil)
			or (spacecraft_broken_part[2]==nil)
			or (spacecraft_broken_part[3]==nil)

			or (sim_clock==nil)
			or (sim_master==nil)

			or (simulation_time==nil)
			or (prev_time==nil)

		)
		{
			end_crashes();
			setprop("fdm/jsbsim/systems/crashes/error", 1);
			return ( settimer(crashes, 0.1) ); 
		}
		setprop("fdm/jsbsim/systems/crashes/error", 0);

		#Time check

		if (simulation_time<prev_time)
		{
			setprop("fdm/jsbsim/systems/crashes/prev-time", simulation_time);
		}

		#Breakages

		#g force breakages

		var g_break_probability=0;
		var qbar_break_probability=0;
		var random_value=0;

		for (var i=0; i<5; i=i+1)
		{

			if (
				(stage_active[i]==1)
				and (
					(g_force>g_allowed[i])
					or (qbar>qbar_allowed[i])
				)
				and (
					(i!=4)
					or (stage_active[1]==1)
					or (stage_active[5]==1)
					or (stage_broken[4]==1)
				)
			)
			{
				random_value=rand();
				g_break_probability=g_break_psec[i]*(simulation_time-prev_time);
				qbar_break_probability=qbar_break_psec[i]*(simulation_time-prev_time);
				if (
					(random_value<g_break_probability)
					or (random_value<qbar_break_probability)
				)
				{
					setprop("fdm/jsbsim/stages/unit["~i~"]/broken", 1);
					if (i==0)
					{
						var block_founded=0;
						var preferred_block=int(rand()*4);
						var j=0;
						for (j=0; j<3; j=j+1)
						{
							if (
								(j==preferred_block)
								and (first_broken_block[j]==0)
								and (block_founded==0)
							)
							{
								first_broken_block[j]=1;
								block_founded=1;
								setprop("fdm/jsbsim/stages/unit[0]/broken-block["~j~"]", 1);
							}
						}
						if (block_founded==0)
						{
							for (j=preferred_block; j<3; j=j+1)
							{
								if (
									(first_broken_block[j]==0)
									and (block_founded==0)
								)
								{
									first_broken_block[j]=1;
									block_founded=1;
									setprop("fdm/jsbsim/stages/unit[0]/broken-block["~j~"]", 1);
								}
							}
						}
						if (block_founded==0)
						{
							for(j=preferred_block; j>0; j=j-1)
							{
								if (
									(first_broken_block[j]==0)
									and (block_founded==0)
								)
								{
									first_broken_block[j]=1;
									block_founded=1;
									setprop("fdm/jsbsim/stages/unit[0]/broken-block["~j~"]", 1);
								}
							}
						}
					}
				}
			}
		}

		#Third stage too low ignition breakage

		if (
			(qbar>100)
			and (stage_active[3]==1)
			and (stage_ignited[3]==1)
			and (stage_broken[3]==0)
		)
		{
			setprop("fdm/jsbsim/stages/unit[3]/ignited", 0);
			setprop("fdm/jsbsim/stages/unit[3]/broken", 1);
		}

		#Brake chute breakage

		if (
			(stage_active[5]==1)
			and (brake_chute_extracted==1)
			and (brake_chute_dropped==0)
			and (brake_chute_teared==0)
			and (qbar>brake_qbar_max)
		)
		{
			setprop("fdm/jsbsim/systems/spacecraft/brake-chute-teared", 1);
			setprop("fdm/jsbsim/stages/unit[5]/ignited", 0);
			setprop("fdm/jsbsim/stages/unit[5]/broken", 1);
		}

		#Main chute breakage

		if (
			(stage_active[5]==1)
			and (main_chute_extracted==1)
			and (main_chute_dropped==0)
			and (main_chute_teared==0)
			and (
				(qbar>main_qbar_max)
				or (brake_chute_teared==1)
			)
		)
		{
			setprop("fdm/jsbsim/systems/spacecraft/main-chute-teared", 1);
			setprop("fdm/jsbsim/stages/unit[5]/ignited", 0);
			setprop("fdm/jsbsim/stages/unit[5]/broken", 1);
		}

		#Landing engine sensor qbar breakage

		if (
			(stage_active[5]==1)
			and (landing_engine_set==1)
			and (engine_sensor_teared==0)
			and (
				(qbar>engine_qbar_max)
				or (p_rad_sec>engine_rot_max)
				or (q_rad_sec>engine_rot_max)
				or (r_rad_sec>engine_rot_max)
			)
		)
		{
			setprop("fdm/jsbsim/systems/spacecraft/engine-sensor-teared", 1);
			if (ground_contact==0)
			{
				setprop("fdm/jsbsim/stages/unit[5]/ignited", 0);
				setprop("fdm/jsbsim/stages/unit[5]/broken", 1);
			}
		}

		#Crashes

		if (g_force>15)
		{
			setprop("fdm/jsbsim/systems/crashes/crashed", 1);
			setprop("fdm/jsbsim/systems/crashes/crash-type", "G force exceeds 15");
			crash("G force exceeds 15", "Uskorenie prevysilo 15");
		}

		if (g_force<-5)
		{
			setprop("fdm/jsbsim/systems/crashes/crashed", 1);
			setprop("fdm/jsbsim/systems/crashes/crash-type", "G force exceeds -5");
			crash("G force exceeds -5", "Uskorenie prevysilo -5");
		}

		if (altitude>maximum_altitude_ft)
		{
			setprop("fdm/jsbsim/systems/crashes/crashed", 1);
			setprop("fdm/jsbsim/systems/crashes/crash-type", "Alititude exceeds "~(maximum_altitude_ft*0.3048/1000)~"km");
			crash("Alititude exceeds "~(maximum_altitude_ft*0.3048/1000)~"km", "Vysota prevysila "~(maximum_altitude_ft*0.3048/1000)~"km");
		}

		if (
			((altitude_ground-vertical_speed*5)<0)
			and (speed>200)
			and (altitude<30000)
			and (altitude_ground<3280)
		)
		{
			setprop("fdm/jsbsim/systems/crashes/crashed", 1);
			setprop("fdm/jsbsim/systems/crashes/crash-type", "Craft hits the ground");
			crash("Craft hits the ground", "Korabl' udarilsya o Zemlu");
		}

		if (
			(stage_ignited[4]==1)
			and (stage_broken[4]==1)
		)
		{
			setprop("fdm/jsbsim/systems/crashes/crashed", 1);
			setprop("fdm/jsbsim/systems/crashes/crash-type", "TDU exploded");
			crash("TDU exploded", "TDU vzorvalsya");
		}

		setprop("fdm/jsbsim/systems/crashes/prev-time", simulation_time);

		settimer(crashes, repeat_time);
	}

var crash=func(crash_message, crash_russian_message)
	{

		var crashed=getprop("fdm/jsbsim/systems/crashes/crashed");

		if (crashed!=nil)
		{
			var window=screen.window.new();
			if (window!=nil)
			{
				window.fg = [.3, .5, .7, .9];
				window.write(crash_message);
				window.write(crash_russian_message);
				window.write("Please restart simulator by Reset menu");
				window.write("Pojaluista peresapustite simulator cheres punkt menu Reset");
			}
			settimer(simulation_pause, 0.1);
		}
	}

var simulation_pause=func
	{
		setprop("sim/replay/disable", 1);
		setprop("sim/freeze/clock", 1);
		setprop("sim/freeze/master", 1);
		setprop("fdm/jsbsim/systems/crashes/crashed", 1);
	}

var breakage=func(breakage_message, breakage_russian_message)
	{

		var window=screen.window.new();
		if (window!=nil)
		{
			window.fg = [.3, .5, .7, .9];
			window.write(breakage_message);
			window.write(breakage_russian_message);
		}

	}

# set startup configuration
var init_crashes=func
	{
		setprop("fdm/jsbsim/systems/crashes/serviceable", 1);
		setprop("fdm/jsbsim/systems/crashes/crashed", 0);
		setprop("fdm/jsbsim/systems/crashes/repeat-time", 0);
	}

# set startup configuration
var start_crashes=func
{
	init_crashes();
	var time_elapsed=getprop("fdm/jsbsim/simulation/sim-time-sec");
	if (time_elapsed!=nil)
	{
		if (time_elapsed>0)
		{
			crashes();
		}
		else
		{
			return ( settimer(start_crashes, 0.1) ); 
		}
	}
	else
	{
		return ( settimer(start_crashes, 0.1) ); 
	}
}
