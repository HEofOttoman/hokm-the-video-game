extends Node2D

## Based on barry's dev hell and another tutorial : https://www.youtube.com/watch?v=lATAS8YpzFE

#@export var Card : PackedScene
#@export var size : = "size" ## What is this meant to be? Idk

@export var curve : Curve
@export var rotation_curve : Curve

@export var max_rotation_degrees := 10
@export var x_sep := 20
@export var y_min := 50
@export var y_max := -50

const HAND_COUNT = 5
@export var card_scene : PackedScene = preload("res://resources/Card Resources/card.tscn")
@export var CARD_SEPARATION_WIDTH = 50
@export var HAND_Y_POSITION = 250

@export var player_hand : Array = []
var center_screen_x ## The width of the screen

@onready var card_manager : Node2D = $"../Card Manager Card (DrawpointaKaHand)"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	
	for i in range(HAND_COUNT): # Instantiates a card on start
		var new_card = card_scene.instantiate()
		card_manager.add_child(new_card)
		new_card.name = "Card"
		add_card_to_hand(new_card)
		print("cards instantiated")

func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.starting_position)
	

func update_hand_positions():
	for i in range(player_hand.size()):
		## Get new card position based on the index passed in
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		print("Deck at", new_position)
		var card = player_hand[i]
		card.starting_position = new_position
		animate_card_to_position(card, new_position)

## Calculates the position of the hand
#func calculate_card_position(index):
	#var x_offset : float = (player_hand.size() - 1) * CARD_WIDTH ## Originally total width, but better change
	#@warning_ignore("integer_division") ## Doesn't show up for barry for some reason
	#var x_position : float = center_screen_x + (index * CARD_WIDTH) - (x_offset / 2)
	#return x_position

## Cleaner version of Barry's function, the hand is simply located where the card manager is.
## Might be a cosmetic limitation for the animation
func calculate_card_position(index):
	var x_offset : float = (player_hand.size() - 1) * CARD_SEPARATION_WIDTH
	return (index * CARD_SEPARATION_WIDTH) - (x_offset / 2)


#func set_card_width(): ## gets called whenever a card gets added or removed, so that the cards get closer together as more cards are in the hands, which I enjoy
	#CARD_WIDTH = max(250 - (player_hand.size() * 10),100)

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card,"position", new_position, 0.1)

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
