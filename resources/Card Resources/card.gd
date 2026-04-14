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

@export_group('Card Components')
@export var card_sprite : Sprite2D ## The sprite node of the card
#@export var card_shadow : Sprite2D
@onready var card_shadow: Sprite2D = $Shadow
@export var max_offset_shadow : float = 3.0 ## Maximum x offset of the card shadow
@export var angle_y_max : float = 15.0
@export var angle_x_max : float = 15.0

@export_subgroup('Switches')
## Whether the card is facing up, ie. SHOWING THE CARD TEXTURE
@export var card_face_up : bool = false 
@export var interactive : bool = true

@export_group('Card Scales')
@export var custom_default_scale : Vector2 = Vector2(1.0, 1.0)
@export var CARD_SMALLER_SCALE : float = 0.6 ## Determines the size a card should take in a card slot

@export_subgroup('Oscillator') # From https://github.com/MrEliptik/godot_ui_components/
@export var spring: float = 150.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 2.0

var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

signal hovered(card) ## Hovered singlas were used to talk to card manager, but migrated here.
signal hovered_off(card) ## Might be useful for implementing tutorials (seeing if instruction is followed?)
signal drag_started(card)
signal drag_ended(card)

var tween_rot: Tween
var tween_hover: Tween
var tween_destroy: Tween
var tween_handle: Tween

var starting_position : Vector2

var dragging : bool = false ## Previously 'hold'

var is_hovered : bool = false

var screen_size : Vector2

func _ready() -> void:
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)
	
	if custom_default_scale == Vector2.ZERO:
		custom_default_scale = scale
	
	scale = custom_default_scale
	screen_size = get_viewport_rect().size 
	## ^Review this code, the viewport doesn't clamp at the right places
	#$CardSprite.texture = cardtexture ## Sets the card texture as the default
	card_sprite.texture = cardtexture ## Sets the card texture as the default
	
	

func _process(delta):
	handle_shadow()
	
	rotate_velocity(delta) # Works beautifully but breaks returning to hand somehow
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
	#if event.is_action('ClickR'): # <- Testing destroy card
		#destroy_card()
	
	if dragging and event is InputEventMouseMotion: 
		var mouse_position = get_global_mouse_position()
		global_position = mouse_position ## Allows cards to be dragged around
		#position = Vector2(clamp(mouse_position.x, 0, screen_size.x), 
			#clamp(mouse_position.y, 0, screen_size.y))
			## ^Review this code, the viewport doesn't clamp at the right places
		#var areas = $Area2D.get_overlapping_areas()
		#if areas.size() > 0:
			#print("OVERLAP:", areas)
	
	#rotate_card(event)

### Inputs Section
## Detects Left Clicks

## Disables/enables drag detection, for example if owned by an AI or if its not the turn.
func set_interactive(enabled: bool) -> void:
	interactive = enabled
	$Area2D.input_pickable = enabled

## Called when a card is left/right clicked, from a signal emitted by cardclicker
func _on_area_2d_card_action(left: bool) -> void:
	if not interactive: ## Additional safeguard from moving
			return
	if left:
		#print(rank, ' ', suit, " Left Click") ## Used to debug, now just console spam 
		dragging = true
		emit_signal("drag_started", self) ## THIS TOO
		
	if not left:
		print("Right Click")
	

## Called when a card is released
func _on_area_2d_card_release(left: bool) -> void: ## Releases cards when the LMB is no longer held down
	if left:
		#print(rank, ' ', suit, " Released") ## Used to debug, now just console spam
		dragging = false
		
		#collision_shape.set_deferred("disabled", false)
		if tween_handle and tween_handle.is_running(): ## Fixes the card rotation not changing
			tween_handle.kill()
		tween_handle = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween_handle.tween_property(self, "rotation", 0.0, 0.3)
		
		emit_signal("drag_ended", self) ## BRO ADDING `self` IS WHAT FIXED THE HAND SNAP 
		
		#following_mouse = false
		#collision_shape.set_deferred("disabled", false)
		#if tween_handle and tween_handle.is_running():
			#tween_handle.kill()
		#tween_handle = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		#tween_handle.tween_property(self, "rotation", 0.0, 0.3)



func _on_area_2d_mouse_entered() -> void:
	is_hovered = true
	highlight_card(true)
	emit_signal("hovered", self)
	

## Called when mouse_exited
func _on_area_2d_mouse_exited() -> void:
	is_hovered = false
	if interactive: ## Stops the card from resizing back up after dropping the card
		highlight_card(false)
	#highlight_card(false)
	emit_signal("hovered_off", self)
	

### Visuals Section - Handles Card VisualsZ
## Applies a card highlight effect when hovered
func highlight_card(on_card : bool): #(card, hovered : bool): 
	 ## Using tweens for highlights
	#var tween_hover : Tween
	#if tween_hover:
		#tween_hover.kill()
	
	if on_card:
		if tween_hover and tween_hover.is_running():
			tween_hover.kill()
		
		tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)#.set_parallel(true)
		tween_hover.tween_property(self, "scale", custom_default_scale * Vector2(1.05, 1.05), 0.55)
		
		#scale = custom_default_scale * Vector2(1.05, 1.05) ## Scales the size of the cards
		z_index = 2
		## Moves the cards in front of each other
		## However appears in front of the pause menu for some reason (fix)
	else:
		## Scales the cards back down
		if tween_rot and tween_rot.is_running():
			tween_rot.kill()
		
		tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
		tween_rot.tween_property(card_sprite.material, "shader_parameter/x_rot", 0.0, 0.5)
		tween_rot.tween_property(card_sprite.material, "shader_parameter/y_rot", 0.0, 0.5)
		
		tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)#.set_parallel(true)
		tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)
		
		#scale = custom_default_scale #Vector2(1, 1) 
		z_index = 1

## Rotates card in 3D perspective via the shader
func rotate_card(event: InputEvent):
	if dragging: return
	if not event is InputEventMouseMotion: return
	
	
	#var size = cardtexture.size
	#var size = 0
	var mouse_pos : Vector2 = get_local_mouse_position()
	#var _diff : Vector2 = (position + size) - mouse_pos
	
	#var lerp_val_x : float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	#var lerp_val_y : float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	var lerp_val_x : float = remap(mouse_pos.x, 0.0, screen_size.x, 0, 1)
	var lerp_val_y : float = remap(mouse_pos.y, 0.0, screen_size.y, 0, 1)
	
	var rot_x : float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y : float = rad_to_deg(lerp_angle(-angle_y_max, angle_y_max, lerp_val_y))
	
	card_sprite.material.set_shader_parameter("x_rot", rot_x)
	card_sprite.material.set_shader_parameter("y_rot", rot_y)
	
	#var tween_rot : Tween
	#
	#@warning_ignore("unassigned_variable")
	#if tween_rot:
		#@warning_ignore("unassigned_variable")
		#tween_rot.kill()
	#
	#tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	#tween_rot.tween_property(card_sprite.material, "shader_parameter/x_rot", 0.0, 0.5)
	#tween_rot.tween_property(card_sprite.material, "shader_parameter/y_rot", 0.0, 0.5)
	


var velocity : Vector2
func rotate_velocity(delta: float) -> void:
	if not dragging: return
	#var center_pos: Vector2 = global_position - (screen_size/2.0) # <- What IS size meant to be?
	#var center_pos: Vector2 = global_position - (size/2.0)
	
	#print("Pos: ", center_pos)
	#print("Pos: ", starting_position)
	# Compute the velocity
	velocity = (position - starting_position) / delta
	
	starting_position = position
	
	#print("Velocity: ", velocity)
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	
	# Oscillator stuff
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	
	rotation = displacement

## Changes the shadow of the card based on x
func handle_shadow() -> void:
	# Y position doesn't change
	# X changes depending on how far card is from the center of the screen
	var center : Vector2 = get_viewport_rect().size / 2
	var distance : float = global_position.x - center.x
	
	# modifies position or offset which one is better idk i use offset now
	card_shadow.offset.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance/center.x))
	#card_shadow.position.x

## Flips the card face up to show the card's value
func flip_card(flipped: bool):
	card_face_up = flipped
	if flipped == true:
		$AnimationPlayer.play("card_flip")
		GameSfxBus.play(GameSfxBus.card_flip)
	else:
		$AnimationPlayer.play_backwards("card_flip")

## Moved from hand.gd. Animates a card from current position to the defined position
func animate_card_to_position(new_position):
	if has_meta("tween"):
		get_meta("tween").kill()
	
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_position", new_position, 0.5).set_trans(Tween.TRANS_SINE)

#var tween_destroy : Tween
## Destroys the card visually with a burn, then frees from queue.
func destroy_card() -> void:
	card_sprite.use_parent_material = true
	if tween_destroy and tween_destroy.is_running():
		tween_destroy.kill()
	
	tween_destroy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_destroy.tween_property(
		material, 
		"shader_parameter/dissolve_value", 
		0.0, 
		2.0).from(1.0)
	#tween_destroy.tween_method(
		#func(value: float): self.set_instance_shader_parameter('shader_parameter/dissolve_value', value), 
		#1.0, 0.0, 2.0)
	tween_destroy.parallel().tween_property(card_shadow, "self_modulate:a", 0.0, 1.0)
	
	#set_instance_shader_parameter("shader_parameter/dissolve_value", 0.0)
	
	await tween_destroy.finished
	queue_free() # does this work??
