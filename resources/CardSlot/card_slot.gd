extends Sprite2D
class_name CardSlot

## Based on the tutorial by Barry's dev hell : https://www.youtube.com/watch?v=1mM73u1tvpU 

## Collision mask & layer set to 2

@export var card_in_slot : bool = false ## State of whether there is a card inside or not

@export var slot_type : SlotType = SlotType.Trick_Slot

var occupied_card : CardInstance = null

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

func add_card_to_slot(card: CardInstance): ## Places card inside of slot
	card_in_slot = true
	occupied_card = card
	card.set_interactive(false) ## Added to stop card from being able to be taken out after dropping it for the first time
	card.scale = Vector2(1.15, 1.15)
	card.global_position = self.global_position
	#card.rotation = self.rotation
	card.global_rotation = self.global_rotation
	
	GameSfxBus.play(GameSfxBus.card_dropped)
	print('Card Added to slot')

## Resets card slot variables, doesn't change card position
func remove_card_from_slot() -> void:
	if not card_in_slot:
		return
	
	occupied_card.set_interactive(false)
	occupied_card.flip_card(false)
	#occupied_card.animate_card_to_position(winner_pile_position)
	
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
