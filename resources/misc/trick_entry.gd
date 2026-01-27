extends RefCounted ## Maybe extend to resource later if needed
class_name TrickEntry
## Used to store data about tricks

var player_index : int
var card: CardInstance
var card_data : CardData ## Safeguards during migration

func _init(player_id: int, trick_card: CardInstance) -> void:
	self.player_index = player_id
	self.card = trick_card
	self.card_data = trick_card.card_data
