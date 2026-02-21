extends Node
class_name TutorialController

@export var tutorial_active: bool = false
@export var tutorial_step : TutorialStep = TutorialStep.NONE
@export var game_manager: GameManager = GameManager.new()

@export var tutorial_ui : Control

enum TutorialStep {
	NONE,
	INTRO,
	DEALING,
	CHOOSE_HOKM,
	PLAY_FIRST_CARD,
	FOLLOW_SUIT,
	WIN_TRICK,
	COMPLETE
}

func on_continue_button_pressed():
	return


func start_tutorial():
	tutorial_ui.show()
	tutorial_step = TutorialStep.INTRO
	print("Welcome to hokm! Let's learn the basics.")
	
	await on_continue_button_pressed()
	
	tutorial_step = TutorialStep.DEALING
	


func _on_hokm_tutorial_state_changed(state: GameManager.HokmGamePhase) -> void:
	if tutorial_step == TutorialStep.DEALING and state == GameManager.HokmGamePhase.AUCTIONING:
		tutorial_step = TutorialStep.CHOOSE_HOKM
		print('You are the hakem, or the leader this round. ')
	#pass # Replace with function body.


func _on_hokm_tutorial_card_played(_player_id: Variant, _card: Variant) -> void:
	pass # Replace with function body.


func _on_hokm_tutorial_card_drawn(_player_id: Variant, _card: Variant) -> void:
	pass
	#pass # Replace with function body.


func _on_hokm_tutorial_round_ended(game_score: Array[int]) -> void:
	if TutorialStep.WIN_TRICK:
		print('GREAT! You won the round!')
		finish_tutorial()


func _on_hokm_tutorial_trick_resolved(winner_id: int) -> void:
	#pass # Replace with function body.
	if tutorial_step == TutorialStep.FOLLOW_SUIT:
		print("great! you won the trick")
		print("repeat what you've learned until one player reaches 7 tricks")
		print('Whoever does so first, wins.')
		print('GOOD LUCK')


func _on_hokm_tutorial_turn_started(player_index: int, _text: String) -> void:
	pass # Replace with function body.


func finish_tutorial() -> void:
	tutorial_step = TutorialStep.COMPLETE
	await get_tree().create_timer(2.5).timeout
	tutorial_ui.hide()
