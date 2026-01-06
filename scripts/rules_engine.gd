extends Node ## Should be refcounted later
#extends refCounted
class_name RulesEngine

### Refer to https://www.pagat.com/whist/hokm.html for rules of Hokm



var hokm_suit : Suit ## The current game's Hokm suit
var leading_suit : Suit ## Current suit being played

enum Suit {
	HEARTS, 
	SPADES, 
	DIAMONDS, 
	CLUBS 
}

func can_play_card(
	# A bunch of variables to be passed to determine if a move is legal or not
	card, 
	card_slot_found
):
	pass

func determine_trick_winner():
	
