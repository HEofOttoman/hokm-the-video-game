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
	_card_slot_found: CardSlot,
	#leading_suit : CardData.Suit,
	trick_cards: Array,
	hand_cards: Array
) -> bool:
	
	if trick_cards.is_empty():
		print('Trick is empty, anything goes')
		return true
	
	if trick_cards == null:
		## Okay this guards against an error from when I forgot that I added an element in the exported array
		push_error("trick_cards[0] is null - invalid argument") 
		return true
	
	var leading_suit : CardData.Suit = trick_cards[0].card_data.suit
	print("TRICK CARDS:", leading_suit)
	
	if card.suit == leading_suit:
		print('Card matches leading suit, ')
		return true
	for hand_card in hand_cards:
		if hand_card.card_data.suit == leading_suit:
			print('you have something that is the leading suit, ')
			return false
		#else: return true
	
	return true

func get_leading_suit(trick_cards: Array):
	var leading_suit
	
	if trick_cards.is_empty(): 
		leading_suit = null
		print('leading suit is free')
	else:
		leading_suit = trick_cards[0].card_data.suit
	
	return leading_suit

@warning_ignore("unused_parameter")
func get_legal_cards(
	hand_cards: Array, ## Cards inside hand
	#leading_suit : CardData.Suit, ## Actually unnecessary, can calculate from trick_cards
	#hokm_suit: CardData.Suit, ## Suit of the hokm
	## Suit of the hokm, is actually not needed for legality
	trick_cards: Array[CardData]) -> Array[CardData]:
	## Cards inside the trick (table)
	var card_slot = 'cardslot' ## should I really be passing this in?
	var legal_cards : Array
	
	for card in hand_cards:
		#can_play_card(card, card_slot, leading_suit, cards, hand)
		can_play_card(card, card_slot, trick_cards, hand_cards)
		if true:
			legal_cards.append(card)
	return legal_cards

## In theory, this should assess the rank of a card, then pass it into a function that compares all cards drawn
func get_card_strength(card: CardData, leading_suit : CardData.Suit, hokm_suit: CardData.Suit) -> int:
	if card.suit == leading_suit:
		return 100 + card.rank
	if card.suit == hokm_suit:
		return 50 + card.rank
	print(card.rank)
	return card.rank

## Evaluates cards in the trick and returns a winning card.

func evaluate_trick(trick_cards, hokm_suit):
	var leading_suit = trick_cards[0]
	var winning_card = trick_cards[0]
	var highest_strength = get_card_strength(winning_card, leading_suit, hokm_suit)
	
	for i in range(1, trick_cards.size()):
		var card = trick_cards[i]
		var strength = get_card_strength(card, leading_suit, hokm_suit)
		
		if strength > highest_strength:
			strength = highest_strength
			winning_card = card
	#winner_index = trick_cards.find(winning_card) ## Should find who put down the card..? (Probably won't work T-T)
	#trick_cards.clear()
	return winning_card

#@warning_ignore("unused_parameter")
#func get_trick_winner(trick_cards, hokm_suit, leading_suit):
	#var card = trick_cards
	#
	#for i in trick_cards:
		#get_card_strength(card, leading_suit, hokm_suit)
		##return card.rank
