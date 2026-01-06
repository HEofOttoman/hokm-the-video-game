extends Node2D

## Based on this tutorial; https://www.youtube.com/watch?v=e7iuMLdWjgw (Noontime Dreamer)
## Helped also by Barry's Dev Hell: https://www.youtube.com/watch?v=1mM73u1tvpU

## Unique Parts of a Card
@export_range(1,13) var rank : int = 1 ## IMPORTANT - Remember that in Hokm 2 is valued at 1 and 13 is the Ace!
@export_enum("Hearts", "Spades", "Diamonds", "Clubs") var suit : String = "Hearts"
@export var cardtexture : Texture
@export var backtexture : Texture = preload("res://assets/Sprites/Cards/kenney_playing-cards-pack/PNG/Cards (large)/card_back.png")

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
	#get_parent().connect_card_signals(self)
	## ^Cards must be a child of cardmanager (drawpoint) or this will throw a fatal error
	## Card manager is the hand node from the noontime dreamer tutorial
	

func get_hovered_card_slot():
	
	var areas = $Area2D.get_overlapping_areas()
	for area in areas:
		var slot = area.get_parent
		if slot is CardSlot:
			return slot
	
	return null
	

func _input(event: InputEvent) -> void: ## Better way to move cards that doesn't run every frame
	if dragging and event is InputEventMouseMotion: 
		var mouse_position = get_global_mouse_position()
		global_position = mouse_position ## Allows cards to be dragged around
		#position = Vector2(clamp(mouse_position.x, 0, screen_size.x), 
			#clamp(mouse_position.y, 0, screen_size.y))
			## ^Review this code, the viewport doesn't clamp at the right places

## Detects Left Clicks
func _on_area_2d_card_action(left: bool) -> void:
	if left:
		print(rank, suit + " Left Click")
		dragging = true
		emit_signal("drag_started", self) ## THIS TOO
		
	if not left:
		print("Right Click")
	


func _on_area_2d_card_release(left: bool) -> void: ## Releases cards when the LMB is no longer held down
	if left:
		print(rank, suit + " Released")
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
	

### Visuals Section - Handles Card Visuals
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
