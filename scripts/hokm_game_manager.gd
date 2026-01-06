extends Node
class_name GameManager
## Should be the root of the scene?

## Number of players
@export var player_count : int = 4

enum HokmVariant { ## Same thing as player_count I guess
	TWO_PLAYER,
	THREE_PLAYER,
	FOUR_PLAYER,
}



## Umpire / RuleManager
### Checks if the turn is legal, and determines who wins

@export var rules = RulesEngine

#hand.input_enabled = (player_id == )

## TurnKeeper
### Checks the current player
### Advances turns
