extends StaticBody2D

@onready var animation_player_3: AnimationPlayer = $AnimationPlayer3
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animation_player.play("spiked")
		print("body_spiked_1")
	if body.has_method("die"):
		body.die()

		

func _on_area_2d_below_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animation_player.play("flip")
		print("flip_spiked_elevator")
			#Narrator.play_line(Narrator.LineType.checkpoint_3)
