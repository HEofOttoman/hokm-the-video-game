extends Control

signal keep_pressed
signal discard_pressed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func display_card() -> void: 
	pass

func _on_discard_btn_pressed() -> void:
	emit_signal('discard_pressed')

func _on_keep_btn_pressed() -> void:
	emit_signal('keep_pressed')
