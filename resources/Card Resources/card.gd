extends Sprite2D

## Based on this tutorial;

## Unique Parts of a Card
@export_range(1,13) var value : int = 1 ## IMPORTANRT - Remember that in Hokm 2 is valued at 1 and 13 is the Ace!
@export_enum("Hearts", "Spades", "Diamonds", "Clubs") var suit : String = "Hearts"
@export var cardtexture : Texture

var hold : bool = false

func _ready() -> void:
	texture = cardtexture ## Sets the card texture as the default

func _process(_delta: float) -> void:
	if hold:
		global_position = get_global_mouse_position() ## Allows cards to be dragged around

## Detects Left Clicks
func _on_area_2d_card_action(left: bool) -> void:
	if left:
		print(value, suit + " Left Click")
		hold = true
	if not left:
		print("Right Click")
	
	pass # Replace with function body.


func _on_area_2d_card_release(left: bool) -> void: ## Releases cards when the LMB is no longer held down
	if left:
		print(value, suit + "Released")
		hold = false
