extends Area2D
@onready var god_rays: Sprite2D = $"../CanvasLayer/god_rays"
@onready var narrator_scene: AudioStreamPlayer = $"../NarratorScene"

var checkpoint_node
var uncheckpoint_node
var checkpoints = 1
signal narration

func _ready() -> void:
	checkpoint_node = get_node("checkpoint")
	uncheckpoint_node = get_node("uncheckpoint")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body_entered.disconnect(_on_body_entered)
		uncheckpoint_node.visible = false
		checkpoint_node.visible = true
		CheckpointManager.visit_checkpoint(global_position)
		if checkpoints == 1:
			god_rays.visible = true
			Narrator.play_line(Narrator.LineType.CHECKPOINT_1)
			await get_tree().create_timer(4.0).timeout
			god_rays.visible = false
			narration.emit()
			checkpoints == 2

			
	
	
