extends Panel

@export var Hakem_name = "Hakem"
@export var hakem_label : Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hakem_label.text = Hakem_name + "hello"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
