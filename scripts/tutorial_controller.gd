extends Node
class_name TutorialController

@export var tutorial_active: bool = false
@export var tutorial_step : TutorialStep = TutorialStep.NONE
@export var game_manager: GameManager = GameManager.new()

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
	pass


func start():
	tutorial_step = TutorialStep.INTRO
	
	await on_continue_button_pressed()
	
