/**
* Name: LFAY
* The model used for the LFAY 2-days demonstrations  
* Author: A. Drogoul
* 
* This model has been designed using resources (icons) from Flaticon.com
* 
* Tags: 
*/

model UI1



import "../Global.gaml"
 
global {
	
	
	image_file soil_pollution_smiley (float v) {
		switch(v) {
			match_between [0, 24999] {return smileys[0];}
			match_between [25000, 39999] {return smileys[1];}
			match_between [40000, 64999] {return smileys[2];}
			match_between [65000, 90000] {return smileys[3];}
			default {return smileys[4];}
		}
	}

	image_file soil_pollution_class(village w) {
		switch (int(w)) {
			match 0 {return soil_pollution_smiley(village1_solid_pollution);}
			match 1 {return soil_pollution_smiley(village2_solid_pollution);}
			match 2 {return soil_pollution_smiley(village3_solid_pollution);}
			match 3 {return soil_pollution_smiley(village4_solid_pollution);}
		}
		return smileys[0];
	}
	
	int production_class_current(plot p) {
		float w <- p.current_productivity; 
		switch(w) {
			match_between [0, 0.000079] {return 0;}
			match_between [0.00008, 0.000012] {return 1;}
			match_between [0.00013, 0.00019] {return 2;}
			match_between [0.0002, 0.00029] {return 3;}
			default {return 4;}	
		}
	}

	
	image_file water_pollution_smiley(float w) {
		switch(w) {
			match_between [0, 9999] {return smileys[0];}
			match_between [10000, 19999] {return smileys[1];}
			match_between [20000, 29999] {return smileys[2];}
			match_between [30000, 44999] {return smileys[3];}
			default {return smileys[4];}
		}
	}
	
	image_file water_pollution_class(village w) {
		switch (int(w)) {
			match 0 {return water_pollution_smiley(village1_water_pollution);}
			match 1 {return water_pollution_smiley(village2_water_pollution);}
			match 2 {return water_pollution_smiley(village3_water_pollution);}
			match 3 {return water_pollution_smiley(village4_water_pollution);}
		}
		return smileys[0];
	}
	
	image_file production_class (village v) {
		float w <- village_production[int(v)];
		if (int(v) = 0) {
			switch(w) {
				match_between [0, 349] {return smileys[4];}
				match_between [350, 699] {return smileys[3];}
				match_between [700, 899] {return smileys[2];}
				match_between [900, 1149] {return smileys[1];}
				default {return smileys[0];}
			}
		} else {
			switch(w) {
				match_between [0, 499] {return smileys[4];}
				match_between [500, 799] {return smileys[3];}
				match_between [800, 1099] {return smileys[2];}
				match_between [1100, 1499] {return smileys[1];}
				default {return smileys[0];}
			}
		}
		
	}
	
	
	int water_pollution_class_current(canal p) {
		float w <- p.pollution_density; 
		switch(w) {
			match_between [0, 0.9] {return 0;}
			match_between [1, 9] {return 1;}
			match_between [10, 19] {return 2;}
			match_between [20, 39] {return 3;}
			default {return 4;}
		}
	}
	
	map<village,list<string>> village_actions <- nil;
	action action_executed(string action_name) {
		if village_actions = nil or empty(village_actions) {
			loop v over: village {
				village_actions[v]<-[];
			}
		}
		list the_list <- village_actions[villages_order[index_player]];
		if the_list != nil {
					the_list <+ action_numbers[action_name];
		}

	} 
		
	
	action tell (string msg, bool add_name <- false) {
		 if (confirmation_popup) {
		 	invoke tell(msg, add_name);
		 }
	}
	
	
	action pause {
		about_to_pause <- true;
		ask experiment {do update_outputs;}
		invoke pause;
	}
	
	action resume {
		about_to_pause <- false;
		invoke resume;
	}
	
	/********************** PROPORTION OF THE DISPLAYS ****************************/
	
	int small_vertical_prop <- 1000;
	int large_vertical_prop <- 3500;
	int small_horizontal_prop <- 1500;
	int large_horizontal_prop <- 3000;

	
	/********************** POSITIONS AND SIZES ****************************/
	
	float y_icons -> shape.height - icon_size;
	float x_margin -> - shape.width / 20; 
	float icon_size -> shape.width / 8;
	point symbol_icon_size -> {icon_size,icon_size};
	point arrow_icon_size -> {icon_size/2,icon_size/2};
	point smiley_icon_size -> {2*icon_size/3,2*icon_size/3};
	

	bool active_button;
	int line_width <- 2;
	float chart_line_width <- 4.0;
	
	/********************** FONTS ************************************************/
	// UNCOMMENT FOR THE LATEST VERSION IN GAMA int text_size -> #hidpi ? (#fullscreen ? 100 : 30) : (#fullscreen ? 60 : 15);
	int text_size <- 30;
	font ui_font -> font("Impact", text_size, #bold);
	
	/******************* GENERAL PARAMETERS *************************************/
	
	bool confirmation_popup <- false;
	bool no_starting_actions <- true;
	bool about_to_pause <- false;
	float pause_started_time <- 0.0;
	
	/******************* USE TIMERS *************************************/
	bool use_timer_player_turn <- false;	
	bool use_timer_for_discussion <- true;
	
	bool timer_just_for_warning <- false; //if true, if the timer is finished, just a warning message is displayed; if false, the turn passes to the next player - for the moment, some issue with the automatic change of step
	float initial_time_for_discussion <- 2 #mn const: true; // time before the player turns
	//float time_for_discussion <- initial_time_for_discussion;
	
	
	/********************* SPECIAL FOR LEGENDS AND THE MAP ****************************/
	geometry show_players_button;
	geometry show_map_button;
	bool show_geography <- false;

	/********************** COLORS ************************************************/
	
	list<rgb> greens <- palette(rgb(237, 248, 233), rgb(186, 228, 179), rgb(116, 196, 118), rgb(49, 163, 84), rgb(0, 109, 44));
	list<rgb> blues <- reverse(palette(rgb(239, 243, 255), rgb(189, 215, 231), rgb(107, 174, 214), rgb(49, 130, 189), rgb(8, 81, 156)));
	list<rgb> reds <- palette(rgb(254, 229, 217), rgb(252, 174, 145), rgb(251, 106, 74), rgb(222, 45, 38), rgb(165, 15, 21));
	rgb map_background <- #black;
	rgb timer_background <- rgb(60,60,60);
	rgb legend_background <- rgb(60,60,60);
	int ambient_intensity <- 100;
	rgb landfill_color <- #chocolate;
	rgb city_color <- #gray;
	list<rgb> village_color <- [rgb(207, 41, 74), rgb(255, 201, 0), rgb(49, 69, 143), rgb(62, 184, 99)]; // color for the 4 villages
	
	/********************** ICONS *************************************************/
	
	image_file label_icon <- image_file("../../includes/icons/eco.png");
	image_file disabled_label_icon <- image_file("../../includes/icons/eco_disabled.png");
	image_file soil_icon <- image_file("../../includes/icons/soil.png");
	image_file tokens_icon <- image_file("../../includes/icons/tokens.png");
	image_file water_icon <- image_file("../../includes/icons/water.png");
	image_file plant_icon <- image_file("../../includes/icons/plant.png");
	list<image_file> numbers <- [1,2,3,4] collect image_file("../../includes/icons/"+each+"w.png");
	list<image_file> smileys <- [0,1,2,3,4] collect image_file("../../includes/icons/smiley"+each+".png");
	image_file calendar_icon <- image_file("../../includes/icons/upcoming.png");
	image_file discussion_icon <- image_file("../../includes/icons/conversation.png");
	image_file sandclock_icon <- image_file("../../includes/icons/hourglass.png");
	image_file computer_icon <- image_file("../../includes/icons/simulation.png");
	image_file next_icon <- image_file("../../includes/icons/fast-forward.png");
	image_file play_icon <- image_file("../../includes/icons/play.png");
	image_file pause_icon <- image_file("../../includes/icons/pause.png");
	image_file garbage_icon <- image_file("../../includes/icons/garbage.png");
	image_file city_icon <- image_file("../../includes/icons/office.png");
	image_file score_icon <- image_file("../../includes/icons/trophy.png");
	image_file schedule_icon <- image_file("../../includes/icons/schedule.png");
	image_file danger_icon <- image_file("../../includes/icons/danger.png");


	map<string, string> action_numbers <- [
				A_DUMPHOLES::"3",
				A_PESTICIDES::"4",
				//A_END_TURN::"",
				A_SENSIBILIZATION::"6",
				A_FILTERS::"2A",
				A_COLLECTIVE_LOW::"5A",
				A_COLLECTIVE_HIGH::"5B",
				A_DRAIN_DREDGES_HIGH::"7B",
				A_DRAIN_DREDGES_LOW::"7A",
				A_FALLOW::"9",
				A_MATURES_LOW::"8A",
				A_MATURES_HIGH::"8B",
				A_FILTER_MAINTENANCE::"2B",
				A_COLLECTION_LOW::"1A",
				A_COLLECTION_HIGH::"1B"
		];
	map<string, string> numbers_actions <- reverse(action_numbers);
	
	
	stacked_chart global_chart;
	int cycle_count;
	
	
	init {
		create stacked_chart {
			desired_value <- 1.0;
			max_value <- 2.0;
			do add_column("Production");
			do add_column("Total");
			do add_column("Water");
			do add_column("Soil");

			icons <- ["Total"::danger_icon, "Water"::water_icon, "Soil"::soil_icon, "Production"::plant_icon];
		 	inf_or_sup <- ["Total"::true,"Water"::true, "Soil"::true, "Production"::false];
		 	draw_smiley <- ["Total"::true,"Water"::false, "Soil"::false, "Production"::true];
			
			loop i from: 0 to: 3 {
				do add_element(village_color[i]);
			}
		}
		global_chart <- stacked_chart[0];

	}
	
	reflex update_charts when: stage = COMPUTE_INDICATORS{
		village_actions <- nil;
		cycle_count <- cycle_count + 1;
		
		ask global_chart{
			loop i from: 0 to: 3 {
				do update_all(village_color[i], ["Total"::(village_water_pollution[i] + village_solid_pollution[i])/max_pollution_ecolabel, "Water"::village_water_pollution[i]/max_pollution_ecolabel, "Soil"::village_solid_pollution[i]/max_pollution_ecolabel, "Production"::village_production[i]/min_production_ecolabel ]);
			}
		}	
		// TODO remove this at some point ! 
	time_for_discussion <- initial_time_for_discussion;			
	pause_started_time <- 0.0;
	}
	
	reflex end_of_discussion_turn when:  stage = PLAYER_DISCUSSION_TURN {
		remaining_time <- int(time_for_discussion - machine_time/1000.0  +start_discussion_turn_time/1000.0); 
		if remaining_time <= 0 {
			do end_of_discussion_phase;		
		}

	}
	

}




experiment Open {
	
	map<string, point> action_locations <- [];
	point next_location <- {0,0};
	point pause_location <- {0,0};
	string over_action;
	
	
	init {
		gama.pref_display_slice_number <- 128;
		gama.pref_display_show_rotation <- false;
		gama.pref_display_show_errors <- false;
		gama.pref_errors_display <- false;
		gama.pref_errors_stop <- false;
		gama.pref_errors_in_editor <- false;
		gama.pref_display_numkeyscam <- false;
	}
	
	output {
		
		/********************** LAYOUT ***********************************************************/
		
		layout
		
		vertical ([
			horizontal([0::small_horizontal_prop, 1::large_horizontal_prop, 2::small_horizontal_prop])::small_vertical_prop,
			3::large_vertical_prop]
		)

		toolbars: false tabs: false parameters: false consoles: false navigator: false controls: false tray: false background: #black;
		



		
		/********************** LEGEND DISPLAY *************************************************/
		
		display "LEGEND" type: opengl axes: false background: legend_background /*refresh: stage = COMPUTE_INDICATORS*/ {
			
		light #ambient intensity: ambient_intensity;
		camera #default locked: true;
				
		 graphics "overlay" position: {-simulation.shape.width/4, 0} transparency: 0 {
				float y_gap <- 0.3;
				float x_gap <- 0.1;
				float x_init <- 0.1;
				float y <- 0.2;
				float x <- x_init;
				

				draw plant_icon at: {x* shape.width,y*shape.height} size: x_gap*shape.width * 2;
				x <- x + 2* x_gap;
				loop c over: reverse(greens) {
					draw square(x_gap*shape.width) color: c at: {x* shape.width,y*shape.height};
					x <- x + x_gap;
				}

				y <- y + y_gap;
				x <- x_init;
				draw water_icon at: {x* shape.width,y*shape.height} size: x_gap*shape.width *2;
				x <- x + 2* x_gap;
				loop c over: blues {
					draw square(x_gap*shape.width) color: c at: {x* shape.width,y*shape.height};
					x <- x + x_gap;
				}

				/*****/				
				y <- y + y_gap;
				x <- x_init;
				draw garbage_icon at: {x* shape.width,y*shape.height} size: x_gap*shape.width * 2;
				x <- x + 2 * x_gap;
				draw square(x_gap*shape.width) color: landfill_color at: {x* shape.width,y*shape.height};
				x <- x + 2 * x_gap;
				draw city_icon at: {x* shape.width,y*shape.height} size: x_gap*shape.width * 2;
				x <- x + 2*x_gap;
				draw square(x_gap*shape.width) color: city_color at: {x* shape.width,y*shape.height};

				x <- 1.2;
				y <- 0.3;
				show_map_button <- square(shape.width/2) at_location {x* shape.width,y*shape.height};
				draw image_file("../../includes/icons/map.png") at: {x* shape.width,y*shape.height} size: shape.width/2;
				y <- y + 0.5;
				show_players_button <- square(shape.width/2) at_location {x* shape.width,y*shape.height};
				draw image_file("../../includes/icons/players.png") at: {x* shape.width,y*shape.height} size: shape.width/2;
			}
			
			event #mouse_down {
				
				using topology(simulation) {
					if (show_map_button.centroid distance_to #user_location) < world.shape.width / 3{
						write "Show map";
						show_geography <- true;
					} else if (show_players_button.centroid distance_to #user_location) < world.shape.width / 3{
						write "Show players";
						show_geography <- false;
					}
				}
			}


		}
		/********************** CENTER DISPLAY *************************************************/
		display "Controls" type: opengl axes: false background: timer_background  {
			
			camera #default locked: true;				

			light #ambient intensity: ambient_intensity;
			
			graphics "Turn#" position: {-simulation.shape.width, 0} {
				int value <- min(last(days_with_ecolabel_year),365);
				float total <- 365.0;
				float radius <- shape.width/2;
				float start_angle <-  - 180.0;
				float arc_angle <- (value * 180/total);
				draw arc(radius, start_angle + arc_angle/2, arc_angle) color: #green  ;
				start_angle <- start_angle + arc_angle;
				arc_angle <- (total - value) * 180/total;
				draw arc(radius, start_angle + arc_angle/2, arc_angle) color: #darkred ;
				draw schedule_icon size: shape.width / 6;
				draw ""+value at:{location.x, location.y- radius/2, 0.01} color: #white font: ui_font anchor: #bottom_center;
			}
			
			
			graphics "Score#" position: {simulation.shape.width, 0}{
				int value <- days_with_ecolabel;
				float total <- 365.0 * end_of_game;
				float radius <- shape.width/2;
				float start_angle <-  - 180.0;
				float arc_angle <- (value * 180/total);
				draw arc(radius, start_angle + arc_angle/2, arc_angle) color: #green;
				start_angle <- start_angle + arc_angle;
				arc_angle <- (total - value) * 180/total;
				draw arc(radius, start_angle + arc_angle/2, arc_angle) color: #darkred;
				draw score_icon size: shape.width / 6;
				draw ""+value  at: {location.x, location.y- radius/2, 0.01}  color: #gold font: ui_font anchor: #bottom_center;
			}
		
			
			//graphics "Label" position: {0,-simulation.shape.height/3} transparency: last(days_with_ecolabel_year) >= 183 ? 0 : 0.8 {
			//	draw label_icon size: 2 * shape.width / 5;
			//}

			graphics "Jauge for the turns" {
				float y <- location.y - shape.height/4 - shape.height/8;
				float left <- location.x - shape.width/2;
				float right <- location.x + shape.width/2;
				draw ""+turn  color: #white font: ui_font anchor: #left_center at: {right + 500, y};
				draw line({left, y}, {right, y}) buffer (100, 200) color: #white;
				float width <- cycle_count * shape.width / (simulation.end_of_game * 365);
				draw line({left, y}, {left + width, y}) buffer (100, 200) color: #darkred;
				draw calendar_icon at: {left + width, y} size: shape.height/6;
			}
			
			graphics "Jauge for the discussion" visible: stage = PLAYER_DISCUSSION_TURN and turn <= end_of_game {
				float y <- location.y + 3*shape.height/8;
				float left <- location.x - shape.width/2;
				float right <- location.x + shape.width/2;
				draw "" + int(remaining_time) + "s" color: #white font: ui_font anchor: #left_center at: {right + 500, y};
				draw line({left, y}, {right, y}) buffer (100, 200) color: #white;
				float width <- (initial_time_for_discussion - remaining_time) * (right - left) / (initial_time_for_discussion);
				draw line({left, y}, {left + width, y}) buffer (100, 200) color: #darkgreen;
				draw sandclock_icon /*rotate: (180 - remaining_time)*3*/ at: {left + width, y} size: shape.height / 6;
			}

			graphics "Actions of players" visible: stage = PLAYER_ACTION_TURN {
				float y <- location.y + 3*shape.height/8;
				float left <- location.x - shape.width + shape.width / 5;
				float right <- location.x + shape.width - shape.width / 5;
				float gap <- (right - left) / length(simulation.numbers_actions);
				float index <- 0.5;
				loop s over: (sort(simulation.numbers_actions.keys, each)) {
					village v <- villages_order[index_player];
					bool selected <- village_actions[v] != nil and village_actions[v] contains s;
					draw s color: selected or over_action = s ? #white : rgb(255, 255, 255, 130) font: ui_font anchor: #center at: {left + gap * index, y};
					if (selected) {
						draw circle(shape.width / 10) wireframe: true width: line_width color: #white at: {left + gap * index, y};
					}

					action_locations[s] <- {left + gap * index, y};
					index <- index + 1;
				}

			}

			graphics "Stage" position: {0,0 } {
				image_file icon <- (stage = PLAYER_DISCUSSION_TURN) ? discussion_icon : ((stage = PLAYER_ACTION_TURN) ? numbers[int(villages_order[index_player])] : computer_icon);
				draw icon size: shape.width / 4;
			}

			graphics "Next" transparency: ((stage = PLAYER_DISCUSSION_TURN or stage = PLAYER_ACTION_TURN) and turn <= end_of_game) ? 0 : 0.6 {
				next_location <- {location.x + shape.width / 2, location.y};
				draw next_icon at: next_location size: shape.width / 4;
			}

			graphics "Play Pause" visible: turn <= end_of_game {
				pause_location <- {location.x - shape.width / 2, location.y};
				draw simulation.paused or about_to_pause ? play_icon : pause_icon at: pause_location size: shape.width / 4;
			}
			
						event "1" {
				ask simulation {
					do execute_action(A_COLLECTION_LOW);
				}

			}

			event "a" {
				ask simulation {
					do execute_action(A_COLLECTION_HIGH);
				}

			}

			event "2" {
				ask simulation {
					do execute_action(A_FILTERS);
				}

			}

			event "b" {
				ask simulation {
					do execute_action(A_FILTER_MAINTENANCE);
				}

			}

			event "3" {
				ask simulation {
					do execute_action(A_DUMPHOLES);
				}

			}

			event "c" {
				ask simulation {
					do execute_action(A_DUMPHOLES);
				}

			}

			event "4" {
				ask simulation {
					do execute_action(A_PESTICIDES);
				}

			}

			event "d" {
				ask simulation {
					do execute_action(A_PESTICIDES);
				}

			}

			event "5" {
				ask simulation {
					do execute_action(A_COLLECTIVE_LOW);
				}

			}

			event "e" {
				ask simulation {
					do execute_action(A_COLLECTIVE_HIGH);
				}

			}

			event "6" {
				ask simulation {
					do execute_action(A_SENSIBILIZATION);
				}

			}

			event "f" {
				ask simulation {
					do execute_action(A_SENSIBILIZATION);
				}

			}

			event "7" {
				ask simulation {
					do execute_action(A_DRAIN_DREDGES_LOW);
				}

			}

			event "g" {
				ask simulation {
					do execute_action(A_DRAIN_DREDGES_HIGH);
				}

			}

			event "8" {
				ask simulation {
					do execute_action(A_MATURES_LOW);
				}

			}

			event "h" {
				ask simulation {
					do execute_action(A_MATURES_HIGH);
				}

			}

			event "9" {
				ask simulation {
					do execute_action(A_FALLOW);
				}

			}

			event "i" {
				ask simulation {
					do execute_action(A_FALLOW);
				}

			}

			event "0" {
				ask simulation {
					do before_start_turn;
				}

			}

			event #mouse_move {
				using topology(simulation) {
					if (stage = PLAYER_ACTION_TURN) {
						loop s over: action_locations.keys {
							if (action_locations[s] distance_to #user_location < world.shape.width / 10) {
								over_action <- s;
								return;
							}

						}

					}

					over_action <- "";
				}

			}

			event #mouse_down {
				using topology(simulation) {
					if (next_location distance_to #user_location) < world.shape.width / 3 {
						if (turn > end_of_game) {
							return;
						}
						if (stage = PLAYER_DISCUSSION_TURN) {
							ask simulation {
								do end_of_discussion_phase;
							}

						} else if (stage != COMPUTE_INDICATORS) {
							ask simulation {
								ask villages_order[index_player] {
									do end_of_turn;
								}

							}

						}

					}

					if (pause_location distance_to #user_location) < world.shape.width / 3 {
						ask simulation {
							if paused or about_to_pause {
								if (pause_started_time > 0) {
									time_for_discussion <- time_for_discussion + int((gama.machine_time - pause_started_time) / 1000);
								}

								pause_started_time <- 0.0;
								do resume;
							} else {
								pause_started_time <- gama.machine_time;
								do pause;
							}

						}

					}

					if (stage = PLAYER_ACTION_TURN and over_action != nil) {
						ask simulation {
							write "execute " + myself.over_action;
							do execute_action(numbers_actions[myself.over_action]);
						}

						over_action <- nil;
						return;
					}

				}

			}
			
		
	}
		


		/********************** CHARTS DISPLAY ***************************************************/
		
		display "Chart 4" type: opengl axes: false background: #fullscreen ? #black:legend_background refresh: stage = COMPUTE_INDICATORS and every(data_frequency#cycle) {
			
			light #ambient intensity: ambient_intensity;
			
			camera 'default' location: {3213.0194,2461.1095,7816.3615} target: {3213.0194,2460.973,0.0};						
			
			agents "Global" value: [global_chart] aspect: horizontal visible: !#fullscreen;
			
			chart WASTE_POLLUTION  size:{1, 0.5} type: xy background: #black color: #white visible: #fullscreen label_font: ui_font {
				data SOLID_WASTE_POLLUTION value:rows_list(matrix([time_step,total_solid_pollution_values])) color: #gray marker: false thickness: chart_line_width ;
				data WATER_WASTE_POLLUTION value: rows_list(matrix([time_step,total_water_pollution_values])) color: #orange marker: false thickness: chart_line_width;
		 		data TOTAL_POLLUTION value:rows_list(matrix([time_step,total_pollution_values])) color:is_pollution_ok ? #green: #red marker: false thickness: chart_line_width;
		 		data ECOLABEL_MAX_POLLUTION value:rows_list(matrix([time_step,ecolabel_max_pollution_values])) color: #white marker: false thickness: chart_line_width;
			}
			
			chart PRODUCTION type: xy position:{0, 0.5}  size:{1, 0.5} background: #black color: #white y_range:[0,6000] visible: #fullscreen {
				data TOTAL_PRODUCTION value: rows_list(matrix([time_step,total_production_values])) color: is_production_ok ? #green : #red thickness: chart_line_width marker: false; 
				data ECOLABEL_MIN_PRODUCTION value: rows_list(matrix([time_step,ecolabel_min_production_values])) thickness: chart_line_width color: #white marker: false; 
			}		
		}
		
		
		
		/********************** MAIN MAP DISPLAY ***************************************************/
		
		display "MAIN MAP" type: opengl background:map_background axes: false {
			
			light #ambient intensity: ambient_intensity;
			
			camera 'default' location: {3213.0194,2444.8489,6883.1631} target: {3213.0194,2444.7288,0.0};
			
			


			species plot visible: stage = COMPUTE_INDICATORS or show_geography{
				draw shape color: greens[world.production_class_current(self)] border: false;
			}
			species canal visible: stage = COMPUTE_INDICATORS or show_geography{
				draw shape buffer (20,10) color: blues[world.water_pollution_class_current(self)] ;
			}
			species local_landfill visible: stage = COMPUTE_INDICATORS or show_geography{
				draw  shape depth: waste_quantity / 100.0 color: landfill_color;
			}
			species communal_landfill visible: stage = COMPUTE_INDICATORS or show_geography{
				draw  shape depth: waste_quantity / 100.0 color: landfill_color;
			}
			species urban_area visible: stage = COMPUTE_INDICATORS or show_geography;
			
			
			species village visible: (!show_geography and (stage != COMPUTE_INDICATORS)) {
				draw shape color: color border: #black width: 2;
			}
			species village visible: !show_geography and (stage != COMPUTE_INDICATORS) transparency: 0.6{
				draw circle(world.shape.width/8) 	color: #black at: shape.centroid;
			}
			
			species village visible: !show_geography and (stage != COMPUTE_INDICATORS){
				float size <- world.shape.width/10;
				draw numbers[int(self)] at: shape.centroid size: world.shape.width/15;
			}
			
			species village visible: !show_geography and (stage != COMPUTE_INDICATORS){
				int i <- int(self);
				float size <- world.shape.width/20;
				float spacing <- size * 1;
				float smiley_vertical_spacing <- size/2;
				float smiley_horizontal_spacing <- smiley_vertical_spacing;
				float smiley_size <- 2*size/3;
				float x <- shape.centroid.x - spacing;
				float y <- shape.centroid.y - spacing;
				draw soil_icon at: {x, y} size: size;
				draw world.soil_pollution_class(self) at: {x - smiley_horizontal_spacing , y + smiley_vertical_spacing} size: smiley_size;
				
				x <- x + 2*spacing;
				
				draw water_icon at: {x,  y} size: size;
				draw world.water_pollution_class(self) at: {x + smiley_horizontal_spacing , y + smiley_vertical_spacing} size: smiley_size;
				
				y <- y + 2*spacing;
				draw tokens_icon at: {x,  y} size: size;
				draw ""+budget at: {x, y + spacing} color: #white depth: 5 font: ui_font anchor: #bottom_center;
				
				x <- x - 2*spacing;
				draw plant_icon at: {x, y} size: size;
				draw world.production_class(self) at: {x - smiley_horizontal_spacing , y + smiley_vertical_spacing} size: smiley_size;
			}
			
		}
		


	}

	
}



species stacked_chart {
	point location <- {world.shape.width/2 ,world.shape.height/2};
	map<string, map<rgb,float>> data <- [];
	map<string, image_file> icons <- [];
	map<string, bool> inf_or_sup ;
	map<string, bool> draw_smiley;
	float chart_width <- 2* world.shape.width;
	float chart_height <- world.shape.height;
	float max_value;
	float desired_value;
	
	
	action add_column(string column) {
		if (!(column in data.keys)) {
			data[column] <- [];
		}
	}
	
	action add_element(rgb element) {
		loop c over: data.keys {
			data[c][element] <- 0.0;
		}
 	}
 	
 	action update(string column, rgb element, float value) {
 		data[column][element] <- value;
 	}
 	
 	action update_all(rgb element, map<string, float> values) {
 		loop col over: data.keys {
 			data[col][element] <- values[col];
 		}
 	}
 	
 	aspect horizontal {
 		float my_width <- chart_width;
 		float my_height <- chart_height;
 		float col_width <- my_width / ((length(data) + 4));
 		bool gap_added <- false;
 		int col_index <- 0;
 		loop col over: data.keys {
 			float current_y <-0.0;

 			float total <- 0.0;
 			if (!draw_smiley[col] and !gap_added) {
 				col_index <- col_index + 2;
 				gap_added <- true;
 			}
 			float current_x <- col_index * col_width - col_width/2;
 			loop c over: data[col].keys {
 				float v <- data[col][c];
 				total <- total+v;
 				
 				float col_height <- (v * chart_height)/max_value;
 				draw rectangle(col_width,col_height) color: c at: {current_x,my_height  + current_y - col_height/2};
 				draw rectangle(col_width,col_height) wireframe: true border: #black width: 2 at: {current_x,my_height  + current_y -  col_height/2};
 				current_y <- current_y - col_height;
 			}
 			if (icons[col] != nil) {
 				draw icons[col] at: {current_x, my_height-500} size: {col_width/2, col_width/2};
 				if draw_smiley[col] {
 				if (total <= 1 and inf_or_sup[col] or total > 1 and !inf_or_sup[col]) {
 					draw smileys[0]  at: {current_x, my_height - 1000} size: {col_width/4, col_width/4};
 				} else {draw smileys[4]  at: {current_x, my_height - 1000} size: {col_width/4, col_width/4};}} 
 			}
 			col_index <- col_index + 1;
 		}
 		draw line({location.x - 3*col_width, location.y + chart_height/2 - desired_value*chart_height/max_value},{location.x, location.y + chart_height/2 - desired_value*chart_height/max_value}) color: #white width: 5;
 		draw (is_pollution_ok and is_production_ok) ? label_icon:disabled_label_icon at: {location.x, location.y + chart_height/2.5 - desired_value*chart_height/max_value} size: 1.5*col_width ;
 	}

 	
}