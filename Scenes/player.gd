extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 192
const JUMP_VELOCITY = -256


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle horizontal movement and animations
	var direction := Input.get_axis("Left", "Right")
	if direction != 0:
		velocity.x = direction * SPEED
		
		# Flip sprite based on direction
		sprite.flip_h = (direction < 0)
		
		# Play walk animation if not already playing
		if sprite.animation != "walk":
			sprite.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# Play idle animation when stopped
		if sprite.animation != "idle":
			sprite.play("idle")

	move_and_slide()
