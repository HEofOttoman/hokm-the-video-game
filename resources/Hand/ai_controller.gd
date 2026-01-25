extends Node
class_name AIController 
## Controls a hand node as an AI

#var hand : Array = []
@onready var hand: Node2D = $".."
@export var rulesEngine : RulesEngine = RulesEngine.new()
@export var game_manager : GameManager

## AI Difficulty level. Currrently not implemented, DON'T TOUCH
@export var difficulty : Difficulty = Difficulty.NORMAL
enum Difficulty {
	EASY,
	NORMAL,
	HARD
}


func take_turn():
	var legal_cards : Array = rulesEngine.get_legal_cards(
		hand.cards_in_hand, 
		#GameManager.leading_suit, 
		#GameManager.hokm_suit, 
		game_manager.trick_cards)
	
	var chosen_card : CardData = choose_cards(
		legal_cards,
		game_manager.hokm_suit,
		game_manager.trick_cards
	)
	
	hand.remove_card_from_hand(chosen_card)
	hand.trick_slot.add_card_to_slot(chosen_card)
	game_manager.play_card()
	#rules.play_card(chosen)
	#rulesEngine.can_play_card()

## Chooses cards and places them
func choose_cards(legal_cards: Array, hokm_suit : CardData.Suit, trick_cards : Array[CardData]) -> CardData:
	match difficulty:
		Difficulty.EASY:
			return legal_cards.pick_random() # The dumbest version of the AI
		Difficulty.NORMAL:
			var best_card : CardData = legal_cards[0] ## Best card in an array legal cards 
			var leading_suit : CardData.Suit = trick_cards[0].suit
			var best_score := 0
			
			for card in legal_cards:
				
				
				var score = rulesEngine.get_card_strength(card, leading_suit, hokm_suit)
				
				if score > best_score:
					score = best_score
					card = best_card
			
			return best_card
		#Difficulty.HARD:
			#get_best_move()
	print('can you even get this message?')
	return legal_cards.pick_random()

## Button to test the AI before actual turns
func _on_ai_testing_btn_pressed() -> void:
	print('Initialise AI test')
	take_turn()
