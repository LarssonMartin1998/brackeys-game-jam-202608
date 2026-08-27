extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal trapped_1
	
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("body_trapped_1")
		animation_player.play("default")
		trapped_1.emit()

	
	
