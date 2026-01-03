extends Sprite2D
class_name Deck

## Based on this tutorial: https://www.youtube.com/watch?v=e7iuMLdWjgw

@export var cards : Array[Resource]
@export var cardScene : PackedScene
@export var draw_point : Node2D ## Where the cards are instantiated

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
		card.global_position = draw_point.global_position
		draw_point.add_child(card)
		
		
		print("Card ", card.value, card.suit, " drawn") ## Confirms that shuffle function works	
