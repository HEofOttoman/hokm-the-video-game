extends Node
class_name AIController 
## Controls a hand node as an AI

@onready var hand: Node2D = $".."
@export var game_manager : GameManager = GameManager.new()
@export var rulesEngine : RulesEngine = RulesEngine.new()

## AI Difficulty level. Currrently not implemented, DON'T TOUCH
@export var difficulty : Difficulty = Difficulty.NORMAL
enum Difficulty {
	EASY,
	NORMAL,
	HARD
}


func take_turn():
	print('Thinking Cooldown')
	await get_tree().create_timer(3.0).timeout ## Stops game from going too fast, inject animation here
	
	var legal_cards : Array = rulesEngine.get_legal_cards(
		hand.cards_in_hand, 
		#GameManager.leading_suit, 
		#GameManager.hokm_suit, 
		game_manager.trick_cards)
	
	#var chosen_card : CardData = choose_cards(
	var chosen_card := choose_cards(
		legal_cards,
		game_manager.hokm_suit,
		game_manager.trick_cards
	)
	print('CHOSEN CARD:', chosen_card)
	
	#hand.remove_card_from_hand(chosen_card)
	chosen_card.flip_card(true)
	hand.trick_slot.add_card_to_slot(chosen_card)
	chosen_card.animate_card_to_position(hand.trick_slot.global_position) # AHA THATS IT WHY CARDS ARENT SHOWING
	hand.remove_card_from_hand(chosen_card)
	hand.update_hand_positions()
	#hand.request_play_card(chosen_card, hand.trick_slot) ## Somehow going through the hand first ruins everything
	game_manager.play_card(chosen_card, hand.trick_slot, hand.cards_in_hand, hand.player_id)

## Chooses cards and places them
#func choose_cards(legal_cards: Array, hokm_suit : CardData.Suit, trick_cards : Array[CardData]) -> CardData:
func choose_cards(legal_cards: Array, hokm_suit : CardData.Suit, trick_cards : Array) -> Object:
	match difficulty:
		Difficulty.EASY:
			return legal_cards.pick_random() # The dumbest version of the AI
		Difficulty.NORMAL:
			#var best_card : CardData = legal_cards[0] ## Best card in an array legal cards 
			var best_card = legal_cards[0] ## Best card in an array legal cards 
			#var leading_suit : CardData.Suit = trick_cards[0].suit
			
			if trick_cards.is_empty():
				return legal_cards.pick_random() ## IMPORTANT failsafe if trick_cards is empty,
				## ^ Otherwise, `Out of bounds get index '0' (on base: 'Array')`
			
			var leading_suit : CardData.Suit = trick_cards[0].card_data.suit
			print("LEADING SUIT:", leading_suit)
			
			var best_score := 0
			
			
			for card in legal_cards:
				
				var score = rulesEngine.get_card_strength(card.card_data, 
				leading_suit, 
				hokm_suit)
				
				if score > best_score:
					score = best_score
					card = best_card
			print('BEST CARD:', best_card)
			return best_card
		#Difficulty.HARD:
			#get_best_move()
	print('can you even get this message?')
	push_error('wow you got this message somehow')
	return legal_cards.pick_random()

## Button to test the AI before actual turns
func _on_ai_testing_btn_pressed() -> void:
	print('Initialise AI test')
	take_turn()
