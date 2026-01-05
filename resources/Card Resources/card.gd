extends Node2D

## Based on this tutorial; https://www.youtube.com/watch?v=e7iuMLdWjgw (Noontime Dreamer)
## Helped also by Barry's Dev Hell: https://www.youtube.com/watch?v=1mM73u1tvpU

## Unique Parts of a Card
@export_range(1,13) var value : int = 1 ## IMPORTANT - Remember that in Hokm 2 is valued at 1 and 13 is the Ace!
@export_enum("Hearts", "Spades", "Diamonds", "Clubs") var suit : String = "Hearts"
@export var cardtexture : Texture
@export var backtexture : Texture = preload("res://assets/Sprites/Cards/kenney_playing-cards-pack/PNG/Cards (large)/card_back.png")

@export var custom_default_scale : Vector2

signal hovered(card)
signal hovered_off(card)
## ^Was used to talk to card manager, but better to manage visuals here.?

signal drag_started(card)
signal drag_ended(card)


var starting_position : Vector2

var hold : bool = false
var is_hovered : bool = false

var screen_size : Vector2

var card_being_dragged

func _ready() -> void:
	#self.scale = custom_default_scale
	screen_size = get_viewport_rect().size 
	## ^Review this code, the viewport doesn't clamp at the right places
	$CardSprite.texture = cardtexture ## Sets the card texture as the default
	#get_parent().connect_card_signals(self)
	## ^Cards must be a child of cardmanager (drawpoint) or this will throw a fatal error
	## Card manager is the hand node from the noontime dreamer tutorial
	

#func _process(_delta: float) -> void:
func _input(event: InputEvent) -> void: ## Better way to move cards that doesn't run every frame
	if hold and event is InputEventMouseMotion: 
		var mouse_position = get_global_mouse_position()
		global_position = mouse_position ## Allows cards to be dragged around
		#position = Vector2(clamp(mouse_position.x, 0, screen_size.x), 
			#clamp(mouse_position.y, 0, screen_size.y))
			## ^Review this code, the viewport doesn't clamp at the right places

## Detects Left Clicks
func _on_area_2d_card_action(left: bool) -> void:
	if left:
		print(value, suit + " Left Click")
		hold = true
	if not left:
		print("Right Click")
	


func _on_area_2d_card_release(left: bool) -> void: ## Releases cards when the LMB is no longer held down
	if left:
		print(value, suit + " Released")
		hold = false


func _on_area_2d_mouse_entered() -> void:
	emit_signal('hovered', self)
	is_hovered = true


func _on_area_2d_mouse_exited() -> void:
	emit_signal('hovered_off', self)
	is_hovered = false

func on_hovered_over_card(card):
	if !is_hovered:
		is_hovered = true
		highlight_card(card, true)
		#print("hovered")

func on_hovered_off_card(card):
	if !card_being_dragged: 
		# If not dragging
		is_hovered = false
		highlight_card(card, false)
		#print("hovered off")
		
		## This code is based on the barry raycast method - Not all components in place
		#var new_card_hovered = raycast_check_for_card()
		#if new_card_hovered:
			#highlight_card(new_card_hovered, true)
		#else:
		#is_hovering_on_card = false

func start_drag(card):
	card_being_dragged = card 
	card.scale = Vector2(1, 1)

func stop_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)
	#var card_slot_found = raycast_check_for_card_slot()
	#if card_slot_found and not card_slot_found.card_in_slot:
		#player_hand_node.remove_card_from_hand(card_being_dragged)
		## Card dropped in card slot
		#card_being_dragged.scale = Vector2(CARD_SMALLER_SCALE, CARD_SMALLER_SCALE)
		## Card dropped in empty card slot
		#print("Card slot found")
		#card_being_dragged.position = card_slot_found.position
		#card_being_dragged.get_node("$Area2D/CollisionShape2D").disabled = true
		##ProjectUISoundController ## should play a click sound
		#card_slot_found.card_in_slot = true
	#else:
		#player_hand_node.add_card_to_hand(card_being_dragged)
	#
	#card_being_dragged = null

### Visuals Section - Handles Card Visuals
## Applies a card highlight effect when hovered

func highlight_card(card, hovered : bool): 
	if hovered:
		card.scale = card.scale * Vector2(1.05, 1.05) ## Scales the size of the cards
		card.z_index = 2
		## Moves the cards in front of each other
		## However appears in front of the pause menu for some reason (fix)
	else:
		## Scales the cards back down
		card.scale = card.custom_default_scale #Vector2(1, 1) 
		card.z_index = 1


#func connect_card_signals(card):
	#card.connect("hovered", on_hovered_over_card)
	#card.connect("hovered_off", on_hovered_off_card)
