extends Area2D

## Based on this tutorial: https://www.youtube.com/watch?v=e7iuMLdWjgw

signal card_action(left: bool) ## Signal to check if a card is clicked
signal card_release(left: bool) ## Signal to check if a card is released (Idk why the bool is called left, maybe revise?)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("ClickL"):
		card_action.emit(true)
		#print("left click")
	if event.is_action_pressed("ClickR"):
		card_action.emit(false)
		#print("right click")
	
	if event.is_action_released("ClickL"): ## Checks if LMB is no longer held down
		card_release.emit(true)
	if event.is_action_pressed("ClickR"):
		card_release.emit(false)
	
## For some reason putting down a color rect behind disables the area 2d from being able to detect clicking
