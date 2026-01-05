extends Node2D

## Barry's way of detecting cards, a bunch of raycasts. 
## Seems overly complex tbh

@export var COLLISION_MASK_CARD = 1 # Should actually be a const in the tut but whatever
@export var COLLISION_MASK_DECK = 2


@onready var card_manager_reference: Node2D = $"../Card Manager Card (DrawpointaKaHand)"
@onready var deck_reference: Deck = $"../Deck"


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
	#if event.is_action("ClickL"): 
	## ^Simplified form of the line above
		if event.pressed:
			#var card = raycast_check_for_card()
			raycast_at_cursor()
			#if card:
				#start_drag(card)
				#card_being_dragged = card 
				
			#else:
				#pass
				#if card_being_dragged:
					##card_being_dragged = null
					#stop_drag()

## The Barry method of raycasting for cards (not implemented)
func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	#parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		#print(result)
		#return get_card_with_highest_z_index(result)
		var result_collision_mask = result[0].collider.collision_mask
		## Card clicked
		if result_collision_mask == COLLISION_MASK_CARD:
			var card_found = result[0].collider.get_parent()
			if card_found:
				card_manager_reference.start_drag(card_found)
		## Deck Clicked
		elif result_collision_mask == COLLISION_MASK_DECK:
			deck_reference.draw_card()
