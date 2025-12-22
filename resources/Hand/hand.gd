class_name Hand_Behaviour
extends Node2D

## Card fanning attempt
## From this tutorial: https://www.youtube.com/watch?v=waVOR2ehpuU

@export var Card : PackedScene
@export var size = "size"

@export var curve : Curve
@export var rotation_curve : Curve

@export var max_rotation_degrees := 10
@export var x_sep := 20
@export var y_min := 50
@export var y_max := -50

## Try to fan out the cards... help  I
func _update_cards() -> void:
	var cards := get_child_count()
	var all_cards_size : float = Card.SIZE.x + x_sep * (cards - 1)
	var final_x_sep := x_sep
	
	if all_cards_size > size.x:
		final_x_sep = (size.x - Card.SIZE.x * cards) / (cards - 1)
	
	var offset : float = (size.x - all_cards_size) / 2
	
	for i in cards:
		var card := get_child(i)
		var y_multiplier := curve.sample(1.0 / (cards - 1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (cards - 1) * i)
		
		var final_x: float = offset + Card.SIZE.x * i + final_x_sep * i
		var final_y: float = y_min + y_max * y_multiplier
		
		card.position = Vector2(final_x, final_y)
		card.rotation_degrees = max_rotation_degrees * rot_multiplier

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
