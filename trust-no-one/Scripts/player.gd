extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@onready var die_sfx: AudioStreamPlayer2D = $die_sfx
@onready var revive: AudioStreamPlayer2D = $revive
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var god_rays: Sprite2D = $"../CanvasLayer/god_rays"
@onready var main_menu: Node2D = $"../CanvasLayer/main menu"


const SPEED = 300.0
const ACCEL = 75.0
const FRICTION = 32.5
const JUMP_VELOCITY = -400.0
const SKEW_MAX = 0.125
const RESPAWN_TIME = 1.0
var checkpoint_position = null
var alive = true
var paused = false
var narration = false

func _ready():
	CheckpointManager.visit_checkpoint(global_position) # treat players spawn pos as the first checkpoint
	await get_tree().create_timer(0.1).timeout
	intro()

func intro():
	narration = true
	god_rays.visible = true
	Narrator.play_line(Narrator.LineType.TUTORIAL)
	await get_tree().create_timer(6.0).timeout
	god_rays.visible = false
	narration = false

func process_death_state(delta: float):
	animated_sprite_2d.rotation += 5 * delta
	velocity = Vector2.ZERO

func process_falling(delta: float):
	velocity += get_gravity() * delta

func apply_movement_velocity(delta: float):
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		
	var dir := Input.get_axis("move_left", "move_right")
	if (dir):
		velocity.x = move_toward(velocity.x, SPEED * dir, ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)

func get_velocity_based_skew() -> float:
	if velocity.x == 0:
		return 0
		
	var abs_vel_x = abs(velocity.x)
	var normalized_vel_x = abs_vel_x / SKEW_MAX
	var skew_dir = velocity.x / abs_vel_x
	skew = lerp(0.0, SKEW_MAX * skew_dir, normalized_vel_x)
	return clamp(velocity.x, -SPEED, SPEED) / SPEED * SKEW_MAX

func _physics_process(delta: float) -> void:
	apply_movement_velocity(delta)
	if not is_on_floor():
		process_falling(delta)
	if not alive:
		process_death_state(delta)
	
	transform = Transform2D(
		transform.get_rotation(),
		transform.get_scale(),
		get_velocity_based_skew(),
		transform.get_origin()
	)
	if not narration:
		move_and_slide()
	else:
		return
	
	#menuing
	if Input.is_action_just_pressed("menu"):
			get_tree().paused = true
			main_menu.visible = true

func _on_kill_floor_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"): #check if the node is the player, I manually added player = player group 
		return
	print("player_die")
	die_sfx.play()
	animated_sprite_2d.play("die")
	die()
	god_rays.visible = true
	Narrator.play_line(Narrator.LineType.DEATH_KILL_FLOOR)
	await get_tree().create_timer(2.0).timeout
	god_rays.visible = false

func die():
	alive = false
	animated_sprite_2d.play("die")
	die_sfx.play()
	respawn()

func respawn():
	
	await get_tree().create_timer(RESPAWN_TIME).timeout
	alive = true
	animated_sprite_2d.play("respawn")
	player.global_position = CheckpointManager.get_respawn_point()
	revive.play()
	animated_sprite_2d.rotation = 0.0
	await get_tree().create_timer(3.0).timeout
	animated_sprite_2d.play("default")
