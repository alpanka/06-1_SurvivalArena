class_name RandomAudioPlayerComponentBasic
extends AudioStreamPlayer

@export var audio_array: Array[AudioStream]

@export var randomize_pitch: bool = true
@export var min_pitch: float = 0.9
@export var max_pitch: float = 1.1


func play_random_audio(key: int = 100) -> void:
	if audio_array == null or audio_array.size() == 0:
		return
	
	if randomize_pitch:
		pitch_scale = randf_range(min_pitch, max_pitch)
	else:
		pitch_scale = 1.0
	
	if key == 100:
		self.stream = audio_array.pick_random()
	else:
		self.stream = audio_array[key]
	
	self.play()
