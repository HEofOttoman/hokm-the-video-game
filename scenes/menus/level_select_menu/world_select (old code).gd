extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Goes to the world used for testing/tutorial
func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file("uid://dg3vbnm2f8mef")


func _on_dove_lake_pressed():
	get_tree().change_scene_to_file("res://Worlds/Cradle Mountain/Cradle Mountain.tscn")


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://UI/Main Menu/Main Menu.tscn")


func _on_tasmania_btn_pressed():
	get_tree().change_scene_to_file("res://Worlds/Tasmania/Tasmania.tscn") # 
	
