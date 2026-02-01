extends Node
class_name PlayerController

## Intended for future use as an equivalent of the AIController class
## Might move hand input logic in this script, seperating it from the hand class

@export_group('Controller Variables')
@export var hand: HandClass = HandClass.new()
@export var gameManager : GameManager = GameManager.new()
@export var rulesEngine : RulesEngine = RulesEngine.new()

@export_group('Hand Variables')
@export var player_id : int = hand.player_id
@export var cards_in_hand : Array = hand.cards_in_hand

# ----
# Following code is mirrored from the hand class



## Toggles all cards in the hand interactive or not
func set_interactive(enabled: bool):
	for card in cards_in_hand:
		card.set_interactive(enabled)

func connect_card_signals(card):
	return card # <-- Placeholder
	#card.drag_started.connect(_on_drag_started) # <-- Disabled so the rest of the code is inactive
	#card.drag_ended.connect(_on_drag_ended)


func receive_card(card):
	add_child(card)
	card.global_position = $"../Deck".global_position
	
	connect_card_signals(card)
	
	hand.add_card_to_hand(card)
	if hand.is_player_controlled:
		card.flip_card(true) ## If owned by a player, flip the card
	elif hand.is_player_controlled == false:
		set_interactive(false)
	## Otherwise, card remains upside down
	#card.get_node("AnimationPlayer").play("card_flip") ## Plays the animation while tweening to position
	

func _on_drag_started(card):
	start_drag(card)

func _on_drag_ended(card):
	stop_drag(card)

func start_drag(card):
	#print('START DRAG CALLED') ## Was used to debug
	
	var card_slot_found = card.get_hovered_card_slot()
	if card_slot_found and card_slot_found.card_in_slot == true: 
		card_slot_found.remove_card_from_slot() ## Okay this works to fix the ghost slot bug, no need to make a new occupied state in the card
	## No use at all for starting card drag, was used for hover which is inside the card's script now.

func stop_drag(card): ## Should move cards to slots if found.
	#print('STOP DRAG CALLED') ## Was used to debug
	card.scale = Vector2(1.05, 1.05)
	var card_slot_found : CardSlot = card.get_hovered_card_slot()
	if card_slot_found and card_slot_found.card_in_slot == false and card_slot_found == hand.trick_slot: ## Card dropped in empty card slot
		## For later implementation
		#if rulesEngine.can_play_card(card, card_slot_found):
			#card_slot_found.add_card_to_slot()
			
		
		print('CARD SLOT FOUND:', card_slot_found)
		#remove_card_from_hand(card) 
		#card.position = card_slot_found.position
		#card_slot_found.add_card_to_slot(card)
		#request_play_card(card, card_slot_found)
		on_card_dropped(card, card_slot_found)
	
	else:
		#print('CARD SLOT NOT FOUND', card, card_slot_found)
		print('CARD SLOT NOT FOUND')
		hand.add_card_to_hand(card) ## Failed to find a card slot

#func request_play_card(card, card_slot_found):
## Called when a card is dropped into the card slot
func on_card_dropped(card, card_slot_found):
	#for i in gameManager.trick_cards.size():
		#print(i, " => ", gameManager.trick_cards[i])
	#print("TRICK CARDS:", gameManager.trick_cards)
	## ^Helped debug null trick_cards[]
	
	if gameManager.rulesEngine.can_play_card(card.card_data, 
	#card_slot_found, 
	gameManager.trick_cards, 
	cards_in_hand) == false:
		print('hand: card play not possible')
		return "cannot play card"
		#card_slot_found.add_card_to_slot()
	
	hand.remove_card_from_hand(card) 
	#card.position = card_slot_found.position
	card_slot_found.add_card_to_slot(card)
	print('card play requested, awaiting game manager')
	#gameManager.play_card(card, card_slot_found, cards_in_hand, player_id)
	gameManager.add_card_to_trick(card, card_slot_found, cards_in_hand, player_id)
	#emit_signal("card_played", card, card_slot_found)
