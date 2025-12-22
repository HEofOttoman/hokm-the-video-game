extends Sprite2D
class_name Deck

## Based on this tutorial: https://www.youtube.com/watch?v=e7iuMLdWjgw

@export var cards : Array[Resource]
@export var cardScene : PackedScene
@export var Hand : Node2D

func shuffle_deck():
	cards.shuffle()

## Draws a card from the Array of CardData resources
func draw():
	if cards.is_empty(): ## Checks whether the deck is empty or not
		print("Deck is empty") ## Safely stops the game from crashing
		return
		
	else: ## If deck still contains cards:
		## Prepares the data
		var data = cards.pop_back()
		var card = cardScene.instantiate()
		
		## Sets the values
		card.value = data.value #
		card.suit = data.suit
		card.cardtexture = data.cardtexture
		
		## Creates and adds the card to the scene
		card.global_position = Hand.global_position
		Hand.add_child(card)
		
		print("Card ", card.value, card.suit, "drawn") ## Confirms that shuffle function works	
