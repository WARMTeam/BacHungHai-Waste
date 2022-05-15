/**
* Name: Parameters
* Based on the internal empty template. 
* Author: Patrick Taillandier
* Tags: 
*/

@no_experiment
model Parameters

global {
/******************* GEOGRAPHICAL DATA USED *************************************/
	shape_file Limites_commune_shape_file <- shape_file("../includes/Definitive_versions/Limites_communesV2.shp");

	shape_file Limites_urban_areas_shape_file <- shape_file("../includes/Definitive_versions/Limites_villagesV2.shp");

	shape_file Hydrologie_shape_file <- shape_file("../includes/Definitive_versions/Hydrology_clean2_2.shp");
	
	geometry shape <- envelope(Limites_commune_shape_file);
	
	shape_file villages_shape_file <- shape_file("../includes/Definitive_versions/Territoires_villagesV2.shp");

	shape_file Fields_shape_file <- shape_file("../includes/Definitive_versions/FieldsV1.shp");

	/*************** GENERAL PARAMETERS ON TIME AND SPACE ****************************/
	
	float step <- 1#day;// one simulation step = 1 day 
	float house_size <- 50.0 #m; // size of a house plot
	
	int end_of_game <- 8; // Number of turns of the game (1 turn = 1 year)
	float tolerance_dist <- 1#m;
	
	
	/************* PARAMETERS RELATED TO DEMOGRAPHIC AND ECONOMIC ASPECT  ***************/
	
	float budget_year_per_people <- 1.0; // total buget per year for a village (in token): number of people x budget_year_per_people
	float min_increase_urban_area_population_year <- 0.1; //min increase of urban area per year (in terms of number of people)
	
	
	/*************** PARAMETERS RELATED TO VISUALIZATION ****************************/
	
	list<rgb> village_color <- [#magenta, #gold, #violet,#orange]; // color for the 4 villages
	float min_display_waste_value <- 0.2; //just use for display all the pollution cell 
	float coeff_cell_pollution_display <- 0.01;  //coeff used to define the color of the cell according to the pollution
	float coeff_visu_canal <- 3.0;  //coeff used to define the color of the canal according to the pollution
	
	
	/********* PARAMETERS RELATED TO WATER FLOW (WASTE DIFFUSION) IN THE CANAL *******/
	
	float rate_diffusion_liquid_waste <- 10.0; //rate of liquid waste per perimeter of canals passing to the the downstream canal
	float rate_diffusion_solid_waste <- 1.0;//rate of solid waste per perimeter of canals passing to the the downstream canal
	
	
	/******* PARAMETERS RELATED TO THE IMPACT OF POLLUTION ON FIELD YIELD *************/
	
	float field_initial_productivity <- 100.0; // initial productivity of fields;
	float distance_to_canal_for_pollution_impact <- 50 #m; //all the fields at this distance are impacted by the canal pollution
	float canal_solid_waste_pollution_impact_rate <- 0.01; //production (yield) = production  - (pollution of the surrounding canal * pollution_impact_rate)
	float canal_water_waste_pollution_impact_rate <- 0.01; //production (yield) = production  - (pollution of the surrounding canal * pollution_impact_rate)
	float ground_solid_waste_pollution_impact_rate <- 0.01; //production (yield) = production  - (sum solid pollution on cell * pollution_impact_rate)
	float ground_water_waste_pollution_impact_rate <- 0.01; //production (yield) = production  - (sum water pollution on cell * pollution_impact_rate)
	
	float quantity_from_local_to_communal_landfill <- 100.0; //quantity of solid waste transfert to communal landfill every day for each local landfill 
	float quantity_communal_landfill_to_treatment <- 200.0; //quantity of solid waste "treated" (that disapears) every day from the communal landfill
	
	float local_landfill_waste_pollution_impact_rate <- 0.0001; //impact of the pollution generated by the local landfill on productivity of fields: production (yield) = production  - (pollution of the surrounding local landfill * local_landfill_waste_pollution_impact_rate)
	float communal_landfill_waste_pollution_impact_rate <- 0.0001;  //impact of pollution generated by the communal landfill on productivity of fields: production (yield) = production  - (pollution of the surrounding communal landfill * communal_landfill_waste_pollution_impact_rate)
	float distance_to_local_landfill_for_pollution_impact <- 2 #km; //distance of impact considered for the local landfills
	float distance_to_communal_landfill_for_pollution_impact <- 5 #km; //distance of impact considered for the communal landfill
	
	
	/*********** PARAMETERS RELATED TO WASTE PRODUCTION AND END OF LIFE *************/
	
	float ground_water_pollution_reducing_day <- 0.01; //quantity of the ground water pollution that disapear every day
	float ground_solid_pollution_reducing_day <- 0.001; //quantity of the solid water pollution that disapear every day
	
	float water_waste_filtering_inhabitants <- 0.2 min: 0.0 max: 1.0; // part of the water waste produced per inhabitants that are filtered
	float water_waste_year_inhabitants <- 38500.0 / 1000.0;// L/pers/year - quantity of water waste produced per people living in urban area per year 
	float solid_waste_year_inhabitants <-  220.0;//kg/pers/year - quantity of solid waste produced per people living in urban area per year  
	
	float water_waste_year_farmers <- 30000.0 / 1000.0;// L/pers/year - quantity of water waste produced per people outside  urban area (farmer) per year 
	float solid_waste_year_farmers <-  220.0;//kg/pers/year - quantity of solid waste produced per people outside  urban area (farmer) per year
	
	float part_solid_waste_canal_inhabitants <- 0.0; // proportion of solid waste throw in the canal per people living in urban area; (1 - part_solid_waste_canal_inhabitants) is throw on the ground
	float part_water_waste_canal_inhabitants <- 1.0;// proportion of water waste throw in the canal per people living in urban area; (1 - part_water_waste_canal_inhabitants) is throw on the ground
	
	float part_solid_waste_canal_farmers <- 0.5; // proportion of solid waste throw in the canal per people living outside urban area; (1 - part_solid_waste_canal_farmers) is throw on the ground
	float part_water_waste_canal_farmers <- 0.5;// proportion of water waste throw in the canal per people living outside urban area; (1 - part_water_waste_canal_farmers) is throw on the ground
	
	float part_of_water_waste_pollution_to_canal <- 0.01;// part of the water waste on ground to go the canal every day; 
	
	/********************** PARAMETERS RELATED ACTIONS ****************************/
	
	
	float token_weak_waste_collection <- 20.0; //tokens/year - cost of "weak collection"
	float token_strong_waste_collection <- 40.0; //tokens/year - cost of "strong collection"
	int collect_per_week_weak <- 2; //number of collect per week for "weak collection"
	int collect_per_week_strong <- 4; //number of collect per week for "string collection"
	float collection_team_collection_capacity_day <- 1000.0; //quantity of solid waste remove during 1 day of work
	
	
	float token_trimestrial_collective_action <- 25.0; //per year
	float impact_trimestrial_collective_action <- 0.3; //part of the solid waste remove from the canal
	
	float token_drain_dredge <- 60.0; //per action
	float impact_drain_dredge_waste <- 0.43; //part of the solid waste remove from the canal
	float impact_drain_dredge_agriculture <- 0.2; //improvment of the agricultural production
	
	float token_install_filter_for_homes_construction <- 200.0 ; //construction
	float token_install_filter_for_homes_maintenance <- 20.0 ; //per year	
	float token_sensibilization <- 15.0; //per year
	
	float token_pesticide_reducing <- 30.0; //per year
	float impact_pesticide_reducing_production  <- 0.15; //decrease of the agricultural production
	float impact_pesticide_reducing_waste  <- 0.33; //decrease waste production from farmers
	
	float token_implement_fallow <- 25.0; //per year
	float impact_implement_fallow  <- 0.33; //decrease the agricultural production
	
	float token_support_manure_buying <- 30.0; //per year
	float impact_support_manure_buying_production  <- 0.15; //improvment of the agricultural production
	float impact_support_manure_buying_waste  <- 0.2; //increase wastewater production
	
	float token_installation_dumpholes <- 15.0; //per year
	float impact_installation_dumpholes  <- 0.25; //decreasse
}