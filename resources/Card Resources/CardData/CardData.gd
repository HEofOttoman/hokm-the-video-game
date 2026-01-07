extends Resource
class_name CardData

## The elements of a card which define it

#@export_range(1,13) var rank : int = 1 ## IMPORTANRT - Remember that in Hokm 2 is valued at 1 and 13 is the Ace!
##^Nvm I renamed the var to rank from value and broke everything so might as well make it better
enum Rank { 
	TWO = 2, 
	THREE = 3, 
	FOUR = 4, 
	FIVE = 5, 
	SIX = 6, 
	SEVEN = 7, 
	EIGHT = 8, 
	NINE = 9, 
	TEN = 10, 
	JACK = 11, 
	QUEEN = 12, 
	KING = 13, 
	ACE = 14
	}

@export var rank : Rank = Rank.TWO
@export_enum("Hearts", "Spades", "Diamonds", "Clubs") var suit : String = "Hearts"
@export var cardtexture : Texture 
@export var backtexture : Texture = preload("res://assets/Sprites/Cards/kenney_playing-cards-pack/PNG/Cards (large)/card_back.png")
