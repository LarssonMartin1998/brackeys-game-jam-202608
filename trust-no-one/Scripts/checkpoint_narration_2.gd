extends Area2D

@onready var god_rays: Sprite2D = $"../CanvasLayer/god_rays"

var checkpoints_narrate = 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and checkpoints_narrate == 0:
			checkpoints_narrate += 1
			god_rays.visible = true
			Narrator.play_line(Narrator.LineType.CHECKPOINT_2)
			await get_tree().create_timer(4.0).timeout
			god_rays.visible = false
