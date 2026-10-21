extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 192
const JUMP_VELOCITY = -256
const DASH_SPEED = 400.0
const DASH_DURATION = 0.2 
const DASH_COOLDOWN = 0.5 

var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: float = 0.0

func start_dash() -> void:
	is_dashing = true
	can_dash = false
	
	# Dash in the direction faced, or movement input direction if held
	var input_dir := Input.get_axis("Left", "Right")
	if input_dir != 0:
		dash_direction = input_dir
	else:
		dash_direction = -1.0 if sprite.flip_h else 1.0

	# Timer for dash duration
	get_tree().create_timer(DASH_DURATION).timeout.connect(func():
		is_dashing = false
	)
	
	# Timer for dash cooldown
	get_tree().create_timer(DASH_COOLDOWN).timeout.connect(func():
		can_dash = true
	)

func _physics_process(delta: float) -> void:
	# Add gravity if not dashing and in air
	if not is_on_floor() and not is_dashing:
		velocity += get_gravity() * delta

	# Check for dash input
	if Input.is_action_just_pressed("Dash") and can_dash:
		start_dash()

	# Handle jump (disabled while dashing)
	if Input.is_action_just_pressed("Jump") and is_on_floor() and not is_dashing:
		velocity.y = JUMP_VELOCITY

	# Movement logic
	if is_dashing:
		# Lock horizontal velocity during dash
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0 # Prevents falling mid-dash
	else:
		var direction := Input.get_axis("Left", "Right")
		if direction != 0:
			velocity.x = direction * SPEED
			sprite.flip_h = (direction < 0)
			if sprite.animation != "walk":
				sprite.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if sprite.animation != "idle":
				sprite.play("idle")

	move_and_slide()
	
	
