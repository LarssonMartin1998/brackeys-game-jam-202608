extends StaticBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("body_entered")
		animation_player.play("default")
		
	
	
