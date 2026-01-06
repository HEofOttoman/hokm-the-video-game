extends Node
class_name GameManager
## Should be the root of the scene?

## Number of players
@export var player_count : int = 4

var hokm_suit ## The current game's Hokm suit

var hands : Array

enum HokmVariant { ## Same thing as player_count I guess
	TWO_PLAYER,
	THREE_PLAYER,
	FOUR_PLAYER,
}

func deal_cards(): ## Deal cards to each player
	for i in player_count:
		pass
		

func register_hands():
	pass

var winner_index

## Umpire / RuleManager
### Checks if the turn is legal, and determines who wins

@export var rules := RulesEngine.new()

#hand.input_enabled = (player_id == )

## TurnKeeper
### Checks the current player
### Advances turns
