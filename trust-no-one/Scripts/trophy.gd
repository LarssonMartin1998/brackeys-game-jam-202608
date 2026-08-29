extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("win")
	if body.has_method("win"):
		body.win()
	
