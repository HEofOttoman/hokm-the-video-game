extends Node ## Should be refcounted later
#extends refCounted
class_name RulesEngine

### INTERNAL VERY COOL ENGINE 
### Translating game rules into math essentially
### Refer to https://www.pagat.com/whist/hokm.html for rules of Hokm

## Necessary reference to internal card values because CardData.suit doesn't work straight away T-T
#@export_range(1,13) var rank : int = 1 ## IMPORTANRT - Remember that in Hokm 2 is valued at 1 and 13 is the Ace!
#@export_enum("Hearts", "Spades", "Diamonds", "Clubs") var suit : String = "Hearts"

#const suit : String = CardData.Suit

#var card_data = CardData

#var hokm_suit = suit ## The current game's Hokm suit <-- actually nvm wrong place it should be in gamemanager
#var leading_suit = suit ## Current suit being played in the trick, ie. suit of first card in turn <-- oop no its not meant to be a state in here

#enum Suit {
	#HEARTS, 
	#SPADES, 
	#DIAMONDS, 
	#CLUBS 
#}

func can_play_card(
	## A bunch of variables to be passed to determine if a move is legal or not
	card: CardData, 
	card_slot_found
):
	pass

## In theory, this should assess the rank of a card, then pass it into a function that compares all cards drawn
func get_card_strength(card: CardData, leading_suit : String, hokm_suit: String) -> int:
	if card.suit == leading_suit:
		return 100 + card.rank
	if card.suit == hokm_suit:
		return 50 + card.rank
	return card.rank

func determine_trick_winner(hokm_suit):
	pass
