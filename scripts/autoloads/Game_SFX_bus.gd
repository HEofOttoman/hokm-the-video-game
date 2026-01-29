extends Node
class_name SFXBus
## Plays sound effects

@export_group('Sound Effects')
@export var card_flip : AudioStream
@export var trick_won : AudioStream
@export var game_won : AudioStream

func play(audio_stream: AudioStream):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = audio_stream
	player.bus = 'SFX'
	player.play()
	player.finished.connect(player.queue_free)
