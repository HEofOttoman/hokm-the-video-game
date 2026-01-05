extends Sprite2D
class_name Deck

## Based on this tutorial: https://www.youtube.com/watch?v=e7iuMLdWjgw

@export var cards : Array[Resource] ## Array countaining data of all cards in a 52-card standard deck
@export var cardScene : PackedScene
@export var draw_point : Node2D ## Where the cards are instantiated

@export var CARD_DRAW_SPEED : float = 0.2 ## Speed of the cards being drawn

signal card_drawn(card)

func shuffle_deck():
	cards.shuffle()
	print("Cards have been shuffled")

#signal deck_clicked
#func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	#if event.is_action_pressed("ClickL"):
		##deck_clicked.emit(true)
		##print("left click")
	##if event.is_action_pressed("ClickR"):
		##deck_clicked.emit(false)
		###print("right click")
	##
	##if event.is_action_released("ClickL"): ## Checks if LMB is no longer held down
		##deck_clicked.emit(true)
	##if event.is_action_pressed("ClickR"):
		##deck_clicked.emit(false)

## Draws a card from the Array of CardData resources
func draw_card():
	if cards.is_empty(): ## Checks whether the deck is empty or not
		visible = false
		print("Deck is empty") ## Safely stops the game from crashing
		return
		
	else: ## If deck still contains cards:
		### Based on the barry tutorial as well
		#for i in range(cards.size()): # Instantiates a card on start with a loop
		
		var data = cards.pop_back()
		var new_card = cardScene.instantiate()
		new_card.value = data.value #
		new_card.suit = data.suit
		new_card.cardtexture = data.cardtexture
		
		emit_signal("card_drawn", new_card)
		
		## Function of the code below migrated to playerhand.gd
		#$"../PlayerHand".add_child(new_card)
		#new_card.name = "card"
		## ^Idk the use of this tbh
		
		#$"../PlayerHand".add_card_to_hand(new_card) #, CARD_DRAW_SPEED)
		#new_card.get_node("AnimationPlayer").play("card_flip")
		#print("cards instantiated")
		
		$DeckCounter.text = str(cards.size()) ## Updates the deck counter
		
		
	### Older Version
	#if cards.is_empty(): ## Checks whether the deck is empty or not
		#print("Deck is empty") ## Safely stops the game from crashing
		#return
		
	#else:
		## Prepares the data
		#var data = cards.pop_back()
		#var card = cardScene.instantiate()
		
		
		### Sets the values
		#card.value = data.value #
		#card.suit = data.suit
		#card.cardtexture = data.cardtexture
		#
		### Creates and adds the card to the scene
		#card.global_position = draw_point.global_position
		#draw_point.add_child(card)
		#
		#
		#print("Card ", card.value, card.suit, " drawn") ## Confirms that shuffle function works	
