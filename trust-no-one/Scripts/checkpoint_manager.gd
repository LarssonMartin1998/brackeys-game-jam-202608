extends Node

var latest_checkpoint = null

func visit_checkpoint(checkpoint: Vector2) -> void:
	latest_checkpoint = checkpoint

func get_respawn_point() -> Vector2:
	return latest_checkpoint
