extends Control

# Ad hoc version of the level selector


func _on_2p_btn_pressed() -> void:
	SceneLoader.load_scene('res://scenes/game_scene/levels/basic_test_scene.tscn')
	pass # Replace with function body.


func _on_close_button_pressed() -> void:
	close()
	pass # Replace with function body.

func close() -> void:
	SceneLoader.load_scene('res://scenes/menus/main_menu/main_menu_with_animations.tscn')
	#if not visible: return
	#hide()
	

### Original File:

## Loads a simple ItemList node within a margin container. SceneLister updates
## the available scenes in the directory provided. Activating a level will update
## the GameState's current_level, and emit a signal. The main menu node will trigger
## a load action from that signal.

#signal level_selected
#
#@onready var level_buttons_container: ItemList = %LevelButtonsContainer
#@onready var scene_lister: SceneLister = $SceneLister
#var level_paths : Array[String]
#
#func _ready() -> void:
	#add_levels_to_container()
	#
### A fresh level list is propgated into the ItemList, and the file names are cleaned
#func add_levels_to_container() -> void:
	#level_buttons_container.clear()
	#level_paths.clear()
	#var game_state := GameState.get_or_create_state()
	#for file_path in game_state.level_states.keys():
		#var file_name : String = file_path.get_file()  # e.g., "level_1.tscn"
		#file_name = file_name.trim_suffix(".tscn")  # Remove the ".tscn" extension
		#file_name = file_name.replace("_", " ")  # Replace underscores with spaces
		#file_name = file_name.capitalize()  # Convert to proper case
		#var button_name := str(file_name)
		#level_buttons_container.add_item(button_name)
		#level_paths.append(file_path)
#
#func _on_level_buttons_container_item_activated(index: int) -> void:
	#GameState.set_current_level(level_paths[index])
	#level_selected.emit()
