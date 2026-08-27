extends StaticBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal trapped_2

func _ready() -> void:
	var trap = get_node("../spike_1")
	trap.spiked.connect(_on_sandwiched)

func _on_sandwiched() -> void:
		animation_player.play("default")

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("body_trapped_3")
		trapped_2.emit()
