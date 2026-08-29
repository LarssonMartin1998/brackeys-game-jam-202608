extends Label

func _ready() -> void:
	text = ""
	visible = false
	Narrator.line_started.connect(_on_line_started)
	Narrator.line_finished.connect(_on_line_finished)

func _on_line_started(subtitle: String) -> void:
	text = subtitle
	visible = subtitle != ""

func _on_line_finished() -> void:
	text = ""
	visible = false
