extends Control

signal keep_pressed
signal discard_pressed

@onready var card_preview_display: TextureRect = $StockChoicePanel/CardPreview ## Maybe not needed
@onready var preview_point: Node2D = $StockChoicePanel/PreviewPoint

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#hide()

#func display_card(card: CardInstance) -> void: 
	#card_preview_display.texture = card.cardtexture
	#card.animate_card_to_position(preview_point.global_position)

##  Displays card. Receives as well. Borrowed from hand receive_card()
func display_card(card: CardInstance) -> void:
	if card.get_parent():
		card.get_parent().remove_child(card)
	
	add_child(card)
	card.global_position = $"../../../Deck".global_position
	
	card_preview_display.texture = card.cardtexture
	card.animate_card_to_position(preview_point.global_position)
	card.flip_card(true)
	
	#connect_card_signals(card)
	#
	#add_card_to_hand(card)
	#if is_player_controlled:
		#card.flip_card(true) ## If owned by a player, flip the card
	#elif is_player_controlled == false:
		#set_interactive(false)
	

func _on_discard_btn_pressed() -> void:
	emit_signal('discard_pressed')

func _on_keep_btn_pressed() -> void:
	emit_signal('keep_pressed')
