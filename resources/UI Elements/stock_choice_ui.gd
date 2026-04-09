extends Control

signal keep_pressed
signal discard_pressed

@onready var card_preview_display: TextureRect = $StockChoicePanel/CardPreview

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func display_card(card: CardInstance) -> void: 
	card_preview_display.texture = card.cardtexture

func _on_discard_btn_pressed() -> void:
	emit_signal('discard_pressed')

func _on_keep_btn_pressed() -> void:
	emit_signal('keep_pressed')
