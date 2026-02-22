extends Node
class_name UIManager

@onready var hud_layer: Node = $HUDLayer
@onready var debug_layer: Node = $DebugLayer

@export var hakem_display_label : Label
#@onready var hakem_display_label: Label = $HUDLayer/HakemDisplayLabel
@export var hokm_display_label : Label
@export var score_display_label : Label
@export var turn_indicator : Label
@export var turn_prompt : Label

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed('debug_menu'):
		debug_layer.show()


func _on_game_manager_round_ended(_score: Variant) -> void:
	
	pass # Replace with function body.


func _on_game_manager_trick_resolved(_winner_id: Variant) -> void:
	
	pass # Replace with function body.


func _on_game_manager_turn_started(player_index: Variant, prompt_text: String) -> void:
	turn_indicator.text = "Player %d's Turn" % player_index
	turn_prompt.text = prompt_text
	turn_prompt.get_child(0).play('fade_in_&_out')
