extends StaticBody2D

@onready var hitbox: CollisionShape2D = $Spikes/hitbox
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var death = 1
var ready_1 = false

func _ready():
	var trap = get_node("../trap_1")
	trap.trapped_1.connect(_on_trap_activated)

func _on_trap_activated():
	ready_1 = true
	print("spike ready")
	await get_tree().create_timer(1).timeout
	animation_player_2.play("default")
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") :
		animation_player.play("spiked")
		print("body_spiked_1")
	if body.has_method("die"):
		body.die()
		
		
