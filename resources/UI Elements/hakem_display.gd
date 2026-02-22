extends Label

#@export var Hakem_name : String
#@export var hakem_label : Label


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#var _Hakem_name = "Kian"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func display_hakem(hakem_index):
	text = "Player %d" % hakem_index
	print('Displaying hakem')


#func _on_hakem_declared() -> void:
	#hakem_label.text = "Hakem:" + Hakem_name # Replace with function body.
