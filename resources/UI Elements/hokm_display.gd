extends Panel


@export var hokm_texture_current : Texture
@export var hokm_texture_display : TextureRect


@export var hearts_suit : Texture
@export var spades_suit : Texture
@export var clubs_suit : Texture
@export var diamonds_suit : Texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hokm_texture_current = null
	hokm_texture_display.texture = hokm_texture_current
	



func _on_hokm_chosen(hokm: Variant) -> void:
	match hokm: ## Sets the hokm texture
		hokm.Clubs:
			hokm_texture_current = clubs_suit
			hokm_texture_display.texture = hokm_texture_current
			print("Displaying Hokm: Clubs")
		hokm.Diamonds:
			hokm_texture_current = diamonds_suit
			hokm_texture_display.texture = hokm_texture_current
			print("Displaying Hokm: Diamonds")
		hokm.Hearts:
			hokm_texture_current = hearts_suit
			hokm_texture_display.texture = hokm_texture_current
			print("Displaying Hokm: Hearts")
		hokm.Spades:
			hokm_texture_current = spades_suit
			hokm_texture_display.texture = hokm_texture_current
			print("Displaying Hokm: Spades")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
