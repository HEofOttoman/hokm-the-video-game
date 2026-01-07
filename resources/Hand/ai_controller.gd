extends Node
class_name AIController

#var hand : Array = []
@onready var enemy_hand_1: Node2D = $".."

func _on_card_drawn(new_card_data: CardData):
	enemy_hand_1.player_hand.append(new_card_data)
	
