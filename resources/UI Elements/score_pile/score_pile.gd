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
@export var layout : CardLayout = CardLayout.LINEAR
@export_subgroup('Linear Layout')
@export var card_spacing : float = 25
#@export var HAND_Y_POSITION : float = 0 ## How far down the hand is (relative)
#var center_screen_x ## The width of the screen
## ^Might be unnecessary if I an just animate it to the hand's position

@export_subgroup('Circular Layout')
@export var CIRCLE_RADIUS : float = 50.0
@export var CIRCLE_CENTER : Vector2 = Vector2.ZERO
@export var flip_sin_cos : bool = false ## Whether or not sin & cos is flipped in the circle calculations

enum CardLayout {
	LINEAR,
	CIRCULAR
}

@export_group('Internal Variables')

@export var owner_id : int 
@export var cards_in_pile : Array[CardInstance] = [] ## The data about which cards are in the player's hand, or just the hand.
## ^ Cards_in_pile A.K.A SCORE
@export var DisplayLabel : Label ## The label to display hand information in
@export var pile_scale : Vector2 = Vector2(0.7, 0.7)

@onready var trick_count_hint: TextureRect = $TrickCountHint
@export var number_textures: Array[Texture2D]

## Toggles all cards in the hand interactive or not
func set_interactive(enabled: bool):
	for card in cards_in_pile:
		card.set_interactive(enabled)

## Adds the card to the array and updates card to position
func add_card_to_pile(card: CardInstance, trick_count: int):
	#DisplayLabel.text = 'Tricks Won: %d' % trick_count
	DisplayLabel.text = '%d' % trick_count
	_set_count(trick_count)
	if card not in cards_in_pile:
		card.set_interactive(false)
		card.reparent(self, true)
		card.scale = pile_scale
		cards_in_pile.insert(0, card)
		update_hand_positions()
	#else:
		#animate_card_to_position(card, card.starting_position)

func _set_count(count: int):
	#count = clamp(count, 0, number_textures.size() - 1)
	trick_count_hint.texture = number_textures[count]

## Removes the card from the cards_in_hand array and updates hand layout 
func remove_card_from_pile(card):
	if card in cards_in_pile:
		cards_in_pile.erase(card)
		update_hand_positions()

### Visual Elements
## Updates the cards
func update_hand_positions():
	match layout:
		CardLayout.LINEAR:
			layout_cards()
		CardLayout.CIRCULAR:
			layout_circular()

func _ready() -> void:
	update_hand_positions() # For testing


func _process(delta: float) -> void:
	time += delta
	card_wave(time)

var time : float = 0.0

@export_subgroup('Card Wave Animation')
@export var time_multiplier : float = 6.0
@export var sin_offset_multiplier : float = 0.1 # Needed for a visible effect
## Idle card waving animation by mr Eliptik.
func card_wave(elapsed_time) -> void:
	for i in range(cards_in_pile.size()):
		var card : CardInstance = cards_in_pile[i]
		var val : float = sin(i + (elapsed_time * time_multiplier))
		card.global_position.y += val * sin_offset_multiplier

## Puts the cards in a circular layout (reworked from hand fan_cards) I am just dumb and needed help
func layout_circular() -> void:
	var count : int = cards_in_pile.size()
	if count == 1:
		animate_card_to_position(cards_in_pile[0], Vector2.ZERO)
		return
	
	for i in count:
		#var n := float(i) / float(count - 1) # N is the place of the card between left & right
		var card : CardInstance = cards_in_pile[i]
		
		var angle := (TAU/count) * i #= deg_to_rad(angle_deg)
		
		var x : float = CIRCLE_CENTER.x + sin(angle) * CIRCLE_RADIUS # meant to be cos
		var y : float = CIRCLE_CENTER.y + cos(angle) * CIRCLE_RADIUS # meant to be sin
		# Flipping sin & cos here gives interesting results
		
		var rot : float = angle + PI / 2.0
		
		var pos = Vector2(x, y)
		
		card.starting_position = pos
		card.rotation = rot
		card.z_index = i
		
		animate_card_to_position(card, pos)

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
