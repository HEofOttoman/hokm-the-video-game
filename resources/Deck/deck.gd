extends Sprite2D

## Based on this tutorial: https://www.youtube.com/watch?v=e7iuMLdWjgw

@export var cards : Array[Resource]
@export var cardScene : PackedScene
@export var Hand : Node2D

func shuffle():
	pass


## Draws a card from the Array of resources
func draw():
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
	
	## To-do check if array is empty and stop drawing cards
