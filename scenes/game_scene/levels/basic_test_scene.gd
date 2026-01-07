extends Node2D

## Old Root script idfk what I was doing

signal hakem_declared 
signal hokm_chosen(hokm)

@export_enum("Player 1 (You)", "Player 2") var Hakem : String ## Sets the leader of the game
@export_enum("Hearts", "Spades", "Diamonds", "Clubs") var hokm : String ## Sets the hokm of the game

func _ready() -> void:
	randomize()
	$Deck.shuffle_deck() ## Shuffles the deck of course

func start_game():
	declaring_hakem()
	
	
	if hokm_chosen:
		print("Choose a Hokm")
	

func declaring_hakem():
	$Deck.draw_card()
	hakem_declared.emit()

func declaring_hokm(): ## Process for declaring the hokm
	## Add the process for declaring it here
	hokm_chosen.emit(hokm)


func _on_clubs_pressed() -> void:
	hokm = "Clubs"
	hokm_chosen.emit(hokm)
func _on_hearts_pressed() -> void:
	hokm = "Diamonds"
	hokm_chosen.emit(hokm)
func _on_spades_pressed() -> void:
	hokm = "Spades"
	hokm_chosen.emit(hokm)
func _on_diamonds_pressed() -> void:
	hokm = "Diamonds"
	hokm_chosen.emit(hokm)
