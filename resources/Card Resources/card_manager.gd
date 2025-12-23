extends Node2D
## Based on the tutorials by Barry's Dev Hell - NOT FULLY IMPLEMENTED WITH OLD SYSTEM
## https://www.youtube.com/watch?v=1mM73u1tvpU
## https://www.youtube.com/watch?v=2jMcuKdRh2w

@export var COLLISION_MASK_CARD = 1 # Should actually be a const in the tut but whatever
@export var COLLISION_MASK_CARD_SLOT = 2

var screen_size 
var is_hovering_on_card : bool ## Whether the mouse is on a card or not
var card_being_dragged ## could be like hold as in the noontime tutorial?
@export var player_hand_node : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

## The Barry method of detecting input (clunky)
#func _input(event: InputEvent) -> void:
	##if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
	#if event.is_action("ClickL"): 
	### ^Simplified form of the line above
		#if event.pressed:
			#var card = raycast_check_for_card()
			#if card:
				#start_drag(card)
				##card_being_dragged = card 
				#
			#else:
				#if card_being_dragged:
					##card_being_dragged = null
					#stop_drag()

func start_drag(card):
	card_being_dragged = card 
	card.scale = Vector2(1, 1)

func stop_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)
	var card_slot_found = raycast_check_for_card_slot()
	if card_slot_found and not card_slot_found.card_in_slot:
		player_hand_node.remove_card_from_hand(card_being_dragged)
		# Card dropped in empty card slot
		print("Card slot found")
		card_being_dragged.position = card_slot_found.position
		card_being_dragged.get_node("$Area2D/CollisionShape2D").disabled = true
		#ProjectUISoundController ## should play a click sound
		card_slot_found.card_in_slot = true
	else:
		player_hand_node.add_card_to_hand(card_being_dragged)
	
	card_being_dragged = null
	

func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)
		#print("hovered")

func on_hovered_off_card(card):
	if !card_being_dragged: 
		# If not dragging
		is_hovering_on_card = false
		highlight_card(card, false)
		#print("hovered off")
		
		## This code is based on the barry raycast method - Not all components in place
		#var new_card_hovered = raycast_check_for_card()
		#if new_card_hovered:
			#highlight_card(new_card_hovered, true)
		#else:
		#is_hovering_on_card = false

## Checking for card slots
func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
		#print(result)
		
	return null

## The Barry method of raycasting for cards (not implemented)
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		#print(result)
		return get_card_with_highest_z_index(result)
	return null

func get_card_with_highest_z_index(cards):
	# Assume the first card in cards array has the highest z index
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	# Loop through the rest of the cards looking for a higher z index
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

## Applies a card highlight effect when hovered
func highlight_card(card, hovered : bool): 
	if hovered:
		card.scale = card.scale * Vector2(1.05, 1.05) ## Scales the size of the cards
		card.z_index = 2
		## Moves the cards in front of each other
		## However appears in front of the pause menu for some reason (fix)
	else:
		## Scales the cards back down
		card.scale = card.scale #Vector2(1, 1) 
		card.z_index = 1
