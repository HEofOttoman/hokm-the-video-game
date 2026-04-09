extends Control
## The panel which holds hokm selection logic (signals)

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#hide() <- For some reason doesn't allow show later.
	#return

@warning_ignore("enum_variable_without_default")
@export var suit : CardData.Suit = CardData.Suit.HEARTS
signal hokm_chosen(chosen_suit: CardData.Suit)


## Uses signal to manage visibility instead of direct manipulation
func _on_hokm_selection_request():
	show()

func _on_clubs_pressed() -> void:
	suit = CardData.Suit.CLUBS
	emit_signal("hokm_chosen", suit)
	hide()

func _on_hearts_pressed() -> void:
	suit = CardData.Suit.HEARTS
	emit_signal("hokm_chosen", suit)
	hide()

func _on_spades_pressed() -> void:
	suit = CardData.Suit.SPADES
	emit_signal("hokm_chosen", suit)
	hide()

func _on_diamonds_pressed() -> void:
	suit = CardData.Suit.DIAMONDS
	emit_signal("hokm_chosen", suit)
	hide()
