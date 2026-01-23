extends Node
class_name GameManager
## Should be the root of the scene?

## Number of players
@export var player_count : HokmGameMode = HokmGameMode.TWO_PLAYER ## Yea that's right

@export_group('Game Variables')
enum HokmGameMode { ## Same thing as player_count I guess - Should change rules depending on the rules
	TWO_PLAYER = 2,
	THREE_PLAYER = 3,
	FOUR_PLAYER = 4,
}

@export var deck : Deck
@export var hands : Array[Node]
@export var trick_slots : Array[CardSlot]

var hakem_index : int ## Player ID
var hokm_suit : CardData.Suit = CardData.Suit.HEARTS ## The current game's Hokm suit
var winner_index : int

var current_player : int = 0
var leading_suit : CardData.Suit = CardData.Suit.HEARTS

var trick_cards : Array = [] ## Used to look at the cards in a turn/trick and compare them

var cards_per_player = 13

enum HokmGamePhase {
	INIT,
	DEAL_INITIAL_CARDS,
	AUCTIONING, ## Setting Hakem and deciding Hokm
	DEAL_REMAINING_CARDS,
	TRICK_PLAY,
	SCORING,
	GAME_OVER
}

@export var current_game_phase : HokmGamePhase

func _ready() -> void:
	randomize()
	deck.shuffle_deck()
	
	initialise_game()
	#for i in range(hands.size()):
		#hands[i].player_id = i

func initialise_game():
	current_game_phase = HokmGamePhase.INIT
	print('Game initial phase', current_game_phase)
	#auctioning_game() ## Supposed to decide who is the Hakem, and choose the  and all that
	
	deal_initial_cards()

func deal_initial_cards():
	current_game_phase = HokmGamePhase.DEAL_INITIAL_CARDS
	print('Dealing Initial Cards', current_game_phase)
	
	cards_per_player = 5
	
	for i in range(cards_per_player):
		for player_id in range(hands.size()):
			deal_cards(player_id)
	
	current_game_phase = HokmGamePhase.AUCTIONING
	auctioning_game()

func auctioning_game():
	await declaring_hakem()
	print('Hakem declared')
	await declaring_hokm()
	print('Hokm declared')
	
	await get_tree().create_timer(5.0).timeout
	current_game_phase = HokmGamePhase.DEAL_REMAINING_CARDS
	deal_remaining_cards()

func declaring_hakem():
	var hakem = hands.pick_random()
	
	print('Hakem:', hakem)
	return
	#deck.draw_card()
	#return

func declaring_hokm(): ## Process for declaring the hokm
	## Add the process for declaring it here
	hokm_suit = CardData.Suit.values().pick_random()
	print('Hokm suit:', hokm_suit)
	#hokm_chosen.emit(hokm)

func deal_remaining_cards():
	print('Dealing Remaining Cards', current_game_phase)
	if player_count == HokmGameMode.THREE_PLAYER: ## Checks if the game's rules are different and change accordingly
		cards_per_player = 17
	else: 
		cards_per_player = 13
	
	for i in range(cards_per_player):
		for player_id in range(hands.size()):
			deal_cards(player_id)
	
	deck.discard_deck()
	# Discarding remaining cards
	
	trick_play()

func trick_play():
	current_game_phase = HokmGamePhase.TRICK_PLAY
	print('Begin Trick Play', current_game_phase)
	
	if trick_cards.size() == hands.size():
		resolve_trick()

func scoring_cards():
	current_game_phase = HokmGamePhase.SCORING
	
	finish_game()

func finish_game():
	current_game_phase = HokmGamePhase.GAME_OVER

func _on_card_drawn(card: Variant) -> void: ## Function used to add cards to hands automatically
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


#func determine_trick_winner(): #trick_cards, leading_suit, hokm_suit
	##return rulesEngine.get_trick_winner(trick_cards, leading_suit, hokm_suit)
	#var card = trick_cards
	#
	#for i in range(1, trick_cards.size()):
		#rulesEngine.get_card_strength(card, leading_suit, hokm_suit)
		##return card.rank

func resolve_trick():
	leading_suit = trick_cards[0]
	var winning_card = trick_cards[0]
	var highest_strength = rulesEngine.get_card_strength(winning_card, leading_suit, hokm_suit)
	
	for i in range(1, trick_cards.size()):
		var card = trick_cards[i]
		var strength = rulesEngine.get_card_strength(card, leading_suit, hokm_suit)
		
		if strength > highest_strength:
			strength = highest_strength
			winning_card = card
	return winning_card
	
	#return rulesEngine.get_trick_winner(trick_cards, hokm_suit, leading_suit)

func _on_card_played(card, slot): ## Connect to signal emitted by something else
	if not rulesEngine.can_play_card(card, slot, leading_suit):
		#reject_play()
		pass
	
	trick_cards.append(card)
	
	if trick_cards.size() == player_count:
		resolve_trick()
	else: 
		advance_turn()


## TurnKeeper
### Checks the current player
### Advances turns

#func register_hands(): ## idfk I forgot what I imagined this to work in 
	#for i in player_count: 
		#hands.append()



func advance_turn():
	current_player = (current_player + 1) % hands.size()
