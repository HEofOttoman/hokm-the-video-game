extends Node
class_name AIController ## Basic Enemy AI if I can get this working

#var hand : Array = []
@onready var hand: Node2D = $".."
@export var rulesEngine : RulesEngine = RulesEngine.new()

func _on_card_drawn(new_card_data: CardData):
	hand.player_hand.append(new_card_data)
	

func play_cards(lead_suit : CardData.Suit, hokm_suit : CardData.Suit):
	var legal_cards : Array = rulesEngine.get_legal_cards(hand.cards, lead_suit, hokm_suit, hand.cards_in_hand)
	
	var chosen : CardData = choose_cards(legal_cards)
	
	hand.remove_card_from_hand(chosen)
	#rules.play_card(chosen)
	#rulesEngine.can_play_card()

## Chooses cards and places them
func choose_cards(legal_cards) -> CardData:
	return legal_cards.pick_random() # The dumbest version of the AI
	
