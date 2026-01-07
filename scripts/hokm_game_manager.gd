extends Node
class_name GameManager
## Should be the root of the scene?

## Number of players
#@export var player_count : int = 4 ## Im confused, just defining variables I might need later
@export var player_count : HokmVariant = HokmVariant.TWO_PLAYER ## Yea that's right

enum HokmVariant { ## Same thing as player_count I guess - Should change rules depending on the rules
	TWO_PLAYER = 2,
	THREE_PLAYER = 3,
	FOUR_PLAYER = 4,
}

@export var deck : Deck
@export var hands : Array[Node]
@export var trick_slots : Array[CardSlot]

var hakem_index : int ## Player ID
var hokm_suit : CardData.Suit = CardData.Suit.HEARTS ## The current game's Hokm suit
var winner_index


var current_player : int = 0
var leading_suit : CardData.Suit = CardData.Suit.HEARTS


var trick_cards : Array = [] ## Used to look at the cards in a turn and compare them

enum HokmGamePhase {
	AUCTIONING, ## Setting Hakem and deciding Hokm
	DEALING,
	PLAYING,
	SCORING
}

@export var game_phase : HokmGamePhase


func _ready() -> void:
	randomize()
	deck.shuffle_deck()
	
	#deal_initial_cards()
	
	if player_count == HokmVariant.THREE_PLAYER: ## Checks if the game's rules are different and change accordingly
		cards_per_player = 17
	else: 
		cards_per_player = 13
	
	start_game()
	
	#for i in range(hands.size()):
		#hands[i].player_id = i
	
	

func start_game():
	
	game_phase = HokmGamePhase.AUCTIONING
	#auctioning_game() ## Supposed to decide who is the Hakem, and choose the  and all that
	
	deal_initial_cards()

var cards_per_player = 13

func auctioning_game():
	declaring_hakem()
	declaring_hokm()

func declaring_hakem():
	deck.draw_card()
	return

func declaring_hokm(): ## Process for declaring the hokm
	## Add the process for declaring it here
	pass
	#hokm_chosen.emit(hokm)

func deal_initial_cards():
	for i in range(cards_per_player):
		for player_id in range(hands.size()):
			deal_cards(player_id)

func _on_card_drawn(card: Variant) -> void:
	hands[current_player].receive_card(card)
	current_player = (current_player + 1) % hands.size()

func deal_cards(_player_id): ## Deal cards to each player
	var card = deck.draw_card()
	if not card:
		return
	
	#hands[player_id].receive_card()
	
	for i in range(cards_per_player):
		hands[current_player].receive_card(card)
		current_player = (current_player + 1) % hands.size()


func _on_clubs_pressed() -> void:
	hokm_suit = CardData.Suit.CLUBS
	#hokm_chosen.emit(hokm)
func _on_hearts_pressed() -> void:
	hokm_suit = CardData.Suit.HEARTS
	#hokm_chosen.emit(hokm)
func _on_spades_pressed() -> void:
	hokm_suit = CardData.Suit.SPADES
	#hokm_chosen.emit(hokm)
func _on_diamonds_pressed() -> void:
	hokm_suit = CardData.Suit.DIAMONDS
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




#func register_hands(): ## idfk I forgot what I imagined this to work in 
	#for i in player_count: 
		#hands.append()

func advance_turn():
	pass
