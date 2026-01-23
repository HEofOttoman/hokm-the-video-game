extends Node
class_name AIController ## Basic Enemy AI if I can get this working

#var hand : Array = []
@onready var hand: Node2D = $".."
@export var rulesEngine : RulesEngine = RulesEngine.new()

func _on_card_drawn(new_card_data: CardData):
	hand.player_hand.append(new_card_data)
	



#func play_cards(lead_suit : CardData.Suit, hokm_suit : CardData.Suit):
func take_turn():
	var legal_cards : Array = rulesEngine.get_legal_cards(
		hand.cards_in_hand, 
		#GameManager.leading_suit, 
		GameManager.hokm_suit, 
		GameManager.trick_cards)
	
	var chosen_card : CardData = choose_cards(
		legal_cards,
		GameManager.hokm_suit,
		GameManager.trick_cards
	)
	
	hand.remove_card_from_hand(chosen_card)
	hand.trick_slot.add_card_to_slot(chosen_card)
	#rules.play_card(chosen)
	#rulesEngine.can_play_card()

## Chooses cards and places them
func choose_cards(legal_cards, trick_cards, hokm_suit) -> CardData:
	return legal_cards.pick_random() # The dumbest version of the AI
	



func _on_ai_testing_btn_pressed() -> void:
	print('Initialise AI test')
	take_turn()
