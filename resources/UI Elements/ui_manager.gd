extends Node
class_name UIManager

@onready var hud_layer: CanvasLayer = $HUDLayer
@onready var debug_layer: CanvasLayer = $DebugLayer

@export var hakem_display_label : Node
@export var hokm_display_label : Node
@export var score_display_label : Node

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed('debug_menu'):
		debug_layer.show()


func _on_game_manager_round_ended(score: Variant) -> void:
	pass # Replace with function body.


func _on_game_manager_trick_resolved(winner_id: Variant) -> void:
	pass # Replace with function body.


func _on_game_manager_turn_started(player_index: Variant) -> void:
	pass # Replace with function body.
