extends Node2D
class_name CardInstance
## Based on this tutorial; https://www.youtube.com/watch?v=e7iuMLdWjgw (Noontime Dreamer)
## Helped also by Barry's Dev Hell: https://www.youtube.com/watch?v=1mM73u1tvpU

## Unique Parts of a Card
#@export_range(1,13) var rank : int = 1 ## IMPORTANT - Remember that in Hokm 2 is valued at 1 and 13 is the Ace!

enum Rank { 
	TWO = 2, 
	THREE = 3, 
	FOUR = 4, 
	FIVE = 5, 
	SIX = 6, 
	SEVEN = 7, 
	EIGHT = 8, 
	NINE = 9, 
	TEN = 10, 
	JACK = 11, 
	QUEEN = 12, 
	KING = 13, 
	ACE = 14
	}

enum Suit {
	HEARTS = 1,
	SPADES = 2,
	DIAMONDS = 3,
	CLUBS = 4
}

@export_group('Card Data')
@export var card_data : CardData

@export var rank : Rank = Rank.TWO
@export var suit : Suit = Suit.HEARTS

#@export_enum("Hearts", "Spades", "Diamonds", "Clubs") var suit : String = "Hearts"
#@export_enum(Hearts = 0, Spades = 1, Diamonds = 2, Clubs = 3) var suit : int = 0

@export var cardtexture : Texture
@export var backtexture : Texture = preload("res://assets/Sprites/Cards/kenney_playing-cards-pack/PNG/Cards (large)/card_back.png")

@export_subgroup('Switches')
## Whether the card is facing up, ie. SHOWING THE CARD TEXTURE
@export var card_face_up : bool = false 
@export var interactive : bool = true

@export_group('Card Scales')
@export var custom_default_scale : Vector2 = Vector2(1.0, 1.0)
@export var CARD_SMALLER_SCALE : float = 0.6 ## Determines the size a card should take in a card slot


signal hovered(card) ## Hovered singlas were used to talk to card manager, but migrated here.
signal hovered_off(card) ## Might be useful for implementing tutorials (seeing if instruction is followed?)
signal drag_started(card)
signal drag_ended(card)


var starting_position : Vector2

var dragging : bool = false ## Previously 'hold'

var is_hovered : bool = false

var screen_size : Vector2

func _ready() -> void:
	if custom_default_scale == Vector2.ZERO:
		custom_default_scale = scale
	
	scale = custom_default_scale
	screen_size = get_viewport_rect().size 
	## ^Review this code, the viewport doesn't clamp at the right places
	$CardSprite.texture = cardtexture ## Sets the card texture as the default
	

#func _process(_delta):
	#if dragging:
		#var areas = $Area2D.get_overlapping_areas()
		#if areas.size() > 0:
			#print("OVERLAP:", areas)

func get_hovered_card_slot():
	var areas = $Area2D.get_overlapping_areas()
	for area in areas:
		if area.is_in_group('card_slots'):
			#print('FINALLY I FOUND YOU') ## I was so glad to get slots working finally lmao
			return area.get_parent()
		#var slot = area.get_parent
		#if slot is CardSlot:
			#return slot
	
	return 

func _input(event: InputEvent) -> void: ## Better way to move cards that doesn't run every frame
	if dragging and event is InputEventMouseMotion: 
		var mouse_position = get_global_mouse_position()
		global_position = mouse_position ## Allows cards to be dragged around
		#position = Vector2(clamp(mouse_position.x, 0, screen_size.x), 
			#clamp(mouse_position.y, 0, screen_size.y))
			## ^Review this code, the viewport doesn't clamp at the right places
		#var areas = $Area2D.get_overlapping_areas()
		#if areas.size() > 0:
			#print("OVERLAP:", areas)

### Inputs Section
## Detects Left Clicks

## Disables/enables drag detection, for example if owned by an AI or if its not the turn.
func set_interactive(enabled: bool) -> void:
	interactive = enabled
	$Area2D.input_pickable = enabled

func _on_area_2d_card_action(left: bool) -> void:
	if not interactive: ## Additional safeguard from moving
			return
	if left:
		#print(rank, ' ', suit, " Left Click") ## Used to debug, now just console spam 
		dragging = true
		emit_signal("drag_started", self) ## THIS TOO
		
	if not left:
		print("Right Click")
	


func _on_area_2d_card_release(left: bool) -> void: ## Releases cards when the LMB is no longer held down
	if left:
		#print(rank, ' ', suit, " Released") ## Used to debug, now just console spam
		dragging = false
		emit_signal("drag_ended", self) ## BRO ADDING `self` IS WHAT FIXED THE HAND SNAP 
		



func _on_area_2d_mouse_entered() -> void:
	is_hovered = true
	highlight_card(true)
	emit_signal("hovered", self)
	


func _on_area_2d_mouse_exited() -> void:
	is_hovered = false
	highlight_card(false)
	emit_signal("hovered_off", self)
	

### Visuals Section - Handles Card VisualsZ
## Applies a card highlight effect when hovered
func highlight_card(on_card : bool): #(card, hovered : bool): 
	if on_card:
		scale = custom_default_scale * Vector2(1.05, 1.05) ## Scales the size of the cards
		z_index = 2
		## Moves the cards in front of each other
		## However appears in front of the pause menu for some reason (fix)
	else:
		## Scales the cards back down
		scale = custom_default_scale #Vector2(1, 1) 
		z_index = 1

## Flips the card face up to show the card's value
func flip_card(flipped: bool):
	card_face_up = flipped
	if flipped == true:
		$AnimationPlayer.play("card_flip")
		GameSfxBus.play(GameSfxBus.card_flip)
	else:
		$AnimationPlayer.play_backwards("card_flip")

## Moved from hand.gd
func animate_card_to_position(new_position):
	if has_meta("tween"):
		get_meta("tween").kill()
	
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_position", new_position, 0.5)
