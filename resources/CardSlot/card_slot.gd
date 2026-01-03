extends Sprite2D

## Based on the tutorial by Barry's dev hell : https://www.youtube.com/watch?v=1mM73u1tvpU 

## Collision mask & layer set to 2

@export var card_in_slot : bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if card_in_slot == false:
		pass
	elif card_in_slot:
		return
	pass # Replace with function body.
