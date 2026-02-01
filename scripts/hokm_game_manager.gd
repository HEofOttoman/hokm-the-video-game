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

@export var ui_manager : UIManager = UIManager.new()
@export var deck : Deck
@export var hands : Array[Node]
@export var trick_slots : Array[CardSlot]
@export var ai_controllers: Array[AIController]
@export var rulesEngine := RulesEngine.new()
@export var score_piles : Array[Control]

@export_group('Runtime Variables') ## Exposed for debugging ig
var current_player : int = 0 # The ID of the current player
var winner_index : int ## The ID of the winner of the last trick, so game knows who to give turn to next
var hakem_index : int ## Player ID of the hakem

@export var hokm_suit : CardData.Suit = CardData.Suit.HEARTS ## The current game's Hokm suit.
@export var trick_cards : Array = [] ## Used to look at the cards in a turn/trick and compare them. An array of instantiated card nodes.
#@export var trick_card : Dictionary = {
	#player_index, card_data
#}

@export var tricks_won : Array[int] = [0, 0] ## Tricks won in a single round
@export var score : Array[int] = [0, 0]

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

### --- UI Signals ---

## Turn started for hand of player_index
signal turn_started(player_index: int, text : String)
## Trick won for hand of winn_index
signal trick_resolved(winner_id: int)
## Round ended
signal round_ended(game_score: Array[int])

### --- Tutorial Signals ---
@warning_ignore("unused_signal")
signal state_changed(state: HokmGamePhase)
@warning_ignore("unused_signal")
signal card_played(played_id, card)
@warning_ignore("unused_signal")
signal card_drawn(player_id, card)

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
	
	print('Hakem: ', hakem, ' Index: ', hakem_index)
	ui_manager.hakem_display_label.text = str("Hakem: ", hakem.name) # Replace with function body.

	
	current_player = hakem_index
	
	return current_player
	#deck.draw_card()
	#return

func declaring_hokm(): ## Process for declaring the hokm
	## Add the process for declaring it here
	hokm_suit = CardData.Suit.values().pick_random()
	print('Hokm suit:', hokm_suit)
	ui_manager.hokm_display_label._on_hokm_chosen(hokm_suit)
	#$"../Hokm Display Label".text = str('Hokm Suit:', hokm_suit)
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

func scoring_game():
	current_game_phase = HokmGamePhase.SCORING
	
	print(tricks_won)
	
	finish_game()

func finish_game():
	current_game_phase = HokmGamePhase.GAME_OVER
	print('GAME OVER!!! THANKS FOR PLAYING!!!')
	#push_error('Game is over :>>') # 
	if tricks_won[0] == 7:
		$"../Win Lose Manager".game_won() ## ok, now I do
	else:
		$"../Win Lose Manager".game_lost()

func _on_card_drawn(card: Variant) -> void: ## Function used to add cards to hands automatically
	hands[current_player].receive_card(card)
	current_player = (current_player + 1) % hands.size()

func deal_cards(_player_id): ## Deal cards to each player
	var card = deck.draw_card()
	if not card:
		return
	
	
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

## Gets the card who wins the game
func resolve_trick():
	if trick_cards.is_empty(): ## Safeguard ig
		push_error('Trick cards is empty, invalid')
		return
	print('Resolving Trick')
	await get_tree().create_timer(1.5).timeout ## Stops game from going too fast
	
	var winning_card = rulesEngine.evaluate_trick(trick_cards, hokm_suit)
	winner_index = winning_card.player_index
	
	#winner_index = trick_cards.find(winning_card) ## Should find who put down the card..? (Probably won't work T-T)
	## OH YEAH THATS WHY! THE FIRST CARD MIGHT BE FROM THE AI, THUS INDEX 0, THUS  GET THE TRICK!
	
	print('WINNER: ', winner_index)
	
	tricks_won[winner_index] += 1
	print('TRICKS WON: ', tricks_won)
	ui_manager.score_display_label.text = str('TRICKS WON: ', tricks_won)
	emit_signal('trick_resolved', winner_index) ## For UI manager
	
	GameSfxBus.play(GameSfxBus.trick_won)
	trick_cards.clear()
	for slot in trick_slots: ## Animates cards to respective score piles
		var winner_pile : ScorePile = hands[winner_index].score_pile
		#slot.occupied_card.queue_free() ## Clears cards from game
		slot.occupied_card.set_interactive(false)
		slot.occupied_card.flip_card(false)
		slot.occupied_card.animate_card_to_position(winner_pile.global_position)
		winner_pile.add_card_to_pile(slot.occupied_card, tricks_won[winner_index])
		slot.remove_card_from_slot()
	
	current_player = winner_index ## Hopefully that works.. I keep having winner ID mismatches (trick win goes to wrong player)
	start_turn(winner_index)

@warning_ignore("unused_parameter")
#func play_card(card, slot, hand_cards, player_id: int): ## Adds the
func add_card_to_trick(card, slot, hand_cards, player_id: int): ## Adds the
	#print('Game Manager copies, attempting to check if card is playable')
	if player_id != current_player:
		push_error("NOT THIS PLAYER'S TURN")
		print("SERIOUS ERROR: NOT THIS PLAYER'S TURN")
		return
	
	if rulesEngine.can_play_card(card.card_data, 
	#slot, 
	trick_cards, 
	hand_cards) == false:
		#reject_play()
		print('Move is ILLEGAL, returning card')
		hands[player_id].add_card_to_hand(card)
		return
	
	#trick_cards.append(card)
	trick_cards.append(TrickEntry.new(player_id, card))
	
	print('Card is playable, appending to trick')
	
	if trick_cards.size() == player_count:
		resolve_trick()
	else: 
		print('Advancing turn')
		advance_turn()

### Supposed to be a failsafe if player IDs ever mismatch somehow
#func register_hands(): 
	#for hand in hands: 
		#hand.player_id = hands[hand]

func advance_turn(): ## Advances hand
	print('Next Turn')
	
	current_player = (current_player + 1) % hands.size()
	start_turn(current_player)

func start_turn(player_index: int): ## Starts the turn of the player with corresponding player id/index
	#emit_signal('turn_started', player_index)
	var active_hand := hands[player_index]
	
	if tricks_won[current_player] == 7: ## Checks to see if 7 tricks have been won and ends game accordi
		end_round()
	
	if active_hand.is_player_controlled:
		active_hand.set_interactive(true)
		emit_signal('turn_started', player_index, 'YOUR TURN')
		print("Player's turn")
		## Show hint that
	else:
		print("AI's turn")
		emit_signal('turn_started', player_index, str("PLAYER ", player_index, "'S TURN"))
		#hands[player_index].get_child().take_turn()
		$"../EnemyHand1/AIController".take_turn()

## Ending the round, aka 7 tricks won (keeping the game short first, limited to 1 round)
func end_round():
	#if winner_index == hakem_index and tricks_won[winner_index] == 7:
		#score[winner_index] += 2
	#elif winner_index != hakem_index and tricks_won[winner_index] == 7:
		#score[winner_index] += 3
	#else:
		#score[winner_index] += 1
	
	emit_signal('round_ended', score)
	scoring_game()

func _on_end_turn_test_btn_pressed() -> void:
	advance_turn() # Replace with function body.


func _on_resolve_trick_debug_btn_pressed() -> void:
	resolve_trick()
	# Replace with function body.
