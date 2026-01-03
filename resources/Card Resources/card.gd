extends Sprite2D

## Based on this tutorial; https://www.youtube.com/watch?v=e7iuMLdWjgw (Noontime Dreamer)
## Helped also by Barry's Dev Hell: https://www.youtube.com/watch?v=1mM73u1tvpU

## Unique Parts of a Card
@export_range(1,13) var value : int = 1 ## IMPORTANRT - Remember that in Hokm 2 is valued at 1 and 13 is the Ace!
@export_enum("Hearts", "Spades", "Diamonds", "Clubs") var suit : String = "Hearts"
@export var cardtexture : Texture
@export var backtexture : Texture = preload("res://assets/Sprites/Cards/kenney_playing-cards-pack/PNG/Cards (large)/card_back.png")

@export var custom_default_scale : Vector2

signal hovered
signal hovered_off

var starting_position : Vector2

var hold : bool = false
var screen_size : Vector2

func _ready() -> void:
	self.scale = custom_default_scale
	screen_size = get_viewport_rect().size 
	## ^Review this code, the viewport doesn't clamp at the right places
	texture = cardtexture ## Sets the card texture as the default
	get_parent().connect_card_signals(self)
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
	


func _on_area_2d_mouse_exited() -> void:
	emit_signal('hovered_off', self)
	
