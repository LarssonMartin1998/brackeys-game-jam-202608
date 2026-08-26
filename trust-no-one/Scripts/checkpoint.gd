extends Area2D

var checkpoint_node
var uncheckpoint_node

func _ready() -> void:
	checkpoint_node = get_node("checkpoint")
	uncheckpoint_node = get_node("uncheckpoint")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if not body.is_in_group("player"):
		return

	body_entered.disconnect(_on_body_entered)
	uncheckpoint_node.visible = false
	checkpoint_node.visible = true
	CheckpointManager.visit_checkpoint(global_position)
