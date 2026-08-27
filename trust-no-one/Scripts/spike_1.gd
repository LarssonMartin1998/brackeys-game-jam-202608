extends StaticBody2D

@onready var hitbox: CollisionShape2D = $Spikes/hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2


var death = 1
var ready_1 = false
var spiked_1 = false
var spiked_2 = false

signal spiked

func _ready():
	var trap = get_node("../trap_1")
	trap.trapped_1.connect(_on_trap_activated)

func _on_trap_activated():
	ready_1 = true
	print("spike ready")
	await get_tree().create_timer(1).timeout
	animation_player_2.play("default")
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not spiked_1:
		spiked_1 = true
		animation_player.play("spiked")
		print("body_spiked_1")
		spiked.emit()
	if body.has_method("die"):
		body.die()

func _on_area_2d_below_body_entered(body: Node2D) -> void:
	if body.is_in_group("player")and not spiked_2:
		spiked_2 = true
		animation_player_2.play("spiked_2")
		print("body_spiked_2")
