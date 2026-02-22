extends Node
class_name TutorialController

@export var tutorial_active: bool = false
@export var tutorial_step : TutorialStep = TutorialStep.NONE
@export var game_manager: GameManager = GameManager.new()
@export var interactive_tutorial: bool = false

@export var tutorial_ui : Control
@export var step_indicator : RichTextLabel
@export var tutorial_text : RichTextLabel
#@onready var next_button: Button = $TutorialLayer/NextButton
#@onready var finish_button: Button = $TutorialLayer/FinishButton
@export var next_button: Button
@export var finish_button: Button

var text_tween : Tween
var text_timer : Timer

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

func _on_tutorial_toggled(toggled_on: bool) -> void:
	tutorial_active = toggled_on # Replace with function body.
	tutorial_ui.visible = toggled_on
	#print(tutorial_active)
	if tutorial_active == true:
		start_tutorial()
	elif tutorial_active == false and tutorial_step > 0:
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
	tutorial_step = (tutorial_step + 1) % TutorialStep.size() as TutorialStep
	#step_indicator.text = str(tutorial_step)
	#step_indicator.text = str('(', tutorial_step, '/7)')


func start_tutorial() -> void:
	tutorial_ui.show()
	next_button.show()
	finish_button.hide()
	
	tutorial_step = TutorialStep.INTRO
	typewrite("Welcome to hokm! Let's learn the basics.")
	#print("Welcome to hokm! Let's learn the basics.")
	
	await next_button.pressed
	typewrite("In hokm, one of the players will be crowned king at the beginning of the round. Look at where the crown is to know who it is.")
	
	tutorial_step = TutorialStep.DEALING
	
	
	await next_button.pressed
	typewrite("Once the king is crowned, he can look at his cards, and choose a trump (hokm) suit.")
	
	await next_button.pressed
	typewrite("In this version, the game will randomly choose the trump suit, which you can see on the top left corner.")
	
	await next_button.pressed
	typewrite("Then, the entire 52 card-deck will be distributed equally for all players.")
	#await text_timer.timeout
	
	await next_button.pressed
	typewrite("The king will then go first. He can put down any card. The other player then has to match the suit of the first card.")
	
	await next_button.pressed
	typewrite("If one lacks a leading suit card, then you may use any card (no value) or one of the trump suit.")
	
	await next_button.pressed
	typewrite("Whoever has the put down the highest ranked card will win the deck. A trump card outvalues all other cards in addition to its own value.")
	
	await next_button.pressed
	typewrite("The first player to win 7 decks will win the round. Towards the end, the game tends to change very quickly as people run out of cards.")
	
	await next_button.pressed
	typewrite("Have fun!")
	next_button.hide()
	finish_button.show()


func _on_finish_button_pressed() -> void:
	finish_tutorial() # Replace with function body.


func _on_state_changed(state: GameManager.HokmGamePhase) -> void:
	if tutorial_step == TutorialStep.DEALING and state == GameManager.HokmGamePhase.AUCTIONING:
		tutorial_step = TutorialStep.CHOOSE_HOKM
		print('You are the hakem, or the leader this round. ')
	
	

func _on_card_played(_player_id: Variant, _card: Variant) -> void:
	pass # Replace with function body.


#func _on_card_drawn(_player_id: Variant, _card: Variant) -> void:
	#pass
	#pass # Replace with function body.


func _on_round_ended(_game_score: Array[int]) -> void:
	if TutorialStep.WIN_TRICK:
		print('GREAT! You won the round!')
		finish_tutorial()


func _on_trick_resolved(winner_id: int) -> void:
	#pass # Replace with function body.
	if game_manager.current_player == winner_id:
		if tutorial_step == TutorialStep.FOLLOW_SUIT:
			print("great! you won the trick")
			print("repeat what you've learned until one player reaches 7 tricks")
			print('Whoever does so first, wins.')
			print('GOOD LUCK')
		else:
			print('oh too bad, see if you can win the next round!')


func _on_turn_started(_player_index: int, _text: String) -> void:
	pass # Replace with function body.


func finish_tutorial() -> void:
	tutorial_step = TutorialStep.COMPLETE
	#await get_tree().create_timer(2.5).timeout
	tutorial_ui.hide()
