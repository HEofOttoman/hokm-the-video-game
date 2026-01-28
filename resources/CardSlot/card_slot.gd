extends Sprite2D
class_name CardSlot

## Based on the tutorial by Barry's dev hell : https://www.youtube.com/watch?v=1mM73u1tvpU 

## Collision mask & layer set to 2

@export var card_in_slot : bool = false ## State of whether there is a card inside or not

@export var slot_type : SlotType = SlotType.Trick_Slot

var occupied_card = null

@export var snap_sfx : AudioStream = preload("res://assets/Audio/kenney_ui-audio/Audio/click4.ogg")

enum SlotType { ## Different slots have different behaviours
	Trick_Slot,
	Discard_Slot,
	Temporary_Reveal_Slot, # For 
	Auction_Slot 
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func add_card_to_slot(card): ## Places card inside of slot
	card_in_slot = true
	occupied_card = card
	card.scale = Vector2(0.6, 0.6)
	card.global_position = self.global_position
	card.rotation = self.rotation
	
	
	print('Card Added to slot')

## Resets card slot variables, doesn't change card position
func remove_card_from_slot():
	if not card_in_slot:
		return
	
	card_in_slot = false
	occupied_card = null
	print('Card removed from slot')

# Bad practice (moved to card)
#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area.is_in_group('cards'):
		#if card_in_slot == false:
			#add_card_to_slot(area)
		#elif card_in_slot:
			#return
		#pass # Replace with function body.
