extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@onready var checkpoint: Node2D = $"../checkpoint"
@onready var die_sfx: AudioStreamPlayer2D = $die_sfx
@onready var revive: AudioStreamPlayer2D = $revive
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const ACCEL = 75.0
const FRICTION = 32.5
const JUMP_VELOCITY = -400.0
const SKEW_MAX = 0.125
const RESPAWN_TIME = 1.0
var checkpoint_position = null
var alive = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if alive==false:
		animated_sprite_2d.rotation += 5 * delta
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	else:
		animated_sprite_2d.rotation = 0.0
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# I added to the standard ui_directions arrow key controls, A,D movement.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		
	var skew = 0
	if velocity.x != 0:
		var abs_vel_x = abs(velocity.x)
		var normalized_vel_x = abs_vel_x / SKEW_MAX
		var skew_dir = velocity.x / abs_vel_x
		skew = lerp(0.0, SKEW_MAX * skew_dir, normalized_vel_x)
		skew = clamp(velocity.x, -SPEED, SPEED) / SPEED * SKEW_MAX
	
	transform = Transform2D(
		transform.get_rotation(),
		transform.get_scale(),
		skew,
		transform.get_origin()
	)
	move_and_slide()
	
	#menuing
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

#Dying when player nodes enter kill floor world boundry colission
func _on_kill_floor_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): #check if the node is the player, I manually added player = player group 
		print("player_die")
		die_sfx.play()
		#needs a dead state (removing controls from player, maybe a spin/flip out)
		animated_sprite_2d.play("die")
		die()

#getting hit function sent by other tscn 
func die():
	alive = false
	animated_sprite_2d.play("die")
	die_sfx.play()
	respawn()


#respawing to the position of the checkpoint, the checkpoint system still needs to be devloped (no script there yet)
func respawn():
	await get_tree().create_timer(RESPAWN_TIME).timeout
	alive = true
	animated_sprite_2d.play("respawn")
	var checkpoint_position = checkpoint.global_position #only one manual checkpoint for now
	player.global_position = checkpoint_position
	revive.play()
	await get_tree().create_timer(3.0).timeout
	animated_sprite_2d.play("default")

	
	
	
	
	
	
	
