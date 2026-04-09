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
@export var rounds_won_display_label : Label

@export var ui_animation_player : AnimationPlayer

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed('debug_menu'):
		debug_layer.show()

signal hokm_chosen(hokm: CardData.Suit)
#@onready var hokm_selector: Panel = $HUDLayer/HokmSelector
signal hokm_selection_request

signal stock_keep
signal stock_discard

func _on_game_manager_round_ended(score: Variant) -> void:
	rounds_won_display_label.text = str('Rounds Won: ', score)
	# Replace with function body.


func _on_game_manager_trick_resolved(_winner_id: Variant) -> void:
	
	return # Replace with function body.


func _on_game_manager_turn_started(player_index: Variant, prompt_text: String) -> void:
	turn_indicator.text = "Player %d's Turn" % player_index
	turn_prompt.text = prompt_text
	#turn_prompt.get_child(0).play('fade_in_&_out')
	ui_animation_player.play('fade_in_&_out')

func _on_hokm_selection_requested()->void:
	emit_signal('hokm_selection_request')
	print('forward request to selector panel')
	#hokm_selector._on_hokm_selection()

func _on_hokm_selected(chosen_suit: CardData.Suit) -> void:
	emit_signal("hokm_chosen", chosen_suit)
	print('Hokm selected via button')
	#hokm_display_label._on_hokm_chosen(chosen_suit)


@onready var stock_choice_ui: Control = $HUDLayer/StockChoiceUI
## From Gamemanager
func _on_game_manager_show_stock_ui(stock_first_card: CardInstance) -> void:
	stock_choice_ui.show()
	#stock_first_card.animate_card_to_position(stock_choice_ui.preview_point.global_position)
	stock_choice_ui.display_card(stock_first_card)

func _on_stock_choice_ui_keep_pressed() -> void:
	emit_signal('stock_keep')
	print('ui says stock keep')

func _on_stock_choice_ui_discard_pressed() -> void:
	emit_signal('stock_discard')
	print('ui says stock discard')
	
