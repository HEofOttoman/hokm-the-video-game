extends Resource
class_name CardData

## The elements of a card which define it
@export_range(1,13) var value : int = 1 ## IMPORTANRT - Remember that in Hokm 2 is valued at 1 and 13 is the Ace!
@export_enum("Hearts", "Spades", "Diamonds", "Clubs") var suit : String = "Hearts"
@export var cardtexture : Texture 
