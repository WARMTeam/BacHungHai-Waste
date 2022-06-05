/**
* Name: TangibleInteraction
* Based on the internal empty template. 
* Author: Patrick Taillandier
* Tags: 
*/


model TangibleInteraction

import "Debug.gaml"



global skills: [music] {
	
	bool confirmation_popup <- false;
	bool no_starting_actions <- true;
	
	

	
	int webcam <- 1;
	float delay_between_actions<- 1#s;
	int image_width <- 640;
	int image_height <- 480;
	bool ready_action <- true;
	float last_action_time <- machine_time;
	string latest_action <- "";
	
	reflex detect_interaction_discussion_phase when: stage = PLAYER_DISCUSSION_TURN {
		string result <- string(decodeQR(image_width, image_height,webcam));
		if result = nil { 
			ready_action <- true;
		}
		if ready_action and machine_time > (last_action_time + (1000.0 * 2 * delay_between_actions)) {
			latest_action <- "";
		}
		if result != latest_action and result = A_END_TURN {
			bool is_ok <- play_sound("../../includes/BEEP.wav");
			ready_action <- false;
			latest_action <- result;
			last_action_time <- machine_time;
			do end_of_discussion_phase;	
		}
	}
	
	reflex detect_interaction when: stage = PLAYER_ACTION_TURN and (machine_time > (last_action_time + (1000.0 * delay_between_actions))){
		string result <- string(decodeQR(image_width, image_height,webcam));
		if result = nil {
			ready_action <- true;
		}
		if ready_action and machine_time > (last_action_time + (1000.0 * 2 * delay_between_actions)) {
			latest_action <- "";
		}
		if result != latest_action {
			if ((result in actions_name_short) and not(result in village[index_player].actions_done_this_year) and not(result in village[index_player].actions_done_total)) {
				bool is_ok <- play_sound("../../includes/BEEP.wav");
			
				ready_action <- false;
				latest_action <- result;
				last_action_time <- machine_time;
				do execute_action(result);
			}
		} 
	}
}

//grid cell_image width: 640 height: 480;


experiment with_tangible_interaction type: gui parent: the_serious_game{
	/** Insert here the definition of the input and output of the model */
	output {
		
		
		/*display webcam {
			grid cell_image ;
			
		}*/
	}
}
