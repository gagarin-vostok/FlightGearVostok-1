#
# Author: Slavutinsky Victor
#

# Stages stages. Change weights, points of view, inital fuel tanks contents due to stages change.
# Currently active stages is setted as 1.

#stages.init_stages(); gotta be called on manual aircraft restart

# helper 
var end_stages = func 
	{
	}

var stages = func 
	{
		var in_service = getprop("fdm/jsbsim/stages/serviceable" );
		if (in_service == nil)
		{
			end_stages();
			return ( settimer(stages, 0.1) ); 
		}
		if ( in_service != 1 )
		{
			end_stages();
			return ( settimer(stages, 0.1) ); 
		}

		var repeat_time=getprop("fdm/jsbsim/stages/repeat-time");
		var view_offset_x=[0,0,0,0,0,0,0];
		view_offset_x[0]=getprop("sim/view[0]/config/x-offset-m");
		view_offset_x[1]=getprop("sim/view[1]/config/x-offset-m");
		view_offset_x[2]=getprop("sim/view[2]/config/x-offset-m");
		view_offset_x[3]=getprop("sim/view[101]/config/x-offset-m");
		view_offset_x[4]=getprop("sim/view[102]/config/x-offset-m");
		view_offset_x[5]=getprop("sim/view[103]/config/x-offset-m");
		view_offset_x[6]=getprop("sim/view[104]/config/x-offset-m");
		var view_offset_y=[0,0,0,0,0,0,0];
		view_offset_y[0]=getprop("sim/view[0]/config/y-offset-m");
		view_offset_y[1]=getprop("sim/view[1]/config/y-offset-m");
		view_offset_y[2]=getprop("sim/view[2]/config/y-offset-m");
		view_offset_y[3]=getprop("sim/view[101]/config/y-offset-m");
		view_offset_y[4]=getprop("sim/view[102]/config/y-offset-m");
		view_offset_y[5]=getprop("sim/view[103]/config/y-offset-m");
		view_offset_y[6]=getprop("sim/view[104]/config/y-offset-m");
		var view_offset_z=[0,0,0,0,0,0,0];
		view_offset_z[0]=getprop("sim/view[0]/config/z-offset-m");
		view_offset_z[1]=getprop("sim/view[1]/config/z-offset-m");
		view_offset_z[2]=getprop("sim/view[2]/config/z-offset-m");
		view_offset_z[3]=getprop("sim/view[101]/config/z-offset-m");
		view_offset_z[4]=getprop("sim/view[102]/config/z-offset-m");
		view_offset_z[5]=getprop("sim/view[103]/config/z-offset-m");
		view_offset_z[6]=getprop("sim/view[104]/config/z-offset-m");
		var view_pitch_offset_deg=[0,0,0,0,0,0,0];
		view_pitch_offset_deg[0]=getprop("sim/view[0]/config/pitch-offset-deg");
		view_pitch_offset_deg[1]=getprop("sim/view[1]/config/pitch-offset-deg");
		view_pitch_offset_deg[2]=getprop("sim/view[2]/config/pitch-offset-deg");
		view_pitch_offset_deg[3]=getprop("sim/view[101]/config/pitch-offset-deg");
		view_pitch_offset_deg[4]=getprop("sim/view[102]/config/pitch-offset-deg");
		view_pitch_offset_deg[5]=getprop("sim/view[103]/config/pitch-offset-deg");
		view_pitch_offset_deg[6]=getprop("sim/view[104]/config/pitch-offset-deg");
		var view_heading_offset_deg=[0,0,0,0,0,0,0];
		view_heading_offset_deg[0]=getprop("sim/view[0]/config/heading-offset-deg");
		view_heading_offset_deg[1]=getprop("sim/view[1]/config/heading-offset-deg");
		view_heading_offset_deg[2]=getprop("sim/view[2]/config/heading-offset-deg");
		view_heading_offset_deg[3]=getprop("sim/view[101]/config/heading-offset-deg");
		view_heading_offset_deg[4]=getprop("sim/view[102]/config/heading-offset-deg");
		view_heading_offset_deg[5]=getprop("sim/view[103]/config/heading-offset-deg");
		view_heading_offset_deg[6]=getprop("sim/view[104]/config/heading-offset-deg");

		var current_view_name=getprop("sim/current-view/name");

		var one_two_ignition_switch=getprop("fdm/jsbsim/systems/rightswitchpanel/one-two-ignition-switch");
		var one_drop_switch=getprop("fdm/jsbsim/systems/rightswitchpanel/one-drop-switch");
		var fairings_drop_switch=getprop("fdm/jsbsim/systems/rightswitchpanel/fairings-drop-switch");
		var two_drop_switch=getprop("fdm/jsbsim/systems/rightswitchpanel/two-drop-switch");
		var three_ignition_switch=getprop("fdm/jsbsim/systems/rightswitchpanel/three-ignition-switch");
		var three_drop_switch=getprop("fdm/jsbsim/systems/rightswitchpanel/three-drop-switch");
		var tdu_ignition_switch=getprop("fdm/jsbsim/systems/rightswitchpanel/tdu-ignition-switch");
		var tdu_drop_switch=getprop("fdm/jsbsim/systems/rightswitchpanel/tdu-drop-switch");
		var brake_parachute_switch=getprop("fdm/jsbsim/systems/rightswitchpanel/brake-parachute-switch");
		var main_parachute_switch=getprop("fdm/jsbsim/systems/rightswitchpanel/main-parachute-switch");
		var landing_engine_switch=getprop("fdm/jsbsim/systems/rightswitchpanel/landing-engine-switch");

		var lightcheck_switch=getprop("fdm/jsbsim/systems/leftswitchpanel/lightcheck-switch");

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
		var main_chute_extracted=getprop("fdm/jsbsim/systems/spacecraft/main-chute-extracted");
		var main_chute_dropped=getprop("fdm/jsbsim/systems/spacecraft/main-chute-dropped");
		var main_chute_teared=getprop("fdm/jsbsim/systems/spacecraft/main-chute-teared");
		var landing_engine_set=getprop("fdm/jsbsim/systems/spacecraft/landing-engine-set");
		var engine_sensor_teared=getprop("fdm/jsbsim/systems/spacecraft/engine-sensor-teared");

		var sim_clock=getprop("sim/freeze/clock");
		var sim_master=getprop("sim/freeze/master");

		var change=getprop("fdm/jsbsim/stages/change");

		if (
			(repeat_time==nil)

			or (view_offset_x[0]==nil)
			or (view_offset_x[1]==nil)
			or (view_offset_x[2]==nil)
			or (view_offset_x[3]==nil)
			or (view_offset_x[4]==nil)
			or (view_offset_x[5]==nil)
			or (view_offset_x[6]==nil)

			or (view_offset_y[0]==nil)
			or (view_offset_y[1]==nil)
			or (view_offset_y[2]==nil)
			or (view_offset_y[3]==nil)
			or (view_offset_y[4]==nil)
			or (view_offset_y[5]==nil)
			or (view_offset_y[6]==nil)

			or (view_offset_z[0]==nil)
			or (view_offset_z[1]==nil)
			or (view_offset_z[2]==nil)
			or (view_offset_z[3]==nil)
			or (view_offset_z[4]==nil)
			or (view_offset_z[5]==nil)
			or (view_offset_z[6]==nil)

			or (view_pitch_offset_deg[0]==nil)
			or (view_pitch_offset_deg[1]==nil)
			or (view_pitch_offset_deg[2]==nil)
			or (view_pitch_offset_deg[3]==nil)
			or (view_pitch_offset_deg[4]==nil)
			or (view_pitch_offset_deg[5]==nil)
			or (view_pitch_offset_deg[6]==nil)

			or (view_heading_offset_deg[0]==nil)
			or (view_heading_offset_deg[1]==nil)
			or (view_heading_offset_deg[2]==nil)
			or (view_heading_offset_deg[3]==nil)
			or (view_heading_offset_deg[4]==nil)
			or (view_heading_offset_deg[5]==nil)
			or (view_heading_offset_deg[6]==nil)

			or (current_view_name==nil)

			or (one_two_ignition_switch==nil)
			or (one_drop_switch==nil)
			or (fairings_drop_switch==nil)
			or (two_drop_switch==nil)
			or (three_ignition_switch==nil)
			or (three_drop_switch==nil)
			or (tdu_ignition_switch==nil)
			or (tdu_drop_switch==nil)
			or (brake_parachute_switch==nil)
			or (main_parachute_switch==nil)
			or (landing_engine_switch==nil)

			or (lightcheck_switch==nil)

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
			or (stage_active[5]==nil)

			or (chute_cover_dropped==nil)
			or (brake_chute_extracted==nil)
			or (brake_chute_dropped==nil)
			or (brake_chute_teared==nil)
			or (main_chute_extracted==nil)
			or (main_chute_dropped==nil)
			or (main_chute_teared==nil)
			or (landing_engine_set==nil)
			or (engine_sensor_teared==nil)

			or (sim_clock==nil)
			or (sim_master==nil)

			or (change==nil)

		)
		{
			end_stages();
			setprop("fdm/jsbsim/stages/error", 1);
			return ( settimer(stages, 0.1) ); 
		}
		setprop("fdm/jsbsim/stages/error", 0);

		#Shifts

		fairings_shift();
		second_stage_shift();
		third_stage_shift();
		tdu_stage_shift();
		spacecraft_shift();
		view_shift();

		#Button lights

		if (
			(
				(stage_active[0]==1)
				and (stage_ignited[0]==0)
				and (change==0)
			)
			or (lightcheck_switch==1)
		)
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/one-two-ignition-light", 1);
		}
		else
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/one-two-ignition-light", 0);
		}

		if (
			(
				(stage_active[0]==1)
				and (stage_ignited[0]==1)
				and (change==0)
			)
			or (lightcheck_switch==1)
		)
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/one-drop-light", 1);
		}
		else
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/one-drop-light", 0);
		}

		if (
			(
				(stage_active[1]==1)
				and (stage_active[2]==1)
				and (change==0)
			)
			or (lightcheck_switch==1)
		)
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/fairings-drop-light", 1);
		}
		else
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/fairings-drop-light", 0);
		}

		if (
			(
				(stage_active[0]==0)
				and (stage_active[1]==0)
				and (stage_active[2]==1)
				and (change==0)
			)
			or (lightcheck_switch==1)
		)
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/two-drop-light", 1);
		}
		else
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/two-drop-light", 0);
		}

		if (
			(
				(stage_active[3]==1)
				and (stage_ignited[3]==0)
				and (change==0)
			)
			or (lightcheck_switch==1)
		)
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/three-ignition-light", 1);
		}
		else
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/three-ignition-light", 0);
		}

		if (
			(
				(stage_active[3]==1)
				and (change==0)
			)
			or (lightcheck_switch==1)
		)
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/three-drop-light", 1);
		}
		else
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/three-drop-light", 0);
		}

		if (
			(
				(stage_active[4]==1)
				and (change==0)
			)
			or (lightcheck_switch==1)
		)
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/tdu-ignition-light", 1);
		}
		else
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/tdu-ignition-light", 0);
		}

		if (
			(
				(stage_active[4]==1)
				and (change==0)
			)
			or (lightcheck_switch==1)
		)
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/tdu-drop-light", 1);
		}
		else
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/tdu-drop-light", 0);
		}

		if (
			(
				(stage_active[5]==1)
				and (brake_chute_extracted==0)
				and (change==0)
			)
			or (lightcheck_switch==1)
		)
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/brake-parachute-light", 1);
		}
		else
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/brake-parachute-light", 0);
		}

		if (
			(
				(stage_active[5]==1)
				and (brake_chute_extracted==1)
				and (main_chute_extracted==0)
				and (change==0)
			)
			or (lightcheck_switch==1)
		)
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/main-parachute-light", 1);
		}
		else
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/main-parachute-light", 0);
		}

		if (
			(
				(stage_active[5]==1)
				and (main_chute_extracted==1)
				and (landing_engine_set==0)
				and (change==0)
			)
			or (lightcheck_switch==1)
		)
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/landing-engine-light", 1);
		}
		else
		{
			setprop("fdm/jsbsim/systems/rightswitchpanel/landing-engine-light", 0);
		}

		#Button commands

		if (one_two_ignition_switch==1)
		{
			if (
				(stage_active[0]==1)
				and (change==0)
			)
			{
				setprop("fdm/jsbsim/stages/unit[0]/ignited", 1);
			}
			if (
				(stage_active[2]==1)
				and (change==0)
			)
			{
				setprop("fdm/jsbsim/stages/unit[2]/ignited", 1);
			}
			setprop("fdm/jsbsim/systems/rightswitchpanel/one-two-ignition-input", 0);
		}

		if (one_drop_switch==1)
		{
			if (
				(stage_active[0]==1)
				and (stage_ignited[0]==1)
				and (change==0)
			)
			{
				start_first_stage_drop();
			}
			setprop("fdm/jsbsim/systems/rightswitchpanel/one-drop-input", 0);
		}

		if (fairings_drop_switch==1)
		{
			if (
				(stage_active[1]==1)
				and (change==0)
			)
			{
				start_fairings_drop();
			}
			setprop("fdm/jsbsim/systems/rightswitchpanel/fairings-drop-input", 0);
		}

		if (two_drop_switch==1)
		{
			if (
				(stage_active[2]==1)
				and (stage_active[1]==0)
				and (stage_active[0]==0)
				and (change==0)
			)
			{
				start_second_stage_drop();
			}
			setprop("fdm/jsbsim/systems/rightswitchpanel/two-drop-input", 0);
		}

		if (three_ignition_switch==1)
		{
			if (
				(stage_active[3]==1)
				and (change==0)
			)
			{
				setprop("fdm/jsbsim/stages/unit[3]/ignited", 1);
			}
			setprop("fdm/jsbsim/systems/rightswitchpanel/three-ignition-input", 0);
		}

		if (three_drop_switch==1)
		{
			if (
				(stage_active[3]==1)
				and (stage_active[2]==0)
				and (change==0)
			)
			{
				start_third_stage_drop();
			}
			setprop("fdm/jsbsim/systems/rightswitchpanel/three-drop-input", 0);
		}

		if (tdu_ignition_switch==1)
		{
			if (
				(stage_active[4]==1)
				and (change==0)
			)
			{
				Vostok1.bitswap("fdm/jsbsim/stages/unit[4]/ignited");
			}
			setprop("fdm/jsbsim/systems/rightswitchpanel/tdu-ignition-input", 0);
		}

		if (tdu_drop_switch==1)
		{
			if (
				(stage_active[4]==1)
				and (stage_active[3]==0)
				and (change==0)
			)
			{
				start_tdu_stage_drop();
			}
			setprop("fdm/jsbsim/systems/rightswitchpanel/tdu-drop-input", 0);
		}

		if (brake_parachute_switch==1)
		{

			if (
				(stage_active[5]==1)
				and (brake_chute_extracted==0)
				and (change==0)
			)
			{
				start_brake_chute_extraction();
			}
			setprop("fdm/jsbsim/systems/rightswitchpanel/brake-parachute-input", 0);
		}

		if (main_parachute_switch==1)
		{
			if (
				(stage_active[5]==1)
				and (main_chute_extracted==0)
				and (brake_chute_teared==0)
				and (change==0)
			)
			{
				setprop("fdm/jsbsim/systems/spacecraft/chute-cover-dropped", 1);
				setprop("fdm/jsbsim/systems/spacecraft/brake-chute-extracted", 1);
				setprop("fdm/jsbsim/systems/spacecraft/main-chute-extracted", 1);
				setprop("fdm/jsbsim/systems/spacecraft/brake-chute-dropped", 1);
			}
			setprop("fdm/jsbsim/systems/rightswitchpanel/main-parachute-input", 0);
		}

		if (landing_engine_switch==1)
		{
			if (
				(stage_active[5]==1)
				and (landing_engine_set==0)
				and (main_chute_teared==0)
				and (change==0)
			)
			{
				setprop("a/a", 1);
				setprop("fdm/jsbsim/systems/spacecraft/chute-cover-dropped", 1);
				setprop("fdm/jsbsim/systems/spacecraft/brake-chute-extracted", 1);
				setprop("fdm/jsbsim/systems/spacecraft/main-chute-extracted", 1);
				setprop("fdm/jsbsim/systems/spacecraft/brake-chute-dropped", 1);
				setprop("fdm/jsbsim/systems/spacecraft/engine-sensor-extraction-started", 1);
			}
			setprop("fdm/jsbsim/systems/rightswitchpanel/landing-engine-input", 0);
		}

		#Views

		if (current_view_name=="Cosmonaut View")
		{
			setprop("sim/current-view/x-offset-m", view_offset_x[0]);
			setprop("sim/current-view/y-offset-m", view_offset_y[0]);
			setprop("sim/current-view/z-offset-m", view_offset_z[0]);
		}

		if (current_view_name=="Tail View")
		{
			setprop("sim/current-view/x-offset-m", view_offset_x[1]);
			setprop("sim/current-view/y-offset-m", view_offset_y[1]);
			setprop("sim/current-view/z-offset-m", view_offset_z[1]);
		}

		if (current_view_name=="Side View")
		{
			setprop("sim/current-view/x-offset-m", view_offset_x[2]);
			setprop("sim/current-view/y-offset-m", view_offset_y[2]);
			setprop("sim/current-view/z-offset-m", view_offset_z[2]);
		}

		if (current_view_name=="Left Panel View")
		{
			setprop("sim/current-view/x-offset-m", view_offset_x[3]);
			setprop("sim/current-view/y-offset-m", view_offset_y[3]);
			setprop("sim/current-view/z-offset-m", view_offset_z[3]);
			setprop("sim/current-view/pitch-offset-deg", view_pitch_offset_deg[3]);
			setprop("sim/current-view/heading-offset-deg", view_heading_offset_deg[3]);
		}

		if (current_view_name=="Right Panel View")
		{
			setprop("sim/current-view/x-offset-m", view_offset_x[4]);
			setprop("sim/current-view/y-offset-m", view_offset_y[4]);
			setprop("sim/current-view/z-offset-m", view_offset_z[4]);
			setprop("sim/current-view/pitch-offset-deg", view_pitch_offset_deg[4]);
			setprop("sim/current-view/heading-offset-deg", view_heading_offset_deg[4]);
		}

		if (current_view_name=="Vzor View")
		{
			setprop("sim/current-view/x-offset-m", view_offset_x[5]);
			setprop("sim/current-view/y-offset-m", view_offset_y[5]);
			setprop("sim/current-view/z-offset-m", view_offset_z[5]);
			setprop("sim/current-view/pitch-offset-deg", view_pitch_offset_deg[5]);
			setprop("sim/current-view/heading-offset-deg", view_heading_offset_deg[5]);
		}

		if (current_view_name=="Main Panel View")
		{
			setprop("sim/current-view/x-offset-m", view_offset_x[6]);
			setprop("sim/current-view/y-offset-m", view_offset_y[6]);
			setprop("sim/current-view/z-offset-m", view_offset_z[6]);
			setprop("sim/current-view/pitch-offset-deg", view_pitch_offset_deg[6]);
			setprop("sim/current-view/heading-offset-deg", view_heading_offset_deg[6]);
		}

		setprop("fdm/jsbsim/stages/command", 0);

		settimer(stages, repeat_time);
	}

					#Inits and separations
var start_change=func
	{
		setprop("fdm/jsbsim/stages/change", 1);
	}

var end_change=func
	{
		setprop("fdm/jsbsim/stages/change", 0);
	}

					#First stage

var first_stage_stop_engine=func
	{
		#Turn off controlled dignition
		setprop("fdm/jsbsim/stages/unit[0]/ignited", 0);
	}

var first_stage_add_fuel=func
	{
		#Tanks
		setprop("consumables/fuel/tank[0]/level-gal_us", 9264.7);
		setprop("fdm/jsbsim/propulsion/tank[0]/contents-lbs", 61147.0);
		setprop("consumables/fuel/tank[0]/level-lbs", 61147.0);

		setprop("consumables/fuel/tank[1]/level-gal_us", 3746.1);
		setprop("fdm/jsbsim/propulsion/tank[1]/contents-lbs", 24724.00);
		setprop("consumables/fuel/tank[1]/level-lbs", 24724.00);

		setprop("consumables/fuel/tank[2]/level-gal_us", 9264.7);
		setprop("fdm/jsbsim/propulsion/tank[2]/contents-lbs", 61147.0);
		setprop("consumables/fuel/tank[2]/level-lbs", 61147.0);

		setprop("consumables/fuel/tank[3]/level-gal_us", 3746.1);
		setprop("fdm/jsbsim/propulsion/tank[3]/contents-lbs", 24724.00);
		setprop("consumables/fuel/tank[3]/level-lbs", 24724.00);

		setprop("consumables/fuel/tank[4]/level-gal_us", 9264.7);
		setprop("fdm/jsbsim/propulsion/tank[4]/contents-lbs", 61147.0);
		setprop("consumables/fuel/tank[4]/level-lbs", 61147.0);

		setprop("consumables/fuel/tank[5]/level-gal_us", 3746.1);
		setprop("fdm/jsbsim/propulsion/tank[5]/contents-lbs", 24724.00);
		setprop("consumables/fuel/tank[5]/level-lbs", 24724.00);

		setprop("consumables/fuel/tank[6]/level-gal_us", 9264.7);
		setprop("fdm/jsbsim/propulsion/tank[6]/contents-lbs", 61147.0);
		setprop("consumables/fuel/tank[6]/level-lbs", 61147.0);

		setprop("consumables/fuel/tank[7]/level-gal_us", 3746.1);
		setprop("fdm/jsbsim/propulsion/tank[7]/contents-lbs", 24724.00);
		setprop("consumables/fuel/tank[7]/level-lbs", 24724.00);
	}

var first_stage_add_weights=func
	{
		#Weights
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[0]", 2623.0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 2623.0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 2623.0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[3]", 2623.0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 5643.0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[5]", 5643.0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[6]", 5643.0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[7]", 5643.0);
	}

var first_stage_allow_engines=func
	{
		#Send jsb ignition comand to engines
		setprop("fdm/jsbsim/propulsion/engine[0]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[1]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[2]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[3]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[4]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[5]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[6]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[7]/set-running", 1);
	}

var first_stage_ground=func
	{
		#Contact ground points
		setprop("controls/gear/gear-down", 1);
		setprop("fdm/jsbsim/gear/gear-pos-norm", 1);
		setprop("fdm/jsbsim/gear/unit[0]/pos-norm", 1);
		setprop("fdm/jsbsim/gear/unit[1]/pos-norm", 1);
		setprop("fdm/jsbsim/gear/unit[2]/pos-norm", 1);
		setprop("fdm/jsbsim/gear/unit[3]/pos-norm", 1);
	}

var first_stage_activate=func
	{
		#Activate
		setprop("fdm/jsbsim/stages/unit[0]/active", 1);
	}

var first_stage_drop_fuel=func
	{
		#Tanks
		setprop("consumables/fuel/tank[0]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[0]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[0]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[1]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[1]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[1]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[2]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[2]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[2]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[3]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[3]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[3]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[4]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[4]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[4]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[5]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[5]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[5]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[6]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[6]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[6]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[7]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[7]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[7]/level-lbs", 0.1);
	}

var first_stage_drop_weights=func
	{
		#Weights
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[0]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[3]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[5]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[6]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[7]", 0);
	}

var first_stage_deground=func
	{
		#Contact ground points
		setprop("controls/gear/gear-down", 0);
		setprop("fdm/jsbsim/gear/gear-pos-norm", 0);
		setprop("fdm/jsbsim/gear/unit[0]/pos-norm", 0);
		setprop("fdm/jsbsim/gear/unit[1]/pos-norm", 0);
		setprop("fdm/jsbsim/gear/unit[2]/pos-norm", 0);
		setprop("fdm/jsbsim/gear/unit[3]/pos-norm", 0);
	}

var first_stage_deactivate=func
	{
		#Deactivate
		setprop("fdm/jsbsim/stages/unit[0]/active", 0);
	}

var first_stage_init=func
	{
		first_stage_stop_engine();
		first_stage_ground();
		first_stage_add_fuel();
		first_stage_add_weights();
		first_stage_allow_engines();
		first_stage_activate();
	}

var first_stage_separate=func
	{
		first_stage_stop_engine();
		first_stage_deground();
		first_stage_drop_fuel();
		first_stage_drop_weights();
		first_stage_deactivate();
	}

					#Fairings

var fairings_stop_engine=func
	{
		setprop("fdm/jsbsim/stages/unit[1]/ignited", 0);
	}

var fairings_add_weights=func
	{
		#Weights
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[14]", 716.50);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[15]", 716.50);
	}

var fairings_activate=func
	{
		#Activate
		setprop("fdm/jsbsim/stages/unit[1]/active", 1);
	}

var fairings_drop_weights=func
	{
		#Weights
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[14]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[15]", 0);
	}

var fairings_deactivate=func
	{
		#Deactivate
		setprop("fdm/jsbsim/stages/unit[1]/active", 0);
	}

var fairings_init=func
	{
		fairings_stop_engine();
		fairings_add_weights();
		fairings_activate();
	}

var fairings_separate=func
	{
		fairings_stop_engine();
		fairings_drop_weights();
		fairings_deactivate();
	}

					#Second stage

var second_stage_stop_engine=func
	{
		#Turn off controlled dignition
		setprop("fdm/jsbsim/stages/unit[2]/ignited", 0);
	}

var second_stage_add_fuel=func
	{
		#Tanks
		setprop("consumables/fuel/tank[8]/level-gal_us", 10853.5);
		setprop("fdm/jsbsim/propulsion/tank[8]/contents-lbs", 71633.00);
		setprop("consumables/fuel/tank[8]/level-lbs", 71633.00);

		setprop("consumables/fuel/tank[9]/level-gal_us", 10853.5);
		setprop("fdm/jsbsim/propulsion/tank[9]/contents-lbs", 71633.00);
		setprop("consumables/fuel/tank[9]/level-lbs", 71633.00);

		setprop("consumables/fuel/tank[10]/level-gal_us", 4448.3);
		setprop("fdm/jsbsim/propulsion/tank[10]/contents-lbs", 29359.00);
		setprop("consumables/fuel/tank[10]/level-lbs", 29359.00);

		setprop("consumables/fuel/tank[11]/level-gal_us", 4448.3);
		setprop("fdm/jsbsim/propulsion/tank[11]/contents-lbs", 29359.00);
		setprop("consumables/fuel/tank[11]/level-lbs", 29359.00);
	}

var second_stage_add_weights=func
	{
		#Weights
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[8]", 1408.0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[9]", 1408.0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[10]", 6748.0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[11]", 6748.0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[12]", 13828.0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[13]", 13828.0);
	}

var second_stage_allow_engines=func
	{
		#Send jsb ignition comand to engines
		setprop("fdm/jsbsim/propulsion/engine[8]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[9]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[10]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[11]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[12]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[13]/set-running", 1);
	}

var second_stage_activate=func
	{
		#Activate
		setprop("fdm/jsbsim/stages/unit[2]/active", 1);
	}

var second_stage_drop_fuel=func
	{
		#Tanks
		setprop("consumables/fuel/tank[8]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[8]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[8]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[9]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[9]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[9]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[10]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[10]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[10]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[11]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[11]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[11]/level-lbs", 0.1);
	}

var second_stage_drop_weights=func
	{
		#Weights
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[8]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[9]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[10]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[11]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[12]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[13]", 0);
	}

var second_stage_deactivate=func
	{
		#Deactivate
		setprop("fdm/jsbsim/stages/unit[2]/active", 0);
	}

var second_stage_init=func
	{
		second_stage_stop_engine();
		second_stage_add_fuel();
		second_stage_add_weights();
		second_stage_allow_engines();
		second_stage_activate();
	}

var second_stage_separate=func
	{
		second_stage_stop_engine();
		second_stage_drop_fuel();
		second_stage_drop_weights();
		second_stage_deactivate();
	}

					#Third stage

var third_stage_stop_engine=func
	{
		#Turn off controlled dignition
		setprop("fdm/jsbsim/stages/unit[3]/ignited", 0);
	}

var third_stage_add_fuel=func
	{
		#Tanks
		setprop("consumables/fuel/tank[12]/level-gal_us", 731.5);
		setprop("fdm/jsbsim/propulsion/tank[12]/contents-lbs", 4828.00);
		setprop("consumables/fuel/tank[12]/level-lbs", 4828.00);

		setprop("consumables/fuel/tank[13]/level-gal_us", 731.5);
		setprop("fdm/jsbsim/propulsion/tank[13]/contents-lbs", 4828.00);
		setprop("consumables/fuel/tank[13]/level-lbs", 4828.00);

		setprop("consumables/fuel/tank[14]/level-gal_us", 333.9);
		setprop("fdm/jsbsim/propulsion/tank[14]/contents-lbs", 2204.00);
		setprop("consumables/fuel/tank[14]/level-lbs", 2204.00);

		setprop("consumables/fuel/tank[15]/level-gal_us", 333.9);
		setprop("fdm/jsbsim/propulsion/tank[15]/contents-lbs", 2204.00);
		setprop("consumables/fuel/tank[15]/level-lbs", 2204.00);
	}

var third_stage_add_weights=func
	{
		#Weights
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[16]", 133.37);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[17]", 133.37);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[18]", 1576.30);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[19]", 1576.30);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[20]", 2502.24);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[21]", 2502.24);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[22]", 2711.68);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[23]", 2711.68);
	}

var third_stage_allow_engines=func
	{
		#Send jsb ignition comand to engines
		setprop("fdm/jsbsim/propulsion/engine[14]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[15]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[16]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[17]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[18]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[19]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[20]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[21]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[22]/set-running", 1);
	}

var third_stage_activate=func
	{
		#Activate
		setprop("fdm/jsbsim/stages/unit[3]/active", 1);
	}

var third_stage_drop_fuel=func
	{
		#Tanks
		setprop("consumables/fuel/tank[12]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[12]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[12]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[13]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[13]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[13]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[14]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[14]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[14]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[15]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[15]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[15]/level-lbs", 0.1);
	}

var third_stage_drop_weights=func
	{
		#Weights
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[16]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[17]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[18]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[19]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[20]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[21]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[22]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[23]", 0);
	}

var third_stage_deactivate=func
	{
		#Deactivate
		setprop("fdm/jsbsim/stages/unit[3]/active", 0);
	}

var third_stage_init=func
	{
		third_stage_stop_engine();
		third_stage_add_fuel();
		third_stage_add_weights();
		third_stage_allow_engines();
		third_stage_activate();
	}

var third_stage_separate=func
	{
		third_stage_stop_engine();
		third_stage_drop_fuel();
		third_stage_drop_weights();
		third_stage_deactivate();
	}

					#TDU stage

var tdu_stage_stop_engine=func
	{
		#Turn off controlled dignition
		setprop("fdm/jsbsim/stages/unit[4]/ignited", 0);
		setprop("fdm/jsbsim/stages/unit[4]/maneur-ignited", 0);
	}

var tdu_stage_add_fuel=func
	{
		#Tanks
		setprop("consumables/fuel/tank[16]/level-gal_us", 18.105);
		setprop("fdm/jsbsim/propulsion/tank[16]/contents-lbs", 242.50);
		setprop("consumables/fuel/tank[16]/level-lbs", 242.50);

		setprop("consumables/fuel/tank[17]/level-gal_us", 18.105);
		setprop("fdm/jsbsim/propulsion/tank[17]/contents-lbs", 242.50);
		setprop("consumables/fuel/tank[17]/level-lbs", 242.50);

		setprop("consumables/fuel/tank[18]/level-gal_us", 6.772);
		setprop("fdm/jsbsim/propulsion/tank[18]/contents-lbs", 66.13);
		setprop("consumables/fuel/tank[18]/level-lbs", 66.13);

		setprop("consumables/fuel/tank[19]/level-gal_us", 6.772);
		setprop("fdm/jsbsim/propulsion/tank[19]/contents-lbs", 66.13);
		setprop("consumables/fuel/tank[19]/level-lbs", 66.13);

		setprop("consumables/fuel/tank[20]/level-gal_us", 2.78);
		setprop("fdm/jsbsim/propulsion/tank[20]/contents-lbs", 20.00);
		setprop("consumables/fuel/tank[20]/level-lbs", 20.00);
		setprop("consumables/fuel/tank[20]/selected", 0.0);

		setprop("consumables/fuel/tank[21]/level-gal_us", 2.78);
		setprop("fdm/jsbsim/propulsion/tank[21]/contents-lbs", 20.00);
		setprop("consumables/fuel/tank[21]/level-lbs", 20.00);
		setprop("consumables/fuel/tank[21]/selected", 0.0);

		setprop("consumables/fuel/tank[22]/level-gal_us", 2.78);
		setprop("fdm/jsbsim/propulsion/tank[22]/contents-lbs", 20.00);
		setprop("consumables/fuel/tank[22]/level-lbs", 20.00);
		setprop("consumables/fuel/tank[22]/selected", 0.0);

		setprop("consumables/fuel/tank[23]/level-gal_us", 2.78);
		setprop("fdm/jsbsim/propulsion/tank[23]/contents-lbs", 20.00);
		setprop("consumables/fuel/tank[23]/level-lbs", 20.00);
		setprop("consumables/fuel/tank[23]/selected", 0.0);

		setprop("consumables/fuel/tank[24]/level-gal_us", 2.78);
		setprop("fdm/jsbsim/propulsion/tank[24]/contents-lbs", 20.00);
		setprop("consumables/fuel/tank[24]/level-lbs", 20.00);
		setprop("consumables/fuel/tank[24]/selected", 1.0);

		setprop("consumables/fuel/tank[25]/level-gal_us", 2.78);
		setprop("fdm/jsbsim/propulsion/tank[25]/contents-lbs", 20.00);
		setprop("consumables/fuel/tank[25]/level-lbs", 20.00);
		setprop("consumables/fuel/tank[25]/selected", 1.0);
	}

var tdu_stage_add_weights=func
	{
		#Weights
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[24]", 108.02);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[25]", 108.02);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[26]", 1576.30);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[27]", 1576.30);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[28]", 2711.68);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[29]", 2711.68);
	}

var tdu_stage_allow_engines=func
	{
		#Send jsb ignition comand to engines
		setprop("fdm/jsbsim/propulsion/engine[23]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[24]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[25]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[26]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[27]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[28]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[29]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[30]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[31]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[32]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[33]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[34]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[35]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[36]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[37]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[38]/set-running", 1);
		setprop("fdm/jsbsim/propulsion/engine[39]/set-running", 1);
	}

var tdu_stage_start_maneur_engines=func
	{
		setprop("fdm/jsbsim/stages/unit[4]/maneur-ignited", 1);
	}

var tdu_stage_activate=func
	{
		#Activate
		setprop("fdm/jsbsim/stages/unit[4]/activated", 0);
		setprop("fdm/jsbsim/stages/unit[4]/broken", 0);
		setprop("fdm/jsbsim/systems/tdu/hard-antennas-extraction-started", 0);
		setprop("fdm/jsbsim/systems/tdu/hard-antennas-pos-norm", 0);
		setprop("fdm/jsbsim/systems/tdu/radiators-extraction-started", 0);
		setprop("fdm/jsbsim/systems/tdu/radiators-pos-norm", 0);
		setprop("fdm/jsbsim/systems/tdu/whip-antennas-extraction-started", 0);
		setprop("fdm/jsbsim/systems/tdu/whip-antennas-pos-norm", 0);
		setprop("fdm/jsbsim/systems/tdu/whip-antennas-extracted", 0);
		setprop("fdm/jsbsim/stages/unit[4]/active", 1);
	}

var tdu_stage_drop_fuel=func
	{
		#Tanks
		setprop("consumables/fuel/tank[16]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[16]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[16]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[17]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[17]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[17]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[18]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[18]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[18]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[19]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[19]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[19]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[20]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[20]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[20]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[21]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[21]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[21]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[22]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[22]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[22]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[23]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[23]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[23]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[24]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[24]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[24]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[25]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[25]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[25]/level-lbs", 0.1);
	}

var tdu_stage_drop_weights=func
	{
		#Weights
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[24]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[25]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[26]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[27]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[28]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[29]", 0);
	}

var tdu_stage_deactivate=func
	{
		#Activate
		setprop("fdm/jsbsim/stages/unit[4]/activated", 0);
		setprop("fdm/jsbsim/stages/unit[4]/broken", 0);
		setprop("fdm/jsbsim/systems/tdu/hard-antennas-extraction-started", 0);
		setprop("fdm/jsbsim/systems/tdu/hard-antennas-pos-norm", 0);
		setprop("fdm/jsbsim/systems/tdu/radiators-extraction-started", 0);
		setprop("fdm/jsbsim/systems/tdu/radiators-pos-norm", 0);
		setprop("fdm/jsbsim/systems/tdu/whip-antennas-extraction-started", 0);
		setprop("fdm/jsbsim/systems/tdu/whip-antennas-pos-norm", 0);
		setprop("fdm/jsbsim/systems/tdu/whip-antennas-extracted", 0);
		setprop("fdm/jsbsim/stages/unit[4]/active", 0);
	}

var tdu_stage_init=func
	{
		tdu_stage_stop_engine();
		tdu_stage_add_fuel();
		tdu_stage_add_weights();
		tdu_stage_allow_engines();
		tdu_stage_start_maneur_engines();
		tdu_stage_activate();
	}

var tdu_stage_separate=func
	{
		tdu_stage_stop_engine();
		tdu_stage_drop_fuel();
		tdu_stage_drop_weights();
		tdu_stage_deactivate();
	}

					#Spacecraft

var spacecraft_stop_engine=func
	{
		#Turn off controlled dignition
		setprop("fdm/jsbsim/stages/unit[5]/ignited", 0);
	}

var spacecraft_add_fuel=func
	{
		#Tanks
		setprop("consumables/fuel/tank[26]/level-gal_us", 1.325);
		setprop("fdm/jsbsim/propulsion/tank[26]/contents-lbs", 9.956);
		setprop("consumables/fuel/tank[26]/level-lbs", 9.956);

		setprop("consumables/fuel/tank[27]/level-gal_us", 1.325);
		setprop("fdm/jsbsim/propulsion/tank[27]/contents-lbs", 9.956);
		setprop("consumables/fuel/tank[27]/level-lbs", 9.956);
	}

var spacecraft_add_weights=func
	{
		#Weights
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[30]", 2711.68);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[31]", 1355.84);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[32]", 1355.84);
	}

var spacecraft_allow_engines=func
	{
		#Send jsb ignition comand to engines
		setprop("fdm/jsbsim/propulsion/engine[40]/set-running", 1);
	}

var spacecraft_additional_activation=func
	{
		setprop("fdm/jsbsim/systems/spacecraft/chute-cover-dropped", 0);

		setprop("fdm/jsbsim/systems/spacecraft/brake-chute-extracted", 0);
		setprop("fdm/jsbsim/systems/spacecraft/brake-chute-pos-norm", 0);
		setprop("fdm/jsbsim/systems/spacecraft/brake-chute-dropped", 0);
		setprop("fdm/jsbsim/systems/spacecraft/brake-chute-teared", 0);

		setprop("fdm/jsbsim/systems/spacecraft/main-chute-extracted", 0);
		setprop("fdm/jsbsim/systems/spacecraft/main-chute-pos-norm", 0);
		setprop("fdm/jsbsim/systems/spacecraft/main-drop-command", 0);

		setprop("fdm/jsbsim/systems/spacecraft/main-chute-dropped", 0);
		setprop("fdm/jsbsim/systems/spacecraft/landing-engine-set", 0);
		setprop("fdm/jsbsim/systems/spacecraft/engine-sensor-teared", 0);
		setprop("fdm/jsbsim/systems/spacecraft/ground-contact", 0);
	}

var spacecraft_activate=func
	{
		#Activate
		setprop("fdm/jsbsim/stages/unit[5]/activated", 0);
		setprop("fdm/jsbsim/stages/unit[5]/active", 1);
}

var spacecraft_drop_fuel=func
	{
		#Tanks
		setprop("consumables/fuel/tank[26]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[26]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[26]/level-lbs", 0.1);

		setprop("consumables/fuel/tank[27]/level-gal_us", 0.1);
		setprop("fdm/jsbsim/propulsion/tank[27]/contents-lbs", 0.1);
		setprop("consumables/fuel/tank[27]/level-lbs", 0.1);
	}

var spacecraft_drop_weights=func
	{
		#Weights
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[30]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[31]", 0);
		setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[32]", 0);
	}

var spacecraft_deactivate=func
	{
		#Deactivate
		setprop("fdm/jsbsim/stages/unit[5]/active", 0);
		setprop("fdm/jsbsim/stages/unit[5]/activated", 0);
	}

var spacecraft_init=func
	{
		spacecraft_stop_engine();
		spacecraft_add_fuel();
		spacecraft_add_weights();
		spacecraft_allow_engines();
		spacecraft_additional_activation();
		spacecraft_activate();
	}

var spacecraft_separate=func
	{
		spacecraft_stop_engine();
		spacecraft_drop_fuel();
		spacecraft_drop_weights();
		spacecraft_deactivate();
	}

					#Delayed drop commands to avoid problems

					#First stage drop

var start_first_stage_drop=func
	{
		start_change();
		first_stage_stop_engine();
		first_stage_deground();
		settimer(first_stage_drop_phase_one, 0.3);
	}

var first_stage_drop_phase_one=func
	{
		first_stage_drop_fuel();
		first_stage_drop_weights();
		setprop("fdm/jsbsim/stages/unit[0]/drop", 1);
		settimer(first_stage_drop_phase_two, 2.0);
	}

var first_stage_drop_phase_two=func
	{
		first_stage_deactivate();

		var pitch=props.globals.getNode("orientation/pitch-deg", 1).getValue(0);
		var heading=props.globals.getNode("orientation/heading-deg", 1).getValue(0);

		var ballistics=props.globals.getNode("ai/models").getChildren("ballistic");
		foreach(var ballistic; ballistics)
		{
			var name=ballistic.getName();
			if (
				(name="First Stage Forward")
				or (name="First Stage Back")
				or (name="First Stage Left")
				or (name="First Stage Right")
			)
			{
				ballistic.getChild("controls", 0, 1).getChild("slave-to-ac", 0, 1).setValue(0);
			}
		}

		setprop("ai/ballistic-forces/force[0]/force-lb", 8267*2);
		setprop("ai/ballistic-forces/force[1]/force-lb", 8267*2);
		setprop("ai/ballistic-forces/force[2]/force-lb", 8267*2);
		setprop("ai/ballistic-forces/force[3]/force-lb", 8267*2);

		setprop("ai/ballistic-forces/force[0]/force-azimuth-deg", heading);
		setprop("ai/ballistic-forces/force[1]/force-azimuth-deg", heading);
		setprop("ai/ballistic-forces/force[2]/force-azimuth-deg", heading-90);
		setprop("ai/ballistic-forces/force[3]/force-azimuth-deg", heading+90);

		setprop("ai/ballistic-forces/force[0]/force-elevation-deg", pitch+180);
		setprop("ai/ballistic-forces/force[1]/force-elevation-deg", pitch);
		setprop("ai/ballistic-forces/force[2]/force-elevation-deg", pitch+90);
		setprop("ai/ballistic-forces/force[3]/force-elevation-deg", pitch+90);

		settimer(end_first_stage_drop, 2);
	}

var end_first_stage_drop=func
	{
		end_change();

		setprop("ai/ballistic-forces/force[0]/force-lb", 0);
		setprop("ai/ballistic-forces/force[1]/force-lb", 0);
		setprop("ai/ballistic-forces/force[2]/force-lb", 0);
		setprop("ai/ballistic-forces/force[3]/force-lb", 0);

		setprop("fdm/jsbsim/stages/unit[0]/drop", 0);
		setprop("fdm/jsbsim/stages/unit[0]/dropped", 1);
	}


					#Fairings drop

var start_fairings_drop=func
	{
		start_change();
		fairings_stop_engine();
		settimer(fairings_drop_phase_one, 0.3);
	}

var fairings_drop_phase_one=func
	{
		fairings_drop_weights();
		setprop("fdm/jsbsim/stages/unit[1]/drop", 1);
		settimer(fairings_drop_phase_two, 2.0);
	}

var fairings_drop_phase_two=func
	{
		fairings_deactivate();
		var pitch=props.globals.getNode("orientation/pitch-deg", 1).getValue(0);
		var heading=props.globals.getNode("orientation/heading-deg", 1).getValue(0);

		var ballistics=props.globals.getNode("ai/models").getChildren("ballistic");
		foreach(var ballistic; ballistics)
		{
			var name=ballistic.getName();
			if (
				(name="Fairings Forward")
				or (name="Fairings Back")
			)
			{
				ballistic.getChild("controls", 0, 1).getChild("slave-to-ac", 0, 1).setValue(0);
			}
		}

		setprop("ai/ballistic-forces/force[4]/force-lb", 716*2);
		setprop("ai/ballistic-forces/force[5]/force-lb", 716*2);

		setprop("ai/ballistic-forces/force[4]/force-azimuth-deg", heading);
		setprop("ai/ballistic-forces/force[5]/force-azimuth-deg", heading);

		setprop("ai/ballistic-forces/force[4]/force-elevation-deg", pitch+180);
		setprop("ai/ballistic-forces/force[5]/force-elevation-deg", pitch);

		settimer(end_fairings_drop, 2);
	}

var end_fairings_drop=func
	{
		setprop("ai/ballistic-forces/force[4]/force-lb", 0);
		setprop("ai/ballistic-forces/force[5]/force-lb", 0);

		setprop("fdm/jsbsim/stages/unit[1]/drop", 0);
		setprop("fdm/jsbsim/stages/unit[1]/dropped", 1);
		end_change();
	}

					#Second stage drop

var start_second_stage_drop=func
	{
		start_change();
		second_stage_stop_engine();
		third_stage_stop_engine();
		settimer(second_stage_drop_phase_one, 0.3);
	}

var second_stage_drop_phase_one=func
	{
		second_stage_drop_fuel();
		third_stage_add_fuel();
		settimer(second_stage_drop_phase_two, 0.3);
	}

var second_stage_drop_phase_two=func
	{
		second_stage_drop_weights();
		third_stage_add_weights();

		third_stage_activate();

		#Set command angles
		setprop("fdm/jsbsim/systems/third_computer/pitch-rad", 0);
		setprop("fdm/jsbsim/systems/third_computer/roll-rad", 0);
		setprop("fdm/jsbsim/systems/third_computer/yaw-rad", 0);

		second_stage_deactivate();

		setprop("fdm/jsbsim/stages/unit[2]/drop", 1);
		settimer(second_stage_drop_phase_three, 2.0);
	}

var second_stage_drop_phase_three=func
	{

		var pitch=props.globals.getNode("orientation/pitch-deg", 1).getValue(0);
		var heading=props.globals.getNode("orientation/heading-deg", 1).getValue(0);

		var ballistics=props.globals.getNode("ai/models").getChildren("ballistic");
		foreach(var ballistic; ballistics)
		{
			var name=ballistic.getName();
			if (
				(name="Second Stage")
			)
			{
				ballistic.getChild("controls", 0, 1).getChild("slave-to-ac", 0, 1).setValue(0);
			}
		}

		setprop("ai/ballistic-forces/force[6]/force-lb", 16312*2);
		setprop("ai/ballistic-forces/force[6]/force-azimuth-deg", heading);
		setprop("ai/ballistic-forces/force[6]/force-elevation-deg", pitch-90);

		setprop("fdm/jsbsim/stages/unit[2]/drop", 0);

		settimer(end_second_stage_drop, 2);
	}


var end_second_stage_drop=func
	{
		setprop("ai/ballistic-forces/force[6]/force-lb", 0);
		setprop("fdm/jsbsim/stages/unit[2]/dropped", 1);
		third_stage_allow_engines();
		end_change();
	}

					#Third stage drop

var start_third_stage_drop=func
	{
		start_change();
		third_stage_stop_engine();
		tdu_stage_stop_engine();
		settimer(third_stage_drop_phase_one, 0.3);
	}

var third_stage_drop_phase_one=func
	{
		third_stage_drop_fuel();
		tdu_stage_add_fuel();
		settimer(third_stage_drop_phase_two, 0.3);
	}

var third_stage_drop_phase_two=func
	{
		third_stage_drop_weights();
		tdu_stage_add_weights();
		tdu_stage_activate();

		#Set command angles
		setprop("fdm/jsbsim/systems/tdu_computer/pitch-rad", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/roll-rad", 0);
		setprop("fdm/jsbsim/systems/tdu_computer/yaw-rad", 0);

		third_stage_deactivate();
		setprop("fdm/jsbsim/stages/unit[3]/drop", 1);
		settimer(third_stage_drop_phase_three, 2.0);
	}

var third_stage_drop_phase_three=func
	{
		tdu_stage_allow_engines();

		var pitch=props.globals.getNode("orientation/pitch-deg", 1).getValue(0);
		var heading=props.globals.getNode("orientation/heading-deg", 1).getValue(0);

		var ballistics=props.globals.getNode("ai/models").getChildren("ballistic");
		foreach(var ballistic; ballistics)
		{
			var name=ballistic.getName();
			if (
				(name="Third Stage")
			)
			{
				ballistic.getChild("controls", 0, 1).getChild("slave-to-ac", 0, 1).setValue(0);
			}
		}

		setprop("ai/ballistic-forces/force[7]/force-lb", 3420*2);
		setprop("ai/ballistic-forces/force[7]/force-azimuth-deg", heading);
		setprop("ai/ballistic-forces/force[7]/force-elevation-deg", pitch-90);

		setprop("fdm/jsbsim/stages/unit[3]/drop", 0);

		settimer(end_third_stage_drop, 2);
	}

var end_third_stage_drop=func
	{
		tdu_stage_start_maneur_engines();

		setprop("ai/ballistic-forces/force[7]/force-lb", 0);
		setprop("fdm/jsbsim/stages/unit[3]/dropped", 1);

		end_change();
	}

					#Tdu stage drop

var start_tdu_stage_drop=func
	{
		start_change();
		tdu_stage_stop_engine();
		spacecraft_stop_engine();
		settimer(tdu_stage_drop_phase_one, 0.3);
	}

var tdu_stage_drop_phase_one=func
	{
		tdu_stage_drop_fuel();
		spacecraft_add_fuel();
		setprop("fdm/jsbsim/stages/unit[4]/separate", 1);
		settimer(tdu_stage_drop_phase_two, 3.0);
	}

var tdu_stage_drop_phase_two=func
	{
		tdu_stage_drop_weights();
		spacecraft_add_weights();
		tdu_stage_deactivate();
		spacecraft_activate();
		setprop("fdm/jsbsim/stages/unit[4]/drop", 1);
		settimer(tdu_stage_drop_phase_three, 2.0);
	}

var tdu_stage_drop_phase_three=func
	{
		spacecraft_allow_engines();

		var pitch=props.globals.getNode("orientation/pitch-deg", 1).getValue(0);
		var heading=props.globals.getNode("orientation/heading-deg", 1).getValue(0);

		var ballistics=props.globals.getNode("ai/models").getChildren("ballistic");
		foreach(var ballistic; ballistics)
		{
			var name=ballistic.getName();
			if (
				(name="TDU")
			)
			{
				ballistic.getChild("controls", 0, 1).getChild("slave-to-ac", 0, 1).setValue(0);
			}
		}

		setprop("ai/ballistic-forces/force[8]/force-lb", 3368*2.0);
		setprop("ai/ballistic-forces/force[8]/force-azimuth-deg", heading);
		setprop("ai/ballistic-forces/force[8]/force-elevation-deg", pitch-90);

		setprop("fdm/jsbsim/stages/unit[4]/drop", 0);

		settimer(end_tdu_stage_drop, 2);
	}

var end_tdu_stage_drop=func
	{
		setprop("ai/ballistic-forces/force[8]/force-lb", 0);
		setprop("fdm/jsbsim/stages/unit[4]/dropped", 1);
		spacecraft_additional_activation();
		end_change();
	}

					#Left hatch and antenna drop

var start_brake_chute_extraction=func
	{
		start_change();
		setprop("fdm/jsbsim/systems/spacecraft/chute-cover-drop", 1);
		setprop("fdm/jsbsim/systems/spacecraft/chute-cover-dropped", 1);
		settimer(brake_chute_extraction_phase_one, 0.0);
	}

var brake_chute_extraction_phase_one=func
	{

		var pitch=props.globals.getNode("orientation/pitch-deg", 1).getValue(0);
		var heading=props.globals.getNode("orientation/heading-deg", 1).getValue(0);

		var ballistics=props.globals.getNode("ai/models").getChildren("ballistic");
		foreach(var ballistic; ballistics)
		{
			var name=ballistic.getName();
			if (
				(name="Left Hatch")
				or (name="Left Antenna")
			)
			{
				ballistic.getChild("controls", 0, 1).getChild("slave-to-ac", 0, 1).setValue(0);
			}
		}

		setprop("ai/ballistic-forces/force[9]/force-lb", 200*2);
		setprop("ai/ballistic-forces/force[9]/force-azimuth-deg", heading-90);
		setprop("ai/ballistic-forces/force[9]/force-elevation-deg", pitch+11.63);

		setprop("ai/ballistic-forces/force[10]/force-lb", 2*2);
		setprop("ai/ballistic-forces/force[10]/force-azimuth-deg", heading-90);
		setprop("ai/ballistic-forces/force[10]/force-elevation-deg", pitch+11.63);

		setprop("fdm/jsbsim/systems/spacecraft/chute-cover-drop", 0);

		settimer(end_brake_chute_extraction, 2);
	}

var end_brake_chute_extraction=func
	{
		setprop("ai/ballistic-forces/force[9]/force-lb", 0);
		setprop("ai/ballistic-forces/force[10]/force-lb", 0);
		setprop("fdm/jsbsim/systems/spacecraft/brake-chute-extracted", 1);
		end_change();
	}

					#Shifts

var second_stage_shift=func
	{
		var on=getprop("fdm/jsbsim/stages/unit[2]/active");
		if (
			(on!=nil)
		)
		{
			if (on==1)
			{
				setprop("fdm/jsbsim/stages/unit[2]/show-translate", 0.0);
				setprop("fdm/jsbsim/stages/unit[2]/mass-translate", -562.03);
				#setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[8]", -562.03);
				#setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[9]", -562.03);
				#setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[10]", 97.83);
				#setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[11]", 97.83);
			}
			else
			{
				setprop("fdm/jsbsim/stages/unit[2]/show-translate", -17.506);
				setprop("fdm/jsbsim/stages/unit[2]/mass-translate", -689.21);
				#setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[8]", -689.21);
				#setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[9]", -689.21);
				#setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[10]", -29.35);
				#setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[11]", -29.35);
			}
		}
	}


var fairings_shift=func
	{
		var first_on=getprop("fdm/jsbsim/stages/unit[0]/active");
		var second_on=getprop("fdm/jsbsim/stages/unit[2]/active");
		if (!((first_on==nil)
			or (second_on==nil)
		))
		{
			if (
				(first_on==1)
				or (second_on==1)
			)
			{
				setprop("fdm/jsbsim/stages/unit[1]/show-translate", 0.0);
				setprop("fdm/jsbsim/stages/unit[1]/mass-translate", 772.986);
				setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[14]", 772.986);
				setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[15]", 772.986);
			}
			else
			{
				setprop("fdm/jsbsim/stages/unit[1]/show-translate", -17.495);
				setprop("fdm/jsbsim/stages/unit[1]/mass-translate", 82.598);
				setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[14]", 82.598);
				setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[15]", 82.598);
			}
		}
	}

var third_stage_shift=func
	{
		var first_on=getprop("fdm/jsbsim/stages/unit[0]/active");
		var second_on=getprop("fdm/jsbsim/stages/unit[2]/active");
		var third_on=getprop("fdm/jsbsim/stages/unit[3]/active");
		if (!((first_on==nil)
			or (second_on==nil)
		))
		{
			if (
				(first_on==1)
				or (second_on==1)
			)
			{
				setprop("fdm/jsbsim/stages/unit[3]/show-translate", 0.0);
			}
			else
			{
				if (third_on==1)
				{
					setprop("fdm/jsbsim/stages/unit[3]/show-translate", -17.502);
				}
				else
				{
					setprop("fdm/jsbsim/stages/unit[3]/show-translate", -18.159);
				}
			}
		}
	}

var tdu_stage_shift=func
	{
		var first_on=getprop("fdm/jsbsim/stages/unit[0]/active");
		var second_on=getprop("fdm/jsbsim/stages/unit[2]/active");
		var third_on=getprop("fdm/jsbsim/stages/unit[3]/active");
		if (!((first_on==nil)
			or (second_on==nil)
			or (third_on==nil)
		))
		{
			if (
				(first_on==1)
				or (second_on==1)
			)
			{
				setprop("fdm/jsbsim/stages/unit[4]/show-translate", 0.0);
			}
			else
			{
				if (third_on==1)
				{
					setprop("fdm/jsbsim/stages/unit[4]/show-translate", -17.502);
				}
				else
				{
					setprop("fdm/jsbsim/stages/unit[4]/show-translate", -18.159);
				}
			}
		}
	}

var spacecraft_shift=func
	{
		var first_on=getprop("fdm/jsbsim/stages/unit[0]/active");
		var second_on=getprop("fdm/jsbsim/stages/unit[2]/active");
		var third_on=getprop("fdm/jsbsim/stages/unit[3]/active");
		var tdu_on=getprop("fdm/jsbsim/stages/unit[4]/active");
		if (!((first_on==nil)
			or (second_on==nil)
			or (third_on==nil)
			or (tdu_on==nil)
		))
		{
			if (
				(first_on==1)
				or (second_on==1)
			)
			{
				setprop("fdm/jsbsim/stages/unit[5]/show-translate", 0.0);
			}
			else
			{
				if (third_on==1)
				{
					setprop("fdm/jsbsim/stages/unit[5]/show-translate", -17.503);
				}
				else
				{
					if (tdu_on==1)
					{
						setprop("fdm/jsbsim/stages/unit[5]/show-translate", -18.16);
					}
					else
					{
						setprop("fdm/jsbsim/stages/unit[5]/show-translate", -19.305);
					}
				}
			}
		}
	}

var view_shift=func
	{
		var first_on=getprop("fdm/jsbsim/stages/unit[0]/active");
		var second_on=getprop("fdm/jsbsim/stages/unit[2]/active");
		var third_on=getprop("fdm/jsbsim/stages/unit[3]/active");
		var tdu_on=getprop("fdm/jsbsim/stages/unit[4]/active");
		if (!((first_on==nil)
			or (second_on==nil)
			or (third_on==nil)
			or (tdu_on==nil)
		))
		{
			if (
				(first_on==1)
				or (second_on==1)
			)
			{
				setprop("sim/view[0]/config/y-offset-m", 19.74);
				setprop("sim/view[1]/config/y-offset-m", -25.0);
				setprop("sim/view[2]/config/x-offset-m", 50.0);
				setprop("sim/view[101]/config/y-offset-m", 19.74);
				setprop("sim/view[102]/config/y-offset-m", 19.74);
				setprop("sim/view[103]/config/y-offset-m", 19.74);
				setprop("sim/view[104]/config/y-offset-m", 19.74);
			}
			else
			{
				if (third_on==1)
				{
					setprop("sim/view[0]/config/y-offset-m", 2.238);
					setprop("sim/view[1]/config/y-offset-m", -10.0);
					setprop("sim/view[2]/config/x-offset-m", 20.0);
					setprop("sim/view[101]/config/y-offset-m", 2.238);
					setprop("sim/view[102]/config/y-offset-m", 2.238);
					setprop("sim/view[103]/config/y-offset-m", 2.238);
					setprop("sim/view[104]/config/y-offset-m", 2.238);
				}
				else
				{
					if (tdu_on==1)
					{
						setprop("sim/view[0]/config/y-offset-m", 1.581);
						setprop("sim/view[1]/config/y-offset-m", -5.0);
						setprop("sim/view[2]/config/x-offset-m", 10.0);
						setprop("sim/view[101]/config/y-offset-m", 1.581);
						setprop("sim/view[102]/config/y-offset-m", 1.581);
						setprop("sim/view[103]/config/y-offset-m", 1.581);
						setprop("sim/view[104]/config/y-offset-m", 1.581);
					}
					else
					{
						setprop("sim/view[0]/config/y-offset-m", 0.436);
						setprop("sim/view[1]/config/y-offset-m", 5.0);
						setprop("sim/view[2]/config/x-offset-m", 10.0);
						setprop("sim/view[101]/config/y-offset-m", 0.436);
						setprop("sim/view[102]/config/y-offset-m", 0.436);
						setprop("sim/view[103]/config/y-offset-m", 0.436);
						setprop("sim/view[104]/config/y-offset-m", 0.436);
					}
				}
			}
		}
	}

# set startup configuration
var init_stages=func
	{
		setprop("fdm/jsbsim/stages/serviceable", 1);
		setprop("fdm/jsbsim/stages/command", 0);
		setprop("fdm/jsbsim/stages/repeat-time", 0);

		first_stage_init();
		second_stage_init();
		fairings_init();
		third_stage_separate();
		tdu_stage_separate();
		spacecraft_separate();

		#first_stage_separate();
		#second_stage_separate();
		#fairings_separate();
		#third_stage_separate();
		#tdu_stage_init();
		#spacecraft_separate();

		settimer(extra_activation, 2.0);

		fairings_shift();
		third_stage_shift();
		tdu_stage_shift();
		spacecraft_shift();
		view_shift();
	}

var extra_activation=func
	{
		setprop("fdm/jsbsim/systems/spacecraft/chute-cover-drop", 0);
		setprop("fdm/jsbsim/systems/spacecraft/chute-cover-dropped", 0);

		setprop("fdm/jsbsim/systems/spacecraft/brake-chute-extracted", 0);
		setprop("fdm/jsbsim/systems/spacecraft/brake-chute-pos-norm", 0);
		setprop("fdm/jsbsim/systems/spacecraft/brake-chute-dropped", 0);
		setprop("fdm/jsbsim/systems/spacecraft/brake-chute-teared", 0);

		setprop("fdm/jsbsim/systems/spacecraft/main-chute-extracted", 0);
		setprop("fdm/jsbsim/systems/spacecraft/main-chute-pos-norm", 0);
		setprop("fdm/jsbsim/systems/spacecraft/main-drop-command", 0);

		setprop("fdm/jsbsim/systems/spacecraft/main-chute-dropped", 0);
		setprop("fdm/jsbsim/systems/spacecraft/landing-engine-set", 0);
		setprop("fdm/jsbsim/systems/spacecraft/engine-sensor-teared", 0);
		setprop("fdm/jsbsim/systems/spacecraft/ground-contact", 0);
	}

# set startup configuration
var start_stages=func
	{
		init_stages();
		var time_elapsed=getprop("fdm/jsbsim/simulation/sim-time-sec");
		if (time_elapsed!=nil)
		{
			if (time_elapsed>0)
			{
				stages();
			}
			else
			{
				return ( settimer(start_stages, 0.1) ); 
			}
		}
		else
		{
			return ( settimer(start_stages, 0.1) ); 
		}
	}
