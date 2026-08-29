extends AudioStreamPlayer

signal line_started(subtitle: String)
signal line_finished()

@export var death_lines_kill_floor: Array[NarratorLine]
@export var death_lines_spikes: Array[NarratorLine]
@export var checkpoint_1: Array[NarratorLine]
@export var checkpoint_2: Array[NarratorLine]
@export var generic_trigger_lines: Array[NarratorLine]
@export var intro: Array[NarratorLine]
@export var trap_1: Array[NarratorLine]
@export var spike_1: Array[NarratorLine]
@export var spike_2: Array[NarratorLine]

class LinePool:
	var all_lines: Array[NarratorLine]
	var available_lines: Array[NarratorLine]
	func _init(lines: Array[NarratorLine]):
		all_lines = lines.duplicate()
		_reset()

	func _reset():
		available_lines = all_lines.duplicate()
		available_lines.shuffle()

	func get_line() -> NarratorLine:
		if available_lines.is_empty():
			_reset()
		if available_lines.is_empty():
			return null
		var line = available_lines[0]
		available_lines.remove_at(0)
		return line

enum LineType {
	DEATH_SPIKE,
	DEATH_KILL_FLOOR,
	CHECKPOINT_1,
	GENERIC_TRIGGER_VOLUME,
	TRAP_1,
	INTRO,
	CHECKPOINT_2,
	SPIKE_1,
	SPIKE_2,
}
var line_overrides: Dictionary[LineType, NarratorLine]
var generic_lines: Dictionary[LineType, LinePool]

var is_line_playing = false

func _ready() -> void:
	finished.connect(_on_finished)
	var line_pairings := {
		LineType.DEATH_SPIKE:death_lines_spikes,
		LineType.DEATH_KILL_FLOOR:death_lines_kill_floor,
		LineType.GENERIC_TRIGGER_VOLUME:generic_trigger_lines,
		LineType.INTRO:intro,
		LineType.CHECKPOINT_1:checkpoint_1,
		LineType.CHECKPOINT_2:checkpoint_1,
		LineType.TRAP_1:trap_1,
		LineType.SPIKE_1:spike_1,
		LineType.SPIKE_2:spike_2,
	}
	for line_type in line_pairings:
		var lines = line_pairings[line_type]
		generic_lines[line_type] = LinePool.new(lines)
		lines.clear()

func _get_line_for_line_type(line_type: LineType) -> NarratorLine:
	if line_overrides.has(line_type):
		var override = line_overrides[line_type]
		line_overrides.erase(line_type)
		return override
	if not generic_lines.has(line_type):
		return null
	return generic_lines[line_type].get_line()

func play_line(line_type: LineType):
	if is_line_playing:
		return
	var line = _get_line_for_line_type(line_type)
	if line == null or line.stream == null:
		print("found null narrator line in play_line")
		return
	stream = line.stream
	play()
	is_line_playing = true
	line_started.emit(line.subtitle)

func _on_finished():
	line_finished.emit()
	is_line_playing = false

func add_override(line_type: LineType, line: NarratorLine):
	line_overrides[line_type] = line
