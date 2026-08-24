extends CharacterBody2D

const SPEED = 300.0
const ACCEL = 75.0
const FRICTION = 32.5
const JUMP_VELOCITY = -400.0
const SKEW_MAX = 0.125

func _physics_process(delta: float) -> void:
	# Add the gravity.
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
	
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	move_and_slide()
