/**
* Name: U1
* The model used for the main demonstrations
* Author: A. Drogoul
* 
* This model has been designed using resources (icons) from Flaticon.com
* 
* Tags: 
*/

model UI1


 
import "../Global.gaml"
 
global {
	
	bool CHOOSING_VILLAGE_FOR_POOL <- false;
	bool PASS_CHOOSING_VILLAGE <- false;
	float initial_time_for_choosing_village <- 1#mn;
	float time_for_choosing_village <- initial_time_for_choosing_village;
	float start_choosing_village_time;
	int remaining_time_for_choosing_village <- 0;
	int chosen_village <- -1;
	int number_of_days_passed <- 0;
	float w_height <- shape.height;
	float w_width <- shape.width;
	bool display_water_flow <- false;
	
	
	
	action choose_village_for_pool {
		if (not CHOOSING_VILLAGE_FOR_POOL) {
			commune_money <- 0;
			ask village {
				commune_money <- commune_money + budget;
				budget <- 0;
			}
			CHOOSING_VILLAGE_FOR_POOL <- true;
			start_choosing_village_time <- gama.machine_time;
		}
	}	
	
	
	reflex end_of_choosing_village when: CHOOSING_VILLAGE_FOR_POOL {
		remaining_time_for_choosing_village <- int(time_for_choosing_village - machine_time/1000.0  +start_choosing_village_time/1000.0); 
		if remaining_time_for_choosing_village <= 0 or chosen_village > -1 or PASS_CHOOSING_VILLAGE{
			if (chosen_village > -1){
				villages_order << village[chosen_village];
				ask village[chosen_village] {
					budget <- commune_money;
				}
				do before_start_turn();
			} else {
				commune_budget_dispatch <- true;
			}
			CHOOSING_VILLAGE_FOR_POOL <- false;
			PASS_CHOOSING_VILLAGE <- false;
			chosen_village  <- -1;
			commune_money <- 0;
			to_refresh <- true;
		}
	}
	
	image_file soil_pollution_smiley (float v) {
		switch(v) {
			match_between [0, 19999] {return smileys[0];}
			match_between [20000, 29999] {return smileys[1];}
			match_between [30000, 64999] {return smileys[2];}
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
			match_between [0, 4999] {return smileys[0];}
			match_between [5000, 14999] {return smileys[1];}
			match_between [15000, 29999] {return smileys[2];}
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
				match_between [0, 199] {return smileys[4];}
				match_between [200, 499] {return smileys[3];}
				match_between [500, 799] {return smileys[2];}
				match_between [800, 1149] {return smileys[1];}
				default {return smileys[0];}
			}
		} else {
			switch(w) {
				match_between [0, 299] {return smileys[4];}
				match_between [300, 699] {return smileys[3];}
				match_between [700, 999] {return smileys[2];}
				match_between [1000, 1499] {return smileys[1];}
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
				the_list <+ action_name;
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
	
	float chart_line_width -> #fullscreen ? 4.0 : 4.0;
	
	/********************** FONTS ************************************************/
	// UNCOMMENT FOR THE LATEST VERSION IN GAMA 
	int text_size -> #hidpi ? (#fullscreen ? 100 : 30) : (#fullscreen ? 60 : 15);
	//int text_size <- 30;
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
	float initial_time_for_discussion <- 2.5 #mn const: true; // time before the player turns
	//float time_for_discussion <- initial_time_for_discussion;
	
	
	/********************* SPECIAL FOR LEGENDS AND THE MAP ****************************/
	geometry show_waterflow_button;
	geometry show_map_button;
	geometry show_chart_button;
	bool show_map_selected;
	bool show_chart_selected;
	bool show_waterflow_selected;
	bool show_geography <- true;
	bool show_chart <- false;
	bool show_player_numbers <- true;
	bool play_pause_selected <- false;
	bool next_selected <- false;

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
	rgb selected_color <- rgb(255,255,255);
	rgb unselected_color <- rgb(200,200,200,0.7);
	list<rgb> village_color <- [rgb(207, 41, 74), rgb(255, 201, 0), rgb(49, 69, 143), rgb(62, 184, 99)]; // color for the 4 villages
	
	/********************** ICONS *************************************************/
	
	image_file label_icon <- image_file("../../includes/icons/eco.png");
	image_file disabled_label_icon <- image_file("../../includes/icons/eco_disabled.png");
	image_file soil_icon <- image_file("../../includes/icons/waste.png");
	image_file tokens_icon <- image_file("../../includes/icons/tokens.png");
	image_file water_icon <- image_file("../../includes/icons/water.png");
	image_file plant_icon <- image_file("../../includes/icons/plant.png");
	list<image_file> numbers <- [1,2,3,4] collect image_file("../../includes/icons/"+each+"w.png");
	list<image_file> smileys <- [0,1,2,3,4] collect image_file("../../includes/icons/smiley"+each+".png");
	image_file calendar_icon <- image_file("../../includes/icons/upcoming.png");
	image_file discussion_icon <- image_file("../../includes/icons/conversation.png");
	image_file sandclock_icon <- image_file("../../includes/icons/hourglass.png");
	image_file computer_icon <- image_file("../../includes/icons/simulation.png");
	image_file next_icon <- image_file("../../includes/icons/button_fast-forward.png");
	image_file play_icon <- image_file("../../includes/icons/button_play.png");
	image_file pause_icon <- image_file("../../includes/icons/button_pause.png");
	image_file garbage_icon <- image_file("../../includes/icons/garbage.png");
	image_file city_icon <- image_file("../../includes/icons/city.png");
	image_file score_icon <- image_file("../../includes/icons/trophy.png");
	image_file danger_icon <- image_file("../../includes/icons/pollution.png");
	
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
	number_of_days_passed <- number_of_days_passed + 1;
	}
	
	reflex end_of_discussion_turn when:  stage = PLAYER_DISCUSSION_TURN {
		remaining_time <- int(time_for_discussion - machine_time/1000.0  +start_discussion_turn_time/1000.0); 
		if remaining_time <= 0 {
			do end_of_discussion_phase;		
		}

	}
	

	// DISPLAY OF WATER DYNAMICS
	graph canal_network_<- nil;
	int number_to_add <- 10;
	map<point, list<point>> possible_targets;
	
	reflex add_waste when: display_water_flow and every(25 #cycle){
		if canal_network_ = nil {
			canal_network_ <- directed(as_edge_graph(canal));
			list<point> sources <- canal_network_.vertices where (empty(canal_network_ in_edges_of each));
			list<point> targets <- canal_network_.vertices where (empty(canal_network_ out_edges_of each));
			loop s over: sources {
				list<point> ts <- [];
				loop t over: targets {
					if (canal_network_ path_between(s,t)) != nil {
						ts << t;
					}
				}
				
				possible_targets[s] <- ts;
			}
		}
		
		
		create waste_on_canal number: number_to_add {
			location <- one_of(possible_targets.keys);
			target <- one_of (possible_targets[location]);
		}
	}
}


species waste_on_canal skills: [moving]{
	point target;
	point prev_loc <- copy(location);
	
	reflex move {
	 	speed <- ((int(duration) = 0) ? 50 : ( int(duration))) / step;
		prev_loc <- copy(location);
		do goto target: target on:canal_network_ ;
		if location = target or location = prev_loc{
			do die;
		}
	}
}


experiment Open {
	
	map<string, point> action_locations <- [];
	map<int,point> village_locations <- [];
	point next_location <- {0,0};
	point pause_location <- {0,0};
	string over_action;
	int over_village;
	
	
	init {
		gama.pref_display_slice_number <- 12; /* 128 too slow ! */
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
		
		
//		graphics "Frame (new version of GAMA)" refresh: true border: #white size: {w_width*2, 1} position: {-w_width/4,0}{
//		}
		
//	graphics "Frame (old version of GAMA)" refresh: true visible: show_geography {
			//draw rectangle(w_width, 0.7*w_height) at_location {0.35*w_width + w_width/2 - w_width/6, w_height/2 + w_width/12} border: #white width: 5 color: legend_background;
//		}
		
				
		 graphics "overlay" position: {0, 0} transparency: 0 refresh: true visible: show_geography {
				float y_gap <- 0.25;
				float x_gap <- 0.1;
				float x_init <- 0.35;
				float icon_size <-  w_height / 6;
				float y <- 0.2;
				float x <- x_init;
				

				draw plant_icon at: {x* w_width,y*w_height} size: icon_size;
				x <- x + 2* x_gap;
				loop c over: reverse(greens) {
					draw square(x_gap*w_width) color: c at: {x*w_width,y*w_height};
					x <- x + x_gap;
				}

				y <- y + y_gap;
				x <- x_init;
				draw water_icon at: {x* w_width,y*w_height} size: icon_size;
				x <- x + 2* x_gap;
				loop c over: blues {
					draw square(x_gap*w_width) color: c at: {x*w_width,y*w_height};
					x <- x + x_gap;
				}

				/*****/				
				y <- y + y_gap;
				x <- x_init;
				draw garbage_icon at: {x*w_width,y*w_height} size:  icon_size;
				x <- x + 2 * x_gap;
				draw square(x_gap*w_width) color: landfill_color at: {x* w_width,y*w_height};
				x <- x + 2 * x_gap;
				draw city_icon at: {x*w_width,y*w_height} size:  icon_size;
				x <- x + 2*x_gap;
				draw square(x_gap*w_width) color: city_color at: {x* w_width,y*w_height};

			}
			
			graphics "Buttons" {
				float x <- 0.0;
				float y <- 0.25;
				show_map_button <-  circle(w_width/8) at_location {x*w_width,y*w_height};
				//draw show_map_button color: (show_map_selected ?  #white : #black) ;
				draw image_file(show_geography ? "../../includes/icons/button_map_off.png":"../../includes/icons/button_map_on.png") color: show_map_selected ? selected_color:unselected_color size: w_width/4 at: {x*w_width,y*w_height} ;
			}
			
			graphics "Button flow" visible: show_geography{
				float x <- 0.0;
				float y <- 0.65;
				show_waterflow_button <- circle(w_width/8) at_location {x*w_width,y*w_height};
				//draw show_waterflow_button color: (show_waterflow_selected ?  #white : #black);
				draw image_file(display_water_flow ? "../../includes/icons/button_waterflow_off.png":"../../includes/icons/button_waterflow_on.png") color: show_waterflow_selected ? selected_color:unselected_color size: w_width/4 at: {x*w_width,y*w_height} ;
			}
			
			event #mouse_move {
				using topology(simulation) {
					show_map_selected <- (show_map_button covers #user_location) ;
					show_waterflow_selected <- (show_waterflow_button covers #user_location) ;
				}
			}
			
			event #mouse_exit {
					show_map_selected <- false;
					show_waterflow_selected <- false;
			}
			
			event #mouse_down {
				if (show_map_selected) {
					show_geography <- !show_geography;
				} else if (show_waterflow_selected) {
					display_water_flow <- !display_water_flow;
				}
			}


		}
		/********************** CENTER DISPLAY *************************************************/
		display "Controls" type: opengl axes: false background: map_background  {
			
			camera #default locked: true;				

			light #ambient intensity: ambient_intensity;
			
			graphics "Turn#" position: {-w_width, 0} {
				int value <- number_of_days_passed;
				float total <- 365.0 * end_of_game;
				float radius <- w_width/2;
				float start_angle <-  - 180.0;
				float arc_angle <- (value * 180/total);
				draw arc(radius, start_angle + arc_angle/2, arc_angle) color: #gray;
				start_angle <- start_angle + arc_angle;
				arc_angle <- (total - value) * 180/total;
				draw arc(radius, start_angle + arc_angle/2, arc_angle) color: #darkred;
//				start_angle <-  -180;
//				float aa <- 180/end_of_game;
//				loop i from: 0 to: end_of_game-1 {
//					draw arc(radius, start_angle + aa*i + aa/2, aa) color: #black wireframe: true width: 5;
//				}
				
				
				draw calendar_icon size: w_width / 6;
				draw ""+value + " [" +value div 365 + "]" at: {location.x, location.y- radius/2, 0.01}  color: #white font: ui_font anchor: #bottom_center;
			}
			
			
			graphics "Score#" position: {w_width, 0}{
				int value <- days_with_ecolabel;
				float total <- 365.0 * end_of_game;
				float radius <- w_width/2;
				float start_angle <-  - 180.0;
				float arc_angle <- (value * 180/total);
				draw arc(radius, start_angle + arc_angle/2, arc_angle) color: #darkgreen;
				start_angle <- start_angle + arc_angle;
				arc_angle <- (total - value) * 180/total;
				draw arc(radius, start_angle + arc_angle/2, arc_angle) color: #darkred;
				draw (is_pollution_ok and is_production_ok) ? label_icon:disabled_label_icon size: w_width / 4;
				draw ""+value  at: {location.x, location.y- radius/2, 0.01}  color: #white font: ui_font anchor: #bottom_center;
			}
		
			
			graphics "Timer for the discussion" visible: stage = PLAYER_DISCUSSION_TURN and turn <= end_of_game {
				float y <- location.y + w_height/5;
				float left <- location.x - w_width/2;
				float right <- location.x + w_width/2;
				draw "" + int(remaining_time) + "s" color: #white font: ui_font anchor: #left_center at: {right + 500, y};
				draw line({left, y}, {right, y}) buffer (100, 200) color: #white;
				float width <- (initial_time_for_discussion - remaining_time) * (right - left) / (initial_time_for_discussion);
				draw line({left, y}, {left + width, y}) buffer (100, 200) color: #darkgreen;
				draw sandclock_icon /*rotate: (180 - remaining_time)*3*/ at: {left + width, y} size: w_height / 6;
			}
			
			
			graphics "Timer for the village choice" visible: CHOOSING_VILLAGE_FOR_POOL and turn <= end_of_game {
				float y <- location.y + 3*w_height/8;
				float left <- location.x - w_width/2;
				float right <- location.x + w_width/2;
				draw "" + int(remaining_time_for_choosing_village) + "s" color: #white font: ui_font anchor: #left_center at: {right + 500, y};
				draw line({left, y}, {right, y}) buffer (100, 200) color: #white;
				float width <- (initial_time_for_choosing_village - remaining_time_for_choosing_village) * (right - left) / (initial_time_for_choosing_village);
				draw line({left, y}, {left + width, y}) buffer (100, 200) color: #darkgreen;
				draw sandclock_icon /*rotate: (180 - remaining_time)*3*/ at: {left + width, y} size: w_height / 6;
			}	

			graphics "Choose village" visible: CHOOSING_VILLAGE_FOR_POOL {
				float y <- location.y + w_height/5;
				float left <- location.x - w_width/2;
				float right <- location.x + w_width/2;
				float gap <- (right - left) /4;
				float index <- 0.5;
				loop s over: numbers {
					int village_index <- int(index - 0.5);
					bool selected <- over_village = village_index;
					draw s size: w_width / 10 at: {left + gap * index, y};
					if (selected) {
						draw circle(w_width / 10) wireframe: true width: 2 color: #white at: {left + gap * index, y};
					}
					village_locations[village_index] <- {left + gap * index, y};
					index <- index + 1;
				}

			}		

			graphics "Actions of players" visible: stage = PLAYER_ACTION_TURN and !CHOOSING_VILLAGE_FOR_POOL {
				
				float y <- location.y + w_height/5;
				float left <- location.x - w_width + w_width / 5;
				float right <- location.x + w_width - w_width / 5;
				float gap <- (right - left) / length(actions_name_without_end);
				float index <- 0.5;
				loop s over: (sort(actions_name_without_end, each)) {
					village v <- villages_order[index_player];
					bool selected <- village_actions[v] != nil and village_actions[v] contains s;
					draw s color:  s = over_action or selected ? #white : rgb(255, 255, 255, 130) font: ui_font anchor: #center at: {left + gap * index, y};
					if (selected) {
						draw circle(w_width / 10) wireframe: true width: 2 color: #white at: {left + gap * index, y};
					}

					action_locations[s] <- {left + gap * index, y};
					index <- index + 1;
				}

			}

			graphics "Stage"  {
				image_file icon;
				if (stage = PLAYER_DISCUSSION_TURN) {
					icon <- discussion_icon; 
				} else if (stage = PLAYER_ACTION_TURN) {
					if (CHOOSING_VILLAGE_FOR_POOL) {
						icon <- tokens_icon;
					} else {
						icon <- numbers[int(villages_order[index_player])];
					}
				} else {
					icon <- computer_icon;
				}
				draw icon size: w_width / 3 at:  {location.x, location.y-w_height/8};
			}
			
			graphics "Money" position: {0,0 } visible: CHOOSING_VILLAGE_FOR_POOL {
				draw ""+commune_money  at: {location.x, location.y- w_width/4, 0.01}  color: #gold font: ui_font anchor: #bottom_center;
			}

			graphics "Next" transparency: ((stage = PLAYER_DISCUSSION_TURN or stage = PLAYER_ACTION_TURN) and turn <= end_of_game) ? 0 : 0.6 {
				next_location <- {location.x + w_width /2,  location.y-w_height/8};
				draw next_icon at: next_location size: w_width / 4 color: (next_selected and ((stage = PLAYER_DISCUSSION_TURN or stage = PLAYER_ACTION_TURN) and turn <= end_of_game)) ? selected_color:unselected_color;
			}

			graphics "Play Pause" visible: turn <= end_of_game {
				pause_location <- {location.x - w_width / 2, location.y- w_height/8};
				draw simulation.paused or about_to_pause ? play_icon : pause_icon at: pause_location color: play_pause_selected ? selected_color:unselected_color size: shape.width / 4;
			}
			
			event "1" {
				ask simulation {
					do execute_action(A_1);
				}

			}

			event "2" {
				ask simulation {
					do execute_action(A_2a);
				}

			}

			event "b" {
				ask simulation {
					do execute_action(A_2b);
				}

			}

			event "3" {
				ask simulation {
					do execute_action(A_3);
				}

			}

			event "c" {
				ask simulation {
					do execute_action(A_3);
				}

			}

			event "4" {
				ask simulation {
					do execute_action(A_4);
				}

			}

			event "d" {
				ask simulation {
					do execute_action(A_4);
				}

			}

			event "5" {
				ask simulation {
					do execute_action(A_5a);
				}

			}

			event "e" {
				ask simulation {
					do execute_action(A_5b);
				}

			}

			event "6" {
				ask simulation {
					do execute_action(A_6);
				}

			}

			event "f" {
				ask simulation {
					do execute_action(A_6);
				}

			}

			event "7" {
				ask simulation {
					do execute_action(A_7a);
				}

			}

			event "g" {
				ask simulation {
					do execute_action(A_7b);
				}

			}

			event "8" {
				ask simulation {
					do execute_action(A_8a);
				}

			}

			event "h" {
				ask simulation {
					do execute_action(A_8b);
				}

			}

			event "9" {
				ask simulation {
					do execute_action(A_9);
				}

			}

			event "i" {
				ask simulation {
					do execute_action(A_9);
				}

			}

			event "0" {
				ask simulation { 
					do before_start_turn;
				}

			}
			
			event #mouse_exit {
				next_selected <- false;
				play_pause_selected <- false;				
			}

			event #mouse_move {
				using topology(simulation) {
					if (stage = PLAYER_ACTION_TURN) {
						if (CHOOSING_VILLAGE_FOR_POOL) {
							loop s over: [0, 1, 2, 3] {
								if (village_locations[s] distance_to #user_location < w_width / 10) {
									over_village <- s;
									return;
								}
							}
						} else {
							loop s over: action_locations.keys {
								if (action_locations[s] distance_to #user_location < w_width / 10) {
									over_action <- s;
									return;
								}
							}
						}
					}
					next_selected <- (next_location distance_to #user_location) < w_width / 5;
					play_pause_selected <- (pause_location distance_to #user_location) < w_width / 5;
					over_action <- nil;
					over_village <- -1;
				}

			}

			event #mouse_down {
				if (stage = PLAYER_ACTION_TURN and over_action != nil) {
					ask simulation {
						do execute_action(myself.over_action);
					}

					over_action <- nil;
					return;
				}

				if (CHOOSING_VILLAGE_FOR_POOL and over_village > -1) {
					chosen_village <- over_village;
					over_village <- -1;
					return;
				}
				using topology(simulation) {
					if (next_location distance_to #user_location) < w_width / 5 {
						if (turn > end_of_game) {
							return;
						}

						if (stage = PLAYER_DISCUSSION_TURN) {
							ask simulation {
								do end_of_discussion_phase;
							}

						} else if (stage != COMPUTE_INDICATORS) {
							if (CHOOSING_VILLAGE_FOR_POOL) {
								PASS_CHOOSING_VILLAGE <- true;
							} else {
								ask simulation {
									ask villages_order[index_player] {
										do end_of_turn;
									}

								}

							}

						}

					} else if (pause_location distance_to #user_location) < w_width / 5 {
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

				}

			}
			
		
	}
		


		/********************** CHARTS DISPLAY ***************************************************/
		
		display "Chart 4" type: opengl axes: false background: #fullscreen ? #black:legend_background refresh: stage = COMPUTE_INDICATORS and every(data_frequency#cycle) {
			
			light #ambient intensity: ambient_intensity;
			camera #default locked: true;
			
			
						
			chart WASTE_POLLUTION  size:{1, 0.5} type: xy background: legend_background color: #white visible: !show_chart label_font: ui_font series_label_position: none y_tick_values_visible: false x_tick_values_visible: false x_tick_line_visible: true title_visible: false x_label: ""{
				data SOLID_WASTE_POLLUTION value:rows_list(matrix([time_step,total_solid_pollution_values])) color: #orange marker: false thickness: chart_line_width ;
				data WATER_WASTE_POLLUTION value: rows_list(matrix([time_step,total_water_pollution_values])) color: rgb(0,159,233) marker: false thickness: chart_line_width;
		 		data TOTAL_POLLUTION value:rows_list(matrix([time_step,total_pollution_values])) color:rgb(130,86,157) marker: false thickness: chart_line_width;
		 		data ECOLABEL_MAX_POLLUTION value:rows_list(matrix([time_step,ecolabel_max_pollution_values])) color: #white marker: false thickness: chart_line_width;
			}
			
			chart PRODUCTION type: xy position:{0, 0.5}  size:{1, 0.5} background: legend_background color: #white y_range:[0,6000] visible: !show_chart series_label_position: none y_tick_values_visible: false x_tick_values_visible: true x_tick_line_visible: true title_visible: false x_label: ""{
				data TOTAL_PRODUCTION value: rows_list(matrix([time_step,total_production_values])) color: is_production_ok ? #green : #red thickness: chart_line_width marker: false; 
				data ECOLABEL_MIN_PRODUCTION value: rows_list(matrix([time_step,ecolabel_min_production_values])) thickness: chart_line_width color: #white marker: false; 
			}	
			
			 graphics "overlay" position: {0, 0} transparency: 0 refresh: true visible: !show_chart {
				float y_gap <- 0.15;
				float x_gap <- 0.05;
				float x_init <- -0.15;
				float icon_size <-  w_height / 8;
				float y <- 0.2;
				float x <- x_init;
				
				draw danger_icon at: {x* w_width,y*w_height} size: icon_size;
				x <- x + 2* x_gap;
				draw square(x_gap*w_width) color: rgb(130,86,157) at: {x*w_width,y*w_height};
				y <- y + y_gap;
				x <- x_init;
				draw soil_icon at: {x* w_width,y*w_height} size: icon_size;
				x <- x + 2* x_gap;
				draw square(x_gap*w_width) color: #orange at: {x*w_width,y*w_height};
				y <- y + y_gap;
				x <- x_init;
				
				draw water_icon at: {x* w_width,y*w_height} size: icon_size;
				x <- x + 2* x_gap;
				draw square(x_gap*w_width) color: rgb(0,159,233) at: {x*w_width,y*w_height};
				y <- y + y_gap;
				x <- x_init;
				
				draw plant_icon at: {x* w_width,y*w_height} size: icon_size;
				x <- x + 2* x_gap;
				draw square(x_gap*w_width) color: #green at: {x*w_width,y*w_height};
				y <- y + y_gap;
				x <- x_init;



			}
			
			graphics "Button " {
				float x <- 1.0;
				float y <- 0.25;
				show_chart_button <- circle(w_width/8) at_location {x*w_width,y*w_height};
				//draw show_chart_button + 30 color: (show_chart_selected ?  #white : #black);
				draw image_file(show_chart ? "../../includes/icons/button_series_chart.png":"../../includes/icons/button_stacked_chart.png") color: show_chart_selected ? selected_color:unselected_color size: w_width/4 at: {x*w_width,y*w_height};
			}
			
			event #mouse_move {
				using topology(simulation) {
					show_chart_selected <- (show_chart_button covers #user_location) ;
				}
			}
			
			event #mouse_exit {
					show_chart_selected <- false;
			}
			
			event #mouse_down {
				if (show_chart_selected) {
					show_chart <- !show_chart;}
			}
			
			//camera 'default' location: {3213.0194,2461.1095,7816.3615} target: {3213.0194,2460.973,0.0};	
			
			//		graphics "Frame (new version of GAMA)" refresh: true border: #white size: {w_width*2, 1} position: {-w_width/4,0}{
//		}
		
	//	graphics "Frame (old version of GAMA)" refresh: true visible: !#fullscreen{
	//		draw rectangle(w_width, w_height) at_location {w_width/2 - w_width/6, w_height/2} border: #white width: 5 color: legend_background;
	//	}
							
			
			agents "Global" value: [global_chart] aspect: horizontal visible: show_chart position: {0.2,0};

			
				
		}
		
		
		
		/********************** MAIN MAP DISPLAY ***************************************************/
		
		display "MAIN MAP" type: opengl background:map_background axes: false {
			
			light #ambient intensity: ambient_intensity;
			camera 'default' location: {3170.7531,5600.8795,5037.7866} target: {3170.7531,2957.9814,0.0};
			
			//camera 'default' location: {3213.0194,2444.8489,6883.1631} target: {3213.0194,2444.7288,0.0};
			
			species waste_on_canal visible: (show_geography) and display_water_flow  {
					draw sphere(20) color: #lightblue;
			}


			species plot visible: show_geography {
				draw shape color: greens[world.production_class_current(self)] border: false;
			}
			species canal visible: show_geography{
				draw shape buffer (20,10) color: display_water_flow ? #darkblue : blues[world.water_pollution_class_current(self)]  ;
			}
			species local_landfill visible: show_geography{
				draw  shape depth: waste_quantity / 100.0 color: landfill_color;
			}
			species communal_landfill visible: show_geography{
				draw  shape depth: waste_quantity / 100.0 color: landfill_color;
			}
			species urban_area visible:  show_geography;
			
			
			species village visible: (!show_geography) {
				draw shape color: color border: #black width: 2;
			}
			species village transparency: 0.4  visible: ((show_geography) and show_player_numbers) or !show_geography  {
				int divider <- (show_geography) ? 16 : 8;
				draw circle(w_width/divider)	color: !show_geography ? #black :color at: shape.centroid + {0,0,0.4};
			}
			
			species village visible: ((show_geography) and show_player_numbers) or !show_geography   {
				float size <- w_width/10;
				draw numbers[int(self)] at: shape.centroid + {0,0,0.5} size: w_width/15;
				if (show_geography or stage = COMPUTE_INDICATORS) {draw shape-(shape-40) color: color;}
			}
			
			species village visible: !show_geography {
				int i <- int(self);
				float size <- w_width/20;
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
	point location <- {w_width/2 ,w_height/2};
	map<string, map<rgb,float>> data <- [];
	map<string, image_file> icons <- [];
	map<string, bool> inf_or_sup ;
	map<string, bool> draw_smiley;
	float chart_width <- 2* w_width;
	float chart_height <- w_height - w_height/4;
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
 		float original_col_width <- my_width / ((length(data) + 4));
		float col_width <- original_col_width;
 		bool gap_added <- false;
 		
// 		draw circle(100) color:#red; // the center
 		draw rectangle(2.5*original_col_width, chart_height/2) at: {location.x-original_col_width*1.5, location.y +chart_height/4} border: #white wireframe: true;
 		draw rectangle(2.5*original_col_width, chart_height/2) at: {location.x-original_col_width*1.5, location.y-chart_height/4} border: #white wireframe: true;
 		float current_x <- 0.0;
 		loop col over: data.keys {
 			float current_y <-chart_height/6;

 			float total <- 0.0;
 			if (!draw_smiley[col] and !gap_added) {
 				gap_added <- true;
 				col_width<-original_col_width/2;
 				current_x <- current_x + col_width;
 			}

 			loop c over: data[col].keys {
 				float v <- data[col][c];
 				total <- total+v;
 				
 				float col_height <- (v * chart_height)/max_value;
 				draw rectangle(col_width,col_height) color: c at: {current_x,my_height  + current_y - col_height/2};
 				draw rectangle(col_width,col_height) wireframe: true border: #black width: 2 at: {current_x,my_height  + current_y -  col_height/2};
 				current_y <- current_y - col_height;
 			}
 			if (icons[col] != nil) {
 				draw icons[col] at: {current_x, gap_added ? my_height  + current_y - original_col_width/3 :( location.y - chart_height/2)} size: {original_col_width/(gap_added? 3:2), original_col_width/(gap_added? 3:2)};
 				if draw_smiley[col] {
 				if (total <= 1 and inf_or_sup[col] or total > 1 and !inf_or_sup[col]) {
 					draw smileys[0]  at: {current_x, my_height+original_col_width/2} size: {original_col_width/2, original_col_width/2};
 				} else {draw smileys[4]  at: {current_x, my_height+original_col_width/2} size: {original_col_width/2, original_col_width/2};}} 
 			}
 			current_x <- current_x + col_width;
 		}
 		

 		
 	//	draw line({location.x - 3*col_width, location.y + chart_height/2 - desired_value*chart_height/max_value},{location.x, location.y + chart_height/2 - desired_value*chart_height/max_value}) color: #white width: 5;
 		//draw (is_pollution_ok and is_production_ok) ? label_icon:disabled_label_icon at: {location.x, location.y + chart_height/2.5 - desired_value*chart_height/max_value} size: 1.5*col_width ;
 	}

 	
}
