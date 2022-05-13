/**
* Name: WasteManagement
* Based on the internal skeleton template. 
* Author: Patrick Taillandier
* Tags: 
*/

model WasteManagement

global {
	/******************* GEOGRAPHICAL DATA USED *************************************/
	shape_file Hydrologie_shape_file <- shape_file("../includes/Definitive_versions/HydrologieV3.shp");
	string clean_canal_path <- ("../includes/Definitive_versions/Hydrology_clean.shp");
	bool clean_canal_data <- false;

	geometry shape <- envelope(Hydrologie_shape_file);
	
	
	
	init {
		if (clean_canal_data) {
			create canal from: split_lines(Hydrologie_shape_file.contents) ;	 
		
		} else {
			create canal from: Hydrologie_shape_file with: (width:float(get("WIDTH")));	 
		
		}
		if clean_canal_data{
			loop h over:Hydrologie_shape_file.contents {
				h <- h + 5.0;
				float val <- float(h get ("WIDTH"));
				loop h1 over: canal inside h {
					h1.width <- val;
				}
			}	
		
			ask canal where (each.width = 0) {
				width <- float((Hydrologie_shape_file.contents closest_to self) get ("WIDTH"));
			}
			graph canal_network_tmp <- (as_edge_graph(canal, 0.1));
			
			ask canal {
				point lp <- last(shape.points);
				//point fp <- first(shape.points);
				list<canal> edges <- remove_duplicates((canal_network_tmp out_edges_of lp) + (canal_network_tmp in_edges_of lp)) - self; 
				bool should_be_reverse <- false;
				write name + " -> " + edges;
				if not(empty(edges)) and (width < (edges max_of each.width)) {
					should_be_reverse <- true;
					write name + " reverse";
				}
				
				if not should_be_reverse {
					should_be_reverse <- ((first(shape.points).x + (2 * first(shape.points).y)) > (last(shape.points).x + 2 * last(shape.points).y));
				}
				if should_be_reverse {
					shape <- line(reverse(shape.points));
					
				}
				
			}
		}
		graph canal_network <- directed(as_edge_graph(canal));
		ask canal {
			downtream_canals<- list<canal>(canal_network out_edges_of (canal_network target_of self));	
		}
	}
	
	user_command save_canal {
		save canal to:clean_canal_path type: shp attributes:["WIDTH"::width];
	}
}


species canal {
	float width;
	list<canal> downtream_canals;

	user_command reverse_geom {
		shape <- line(reverse(shape.points));
	}
	aspect default {
		draw shape  + (width +1) end_arrow: 30 color: #blue;
			}
	
	aspect info {
		draw "" + int(self) + ": " + width+" -> " + (downtream_canals collect int(each)) font: font("Helvetica", 7) color: #white at: location + {0,0, 2};
		
	}
}



experiment clean_canal  {
	output {
		display map type: opengl  background: #black axes: false {
			species canal;
			species canal aspect: info;
		}	
	}
}