extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var narrator_scene: AudioStreamPlayer = $"../NarratorScene"
@onready var god_rays: Sprite2D = $"../CanvasLayer/god_rays"

signal trapped_1
var trapped1
	
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not trapped1:
		trapped1 = true
		print("body_trapped_1")
		animation_player.play("default")
		trapped_1.emit()
		god_rays.visible = true
		Narrator.play_line(Narrator.LineType.TRAP_1)
		await get_tree().create_timer(6.0).timeout
		god_rays.visible = false


	
