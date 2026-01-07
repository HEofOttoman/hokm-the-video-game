extends Node
class_name GameManager
## Should be the root of the scene?

## Number of players
@export var player_count : int = 4 ## Im confused, just defining variables I might need later

enum HokmVariant { ## Same thing as player_count I guess
	TWO_PLAYER,
	THREE_PLAYER,
	FOUR_PLAYER,
}

@export var hands : Array[Node]
@export var trick_slots : Array[CardSlot]

var hakem_index : int
var hokm_suit  ## The current game's Hokm suit
var winner_index
var current_player : int = 0
var leading_suit : String

var trick_cards : Array = []

enum HokmGamePhase {
	AUCTIONING, ## Setting Hakem and deciding Hokm
	DEALING,
	PLAYING,
	SCORING
}

@export var game_phase : HokmGamePhase


func _ready() -> void:
	game_phase = HokmGamePhase.AUCTIONING
	auctioning_game()

func auctioning_game():
	declaring_hakem()
	declaring_hokm()

func declaring_hakem():
	$"../Deck".draw_card()
	

func declaring_hokm(): ## Process for declaring the hokm
	## Add the process for declaring it here
	pass
	#hokm_chosen.emit(hokm)

## Umpire / RuleManager
### Checks if the turn is legal, and determines who wins

@export var rulesEngine := RulesEngine.new()

#hand.input_enabled = (player_id == )

func determine_trick_winner() -> int:
	return rulesEngine.get_trick_winner(trick_cards, hokm_suit, leading_suit)

## TurnKeeper
### Checks the current player
### Advances turns


func deal_cards(): ## Deal cards to each player
	for i in player_count:
		pass
		

#func register_hands(): ## idfk I forgot what I imagined this to work in
	#for i in player_count: 
		#hands.append()

func advance_turn():
	pass
