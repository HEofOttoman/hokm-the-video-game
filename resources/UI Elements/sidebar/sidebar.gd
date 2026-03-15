extends PanelContainer

@onready var hud_panel: Panel = $MarginContainer/HBoxContainer/HudPanel
@onready var menu_parent: MarginContainer = $MarginContainer

@export var closed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud_panel.visible = false

func _set_menu(menu) -> void:
	var wasClosed = menu.visible == false
	
	_close_all_menus()
	
	menu.visible = wasClosed
	hud_panel.visible = wasClosed

func _close_all_menus()->void:
	for menu in menu_parent.get_children():
		menu.visible = false


func _on_sidebar_btn_toggled(_toggled_on: bool) -> void:
	_set_menu(hud_panel)


func _on_sidebar_btn_pressed() -> void:
	_set_menu(hud_panel) # Replace with function body.
