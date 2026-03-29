extends Panel

## From this ass tutorial https://www.youtube.com/watch?v=b7L-GarnI2U

#@onready var hud_panel: Panel = $MarginContainer/HBoxContainer/HudPanel
#@onready var menu_parent: MarginContainer = $MarginContainer

@export var closed: bool = false
@export var ui_animation_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#hud_panel.visible = false
	pass

func _set_menu(toggled) -> void:
	if toggled:
		ui_animation_player.play_backwards("sidebar_slide_inout")
		closed = true
	else:
		ui_animation_player.play("sidebar_slide_inout")
		closed = false
	#hud_panel.visible = wasClosed


func _on_sidebar_btn_toggled(toggled_on: bool) -> void:
	_set_menu(toggled_on)


#func _on_sidebar_btn_pressed() -> void:
	#set_menu() # Replace with function body.

func _close_all_menus()->void:
	pass
	#for menu in menu_parent.get_children():
		#menu.visible = false
