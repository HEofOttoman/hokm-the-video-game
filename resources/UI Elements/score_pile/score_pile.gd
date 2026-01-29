extends Node2D
class_name ScorePile
## Lays out the cards won of a player like the hand

#@export var Card : PackedScene
#@export var size : = "size" ## What is this meant to be? Idk

#@export var hand_layout_mode : HandLayoutMode = HandLayoutMode.LINEAR
#enum HandLayoutMode {FAN_CARDS, LINEAR}
#@export_subgroup('Fanned Layout')
#@export var curve : Curve = preload("res://resources/Card Resources/fanned_layout_curve.tres")
#@export var rotation_curve : Curve = preload("res://resources/Card Resources/rotation_curve.tres")
#
#@export var max_rotation_degrees := 10
#@export var x_sep := 10
#@export var y_min := 50
#@export var y_max := -50

@export_group('Visual Elements')
@export_subgroup('Linear Layout')
@export var card_spacing : float = 25
#@export var HAND_Y_POSITION : float = 0 ## How far down the hand is (relative)
#var center_screen_x ## The width of the screen
## ^Might be unnecessary if I an just animate it to the hand's position

@export_group('Internal Variables')

@export var owner_id : int 
@export var cards_in_pile : Array = [] ## The data about which cards are in the player's hand, or just the hand.
## ^ Cards_in_pile A.K.A SCORE
@export var DisplayLabel : Label ## The label to display hand information in
@export var pile_scale : Vector2 = Vector2(0.7, 0.7)

## Toggles all cards in the hand interactive or not
func set_interactive(enabled: bool):
	for card in cards_in_pile:
		card.set_interactive(enabled)

## Adds the card to the array and updates card to position
func add_card_to_pile(card: CardInstance, trick_count: int):
	DisplayLabel.text = 'Tricks Won: %d' % trick_count
	if card not in cards_in_pile:
		card.set_interactive(false)
		card.reparent(self, true)
		card.scale = pile_scale
		cards_in_pile.insert(0, card)
		update_hand_positions()
	#else:
		#animate_card_to_position(card, card.starting_position)

## Removes the card from the cards_in_hand array and updates hand layout 
func remove_card_from_pile(card):
	if card in cards_in_pile:
		cards_in_pile.erase(card)
		update_hand_positions()

### Visual Elements
## Updates the cards
func update_hand_positions():
	layout_cards()

## Spreads the cards out on a horizontal line
#func layout_cards():
	#for i in range(cards_in_pile.size()):
		### Get new card position based on the index passed in
		#cards_in_pile[i].position = Vector2(i * card_spacing, 0)
		#cards_in_pile[i].z_index = i


## Spreads the cards out on a horizontal line
#func layout_cards():
	#for i in range(cards_in_pile.size()):
		### Get new card position based on the index passed in
		#var card = cards_in_pile[i]
		#var new_position = calculate_card_position(i)
		#card.starting_position = new_position

## Alternate version of the function
func layout_cards():
	var count = cards_in_pile.size()
	for i in range(count):
		var card = cards_in_pile[i]
		#var offset = min(i, 5) * card_spacing
		#card.position = Vector2(offset, 0)
		## Get new card position based on the index passed in
		#var new_position = Vector2(0, -i * card_spacing) ## Lays out cards upwards
		var new_position = calculate_card_position(i)
		card.starting_position = new_position
		card.rotation = lerp(-0.05, 0.05, float(i) / max(1, cards_in_pile.size() - 1))
		animate_card_to_position(card, new_position)

## Calculates the layout of the hand
func calculate_card_position(index: int) -> Vector2:
	var count := cards_in_pile.size()
	var total_width : float = (count - 1) * card_spacing
	var x : float = (index * card_spacing) - total_width / 2.0
	return Vector2(x, 0)

func update_card_width(): ## Should pack cards closer together upon more cards being added (works but not enough)
	card_spacing = max(250 - (cards_in_pile.size() * 10),100)

## Possibly will deprecate and move to card class
func animate_card_to_position(card, new_position):
	if card.has_meta("tween"):
		card.get_meta("tween").kill()
	
	var tween = get_tree().create_tween()
	tween.tween_property(card,"position", new_position, 0.5)
