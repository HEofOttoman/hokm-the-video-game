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
@export var ai_controllers: Array[AIController]
@export var rulesEngine := RulesEngine.new()

@export_group('Runtime Variables')
var current_player : int = 0 # The ID of the current player
var winner_index : int ## The ID of the winner of the last trick, so game knows who to give turn to next
var hakem_index : int ## Player ID of the hakem

@export var hokm_suit : CardData.Suit = CardData.Suit.HEARTS ## The current game's Hokm suit
@export var trick_cards : Array = [] ## Used to look at the cards in a turn/trick and compare them
#@export var trick_card : Dictionary = {
	#player_index, card_data
#}

var cards_per_player = 13

@export var current_game_phase : HokmGamePhase
enum HokmGamePhase {
	INIT, ## Initial game start
	DEAL_INITIAL_CARDS, ## Deals 5 cards to all players
	AUCTIONING, ## Setting Hakem and deciding Hokm
	DEAL_REMAINING_CARDS, ## Deals remaining cards to all players
	TRICK_PLAY, ## Begin game
	SCORING, ## Counts points
	GAME_OVER ## Ends game
}

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
	await declaring_hokm()
	print('Hokm declared')
	
	await get_tree().create_timer(3.0).timeout
	current_game_phase = HokmGamePhase.DEAL_REMAINING_CARDS
	deal_remaining_cards()

func declaring_hakem():
	var hakem = hands.pick_random()
	hakem_index = hands.find(hakem)
	
	print('Hakem:', hakem, 'Index:', hakem_index)
	
	current_player = hakem_index
	
	print('Hakem:', hakem)
	print('Hakem declared')
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
	
	start_turn(hakem_index)
	
	
	#if trick_cards.size() == hands.size():
		#resolve_trick()
	#else: 
		#advance_turn()

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

#hand.input_enabled = (player_id == )

#func determine_trick_winner(): #trick_cards, leading_suit, hokm_suit
	##return rulesEngine.get_trick_winner(trick_cards, leading_suit, hokm_suit)
	#var card = trick_cards
	#
	#for i in range(1, trick_cards.size()):
		#rulesEngine.get_card_strength(card, leading_suit, hokm_suit)
		##return card.rank

## Gets the card who wins the game
func resolve_trick():
	var winning_card = rulesEngine.evaluate_trick(trick_cards, hokm_suit)
	#var leading_suit = trick_cards[0]
	#var winning_card = trick_cards[0]
	#var highest_strength = rulesEngine.get_card_strength(winning_card, leading_suit, hokm_suit)
	#
	#for i in range(1, trick_cards.size()):
		#var card = trick_cards[i]
		#var strength = rulesEngine.get_card_strength(card, leading_suit, hokm_suit)
		#
		#if strength > highest_strength:
			#strength = highest_strength
			#winning_card = card
	winner_index = trick_cards.find(winning_card) ## Should find who put down the card..? (Probably won't work T-T)
	trick_cards.clear()
	#return winning_card
	
	#return rulesEngine.get_trick_winner(trick_cards, hokm_suit, leading_suit)

#func connect_hand_signals(hand):
	#hand.request_play_card.connect(play_card)

func play_card(card, slot, hand_cards, player_id: int): ## Adds the
	print('Game Manager copies, attempting to check if card is playable')
	if player_id != current_player:
		return "not this player's turn"
	if rulesEngine.can_play_card(card.card_data, slot, trick_cards, hand_cards) == false:
		#reject_play()
		print('error')
		return "cannot play card"
	
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
	print('next turn')
	current_player = (current_player + 1) % hands.size()
	start_turn(current_player)

func start_turn(player_index: int): ## Starts the turn of the player with corresponding player id/index
	var active_hand := hands[player_index]
	
	active_hand.set_interactive(true)
	
	if active_hand.is_player_controlled:
		print("Player's turn")
		## Show hint that
	else:
		print("AI's turn")
		#hands[player_index].get_child().take_turn()
		$"../EnemyHand1/AIController".take_turn()

func _on_end_turn_test_btn_pressed() -> void:
	advance_turn() # Replace with function body.
