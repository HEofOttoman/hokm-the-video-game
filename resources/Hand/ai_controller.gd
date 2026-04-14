extends Node
class_name AIController 
## Controls a hand node as an AI (parented to a hand node)

@onready var hand: HandClass = $".."
@export var game_manager : GameManager = GameManager.new()
@export var rulesEngine : RulesEngine = RulesEngine.new()

## AI Difficulty level. Currrently not implemented, DON'T TOUCH
@export var difficulty : Difficulty = Difficulty.NORMAL
enum Difficulty {
	EASY,
	NORMAL,
	HARD
}


## Signal connections?
func _on_stock_choice_requested(first_card) -> void:
	ai_stock_choice(first_card)

func ai_hokm_choice() -> CardData.Suit: ## Chooses hokm suit if given
	var hokm_suit = CardData.Suit.values().pick_random()
	print('Ai Chosen Hokm: ', hokm_suit)
	return hokm_suit

## Used to decide on stock draw decisions in 2p hokm
func ai_stock_choice(stock_first_card: CardInstance) -> bool:
	var stock_first_kept : bool
	
	var rank = stock_first_card.card_data.rank
	var suit = stock_first_card.card_data.suit
	
	if suit == game_manager.hokm_suit or rank >= 11:
		stock_first_kept = true
		return stock_first_kept
	else:
		stock_first_kept = false
		return stock_first_kept

## Takes the turn to put down a card during trick play.
func take_turn() -> void:
	print('Thinking Cooldown')
	await get_tree().create_timer(3.0).timeout ## Stops game from going too fast, inject animation here
	
	var legal_cards : Array = rulesEngine.get_legal_cards(
		hand.cards_in_hand, 
		#GameManager.leading_suit, 
		#GameManager.hokm_suit, 
		game_manager.trick_cards)
	
	#var chosen_card : CardData = choose_cards(
	var chosen_card : CardInstance = choose_cards(
		legal_cards,
		game_manager.hokm_suit,
		game_manager.trick_cards
	)
	print('CHOSEN CARD:', chosen_card)
	
	chosen_card.z_index +=1 # Fixed card not showing in-game. (could also change it myself)
	chosen_card.flip_card(true)
	chosen_card.animate_card_to_position(hand.trick_slot.global_position) # AHA THATS IT WHY CARDS ARENT SHOWING
	hand.remove_card_from_hand(chosen_card)
	hand.update_hand_positions()
	hand.trick_slot.add_card_to_slot(chosen_card)

	game_manager.add_card_to_trick(chosen_card, hand.trick_slot, hand.cards_in_hand, hand.player_id)
	
	#hand.request_play_card(chosen_card, hand.trick_slot) ## Somehow going through the hand first ruins everything
	#game_manager.play_card(chosen_card, hand.trick_slot, hand.cards_in_hand, hand.player_id)

## Chooses cards and places them
#func choose_cards(legal_cards: Array, hokm_suit : CardData.Suit, trick_cards : Array[CardData]) -> CardData:
func choose_cards(legal_cards: Array, hokm_suit : CardData.Suit, trick_cards : Array) -> Object:
	if hand.cards_in_hand.is_empty():
		push_error('Cards are empty, there is nothing to choose mate')
		return
	
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
			
			var leading_suit : CardData.Suit = trick_cards[0].card.card_data.suit
			print("LEADING SUIT:", leading_suit)
			
			var best_score := 0
			
			for card in legal_cards:
				
				var score = rulesEngine.get_card_strength(card.card_data, 
				leading_suit, 
				hokm_suit)
				
				if score > best_score:
					#score = best_score ## My mistake: switched these two around somehow 
					#card = best_card
					best_score = score
					best_card = card
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
