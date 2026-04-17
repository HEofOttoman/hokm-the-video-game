extends Node
class_name TutorialController

@export var tutorial_active: bool = false
#@export var tutorial_step : TutorialStep = TutorialStep.NONE
@export var game_manager: GameManager = GameManager.new()
@export var interactive_tutorial: bool = false

@export var tutorial_ui : Control
@export var step_indicator : RichTextLabel
@export var tutorial_text : RichTextLabel
#@onready var next_button: Button = $TutorialLayer/NextButton
#@onready var finish_button: Button = $TutorialLayer/FinishButton
@export var next_button: Button
@export var finish_button: Button

@export_enum('2P', '3P', '4P') var tutorial_mode

@export var tutorial_steps : Array[TutorialStepData] = [] ## Array of text resources with names to cycle through
@export var tutorial_index : int = 0

var text_tween : Tween
var text_timer : Timer

#enum TutorialStep {
	#NONE,
	#INTRO,
	#DEALING,
	#CHOOSE_HOKM,
	#PLAY_FIRST_CARD,
	#FOLLOW_SUIT,
	#WIN_TRICK,
	#COMPLETE
#}

func _on_tutorial_toggled(toggled_on: bool) -> void:
	tutorial_active = toggled_on # Replace with function body.
	tutorial_ui.visible = toggled_on
	#print(tutorial_active)
	if tutorial_active == true:
		start_tutorial()
	elif tutorial_active == false and tutorial_index > 0:
		return

## Prints text to the label with a typewriter effect
func typewrite(text_string: String) -> void:
	tutorial_text.text = text_string
	
	if text_tween:
		text_tween.kill()
	
	text_tween = create_tween()
	
	text_tween.tween_property(tutorial_text, "visible_characters", tutorial_text.get_total_character_count(), 0.75)
	#text_tween.tween_property(tutorial_text, "visible_characters", -1, 0.1)

func _on_next_button_pressed() -> void:
	#tutorial_step += 1 # Replace with function body.
	#tutorial_step = (tutorial_step + 1) % TutorialStep.size() as TutorialStep
	#step_indicator.text = str(tutorial_step)
	#step_indicator.text = str('(', tutorial_step, '/7)')
	#advance_tutorial()
	return

func advance_tutorial() -> void:
	#tutorial_step += 1 # Replace with function body.
	return
	#tutorial_step = (tutorial_step + 1) % TutorialStep.size() as TutorialStep
	#step_indicator.text = str(tutorial_step)
	#step_indicator.text = str('(', tutorial_step, '/7)')

## More modular system
func start_steps()->void:
	for i in range(tutorial_steps.size()):
		var text = tutorial_steps[i].instructions
		step_indicator.text = tutorial_steps[i].step_name
		typewrite(text)
		await next_button.pressed
	next_button.hide()
	finish_button.show()

func start_tutorial() -> void:
	tutorial_text.clear()
	tutorial_ui.show()
	next_button.show()
	finish_button.hide()
	#$TutorialLayer/Narrator/TutorialAnimationPlayer.play("narrator appear", 0, 1.25)
	start_steps()


func _on_finish_button_pressed() -> void:
	finish_tutorial() # Replace with function body.


func _on_state_changed(state: GameManager.HokmGamePhase) -> void:
	#if tutorial_step == TutorialStep.DEALING and state == GameManager.HokmGamePhase.AUCTIONING:
		#tutorial_step = TutorialStep.CHOOSE_HOKM
		#print('You are the hakem, or the leader this round. ')
	#
	return

func _on_card_played(_player_id: Variant, _card: Variant) -> void:
	pass # Replace with function body.


#func _on_card_drawn(_player_id: Variant, _card: Variant) -> void:
	#pass
	#pass # Replace with function body.


func _on_round_ended(_game_score: Array[int]) -> void:
	#if TutorialStep.WIN_TRICK:
		#print('GREAT! You won the round!')
		#finish_tutorial()
	return


#func _on_trick_resolved(winner_id: int) -> void:
	##pass # Replace with function body.
	#if game_manager.current_player == winner_id:
		#if tutorial_step == TutorialStep.FOLLOW_SUIT:
			#print("great! you won the trick")
			#print("repeat what you've learned until one player reaches 7 tricks")
			#print('Whoever does so first, wins.')
			#print('GOOD LUCK')
		#else:
			#print('oh too bad, see if you can win the next round!')


func _on_turn_started(_player_index: int, _text: String) -> void:
	pass # Replace with function body.


func finish_tutorial() -> void:
	#tutorial_step = TutorialStep.COMPLETE
	#await get_tree().create_timer(2.5).timeout
	#$TutorialLayer/Narrator/TutorialAnimationPlayer.play_backwards("narrator appear")
	tutorial_ui.hide()
