extends Label

@export var hokm_texture_current : Texture
@export var hokm_texture_display : TextureRect


@export var hearts_suit : Texture = preload("uid://cchmw36cn2iub")
@export var spades_suit : Texture = preload("uid://kbvpimiey1to")
@export var clubs_suit : Texture = preload("uid://mdddrsbhdtq2")
@export var diamonds_suit : Texture = preload("uid://nphn56k8tao0")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hokm_texture_current = null
	hokm_texture_display.texture = hokm_texture_current

func _on_hokm_chosen(hokm: CardData.Suit) -> void:
	match hokm: ## Sets the hokm texture
		CardData.Suit.CLUBS:
			hokm_texture_current = clubs_suit
			hokm_texture_display.texture = hokm_texture_current
			print("Displaying Hokm: Clubs")
		CardData.Suit.DIAMONDS:
			hokm_texture_current = diamonds_suit
			hokm_texture_display.texture = hokm_texture_current
			print("Displaying Hokm: Diamonds")
		CardData.Suit.HEARTS:
			hokm_texture_current = hearts_suit
			hokm_texture_display.texture = hokm_texture_current
			print("Displaying Hokm: Hearts")
		CardData.Suit.SPADES:
			hokm_texture_current = spades_suit
			hokm_texture_display.texture = hokm_texture_current
			print("Displaying Hokm: Spades")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
