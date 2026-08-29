extends AudioStreamPlayer

@export var death_lines_kill_floor: Array[AudioStream]
@export var death_lines_spikes: Array[AudioStream]
@export var checkpoint_lines: Array[AudioStream]
@export var generic_trigger_lines: Array[AudioStream]


class AudioStreamContainer:
	var all_audio_streams: Array[AudioStream]
	var available_audio_streams: Array[AudioStream]
	func _init(audio_streams: Array[AudioStream]):
		all_audio_streams = audio_streams.duplicate()
		_reset()

	func _reset():
		available_audio_streams = all_audio_streams.duplicate()
		available_audio_streams.shuffle()
	
	func get_audio_stream() -> AudioStream:
		if available_audio_streams.is_empty():
			_reset()
		if available_audio_streams.is_empty():
			return null
		var audio_stream = available_audio_streams[0]
		available_audio_streams.remove_at(0)
		return audio_stream

enum LineType { 
	DEATH_SPIKE,
	DEATH_KILL_FLOOR,
	NEW_CHECKPOINT,
	GENERIC_TRIGGER_VOLUME,
}
var line_overrides: Dictionary[LineType, AudioStream]
var generic_lines: Dictionary[LineType, AudioStreamContainer]

func _ready() -> void:
	var audio_pairings := {
		LineType.DEATH_SPIKE:death_lines_spikes,
		LineType.DEATH_KILL_FLOOR:death_lines_kill_floor,
		LineType.NEW_CHECKPOINT:checkpoint_lines,
		LineType.GENERIC_TRIGGER_VOLUME:generic_trigger_lines,
	}
	for line_type in audio_pairings:
		var streams = audio_pairings[line_type]
		generic_lines[line_type] = AudioStreamContainer.new(streams)
		streams.clear()

func _get_audio_stream_for_line_type(line_type: LineType) -> AudioStream:
	if line_overrides.has(line_type):
		var override = line_overrides[line_type]
		line_overrides.erase(line_type)
		return override
	if not generic_lines.has(line_type):
		return null
	return generic_lines[line_type].get_audio_stream()

func play_line(line_type: LineType):
	var audio_stream = _get_audio_stream_for_line_type(line_type)
	if audio_stream == null:
		print("found null audio stream in play_line")
		return	
	set_stream(audio_stream)
	play()

func add_override(line_type: LineType, audio_stream: AudioStream):
	line_overrides[line_type] = audio_stream
