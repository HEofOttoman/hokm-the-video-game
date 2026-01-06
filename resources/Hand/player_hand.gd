extends Node2D

## Based on barry's dev hell and another tutorial : https://www.youtube.com/watch?v=lATAS8YpzFE

#@export var Card : PackedScene
#@export var size : = "size" ## What is this meant to be? Idk

@export var curve : Curve
@export var rotation_curve : Curve

@export var max_rotation_degrees := 10
@export var x_sep := 10
@export var y_min := 50
@export var y_max := -50

@export var CARD_SEPARATION_WIDTH : float = 50
@export var HAND_Y_POSITION : float = 0 ## How far down the hand is (relative)
var center_screen_x ## The width of the screen
## ^Might be unnecessary if I an just animate it to the hand's position

@export var player_hand : Array = [] ## The data about which cards are in the player's hand

@export var rulesEngine = RulesEngine.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	
	#$"../Deck".card_drawn.connect(self._on_card_drawn) ## Already connected?

func connect_card_signals(card):
	card.drag_started.connect(_on_drag_started)
	card.drag_ended.connect(_on_drag_ended)


func _on_card_drawn(card):
	add_child(card)
	card.global_position = $"../Deck".global_position
	
	connect_card_signals(card)
	
	add_card_to_hand(card)
	card.get_node("AnimationPlayer").play("card_flip") ## Plays the animation while tweening to position
	

func _on_drag_started(card):
	start_drag(card)

func _on_drag_ended(card):
	stop_drag(card)

func start_drag(_card):
	print('START DRAG CALLED')
	#card.scale = Vector2(1, 1)
	## No use at all for starting card drag, was used for hover which is inside the card's script now.

func stop_drag(card): ## Should move cards to slots if found.
	print('STOP DRAG CALLED')
	card.scale = Vector2(1.05, 1.05)
	var card_slot_found = card.get_hovered_card_slot()
	print('CARD SLOT FOUND:', card_slot_found)
	if card_slot_found and not card_slot_found.card_in_slot: ## Card dropped in empty card slot
		## For later implementation
		#if rulesEngine.can_play_card(card, card_slot_found):
			#card_slot_found.add_card_to_slot()
			# + the other lines
		
		print("Card slot found")
		remove_card_from_hand(card) 
		card.position = card_slot_found.position
		#card.get_node("$Area2D/CollisionShape2D").disabled = true
		#ProjectUISoundController ## should play a click sound
		card_slot_found.add_card_to_slot()
	else:
		add_card_to_hand(card)
	#card = null


func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.starting_position)
	

func update_hand_positions():
	for i in range(player_hand.size()):
		## Get new card position based on the index passed in
		var card = player_hand[i]
		var new_position = calculate_card_position(i)
		#print("Deck at", new_position) ## Helped troubleshoot when I had the bug of the deck going off screen
		card.starting_position = new_position
		animate_card_to_position(card, new_position)

## Calculates the position of the hand
#func calculate_card_position(index):
	#var x_offset : float = (player_hand.size() - 1) * CARD_WIDTH ## Originally total width, but better change
	#var x_position : float = center_screen_x + (index * CARD_WIDTH) - (x_offset / 2)
	#return x_position

## Cleaner version of Barry's function, the hand is simply drawn relative to where the card manager is.
## Might be a cosmetic limitation for the animation
#func calculate_card_position(index):
	##update_card_width() ## Works, but not enough
	#var x_offset : float = (player_hand.size() - 1) * CARD_SEPARATION_WIDTH
	#return (index * CARD_SEPARATION_WIDTH) - (x_offset / 2)

## Alternative suggested version of the function
func calculate_card_position(index: int) -> Vector2:
	var count := player_hand.size()
	var total_width : float = (count - 1) * CARD_SEPARATION_WIDTH
	var x : float = (index * CARD_SEPARATION_WIDTH) - total_width / 2.0
	return Vector2(x, 0)

func update_card_width(): ## Should pack cards closer together upon more cards being added (works but not enough)
	CARD_SEPARATION_WIDTH = max(250 - (player_hand.size() * 10),100)

#func set_card_width(): ## gets called whenever a card gets added or removed, so that the cards get closer together as more cards are in the hands, which I enjoy
	#CARD_WIDTH = max(250 - (player_hand.size() * 10),100)

func animate_card_to_position(card, new_position):
	if card.has_meta("tween"):
		card.get_meta("tween").kill()
	
	var tween = get_tree().create_tween()
	tween.tween_property(card,"position", new_position, 0.5)


func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()
		

## Try to fan out the cards... help I just can't (tutorial: https://www.youtube.com/watch?v=waVOR2ehpuU)
#func _update_cards() -> void:
	#var cards := get_child_count()
	#var all_cards_size : float = card_scene.SIZE.x + x_sep * (cards - 1)
	#var final_x_sep := x_sep
	#
	#if all_cards_size > size.x:
		#final_x_sep = (size.x - card_scene.SIZE.x * cards) / (cards - 1)
	#
	#var offset : float = (size.x - all_cards_size) / 2
	#
	#for i in cards:
		#var card := get_child(i)
		#var y_multiplier := curve.sample(1.0 / (cards - 1) * i)
		#var rot_multiplier := rotation_curve.sample(1.0 / (cards - 1) * i)
		#
		#var final_x: float = offset + card_scene.SIZE.x * i + final_x_sep * i
		#var final_y: float = y_min + y_max * y_multiplier
		#
		#card.position = Vector2(final_x, final_y)
		#card.rotation_degrees = max_rotation_degrees * rot_multiplier
