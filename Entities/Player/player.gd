extends CharacterBody2D


const SPEED : float = 300.0
const GRAVITY : Vector2 = Vector2.DOWN * 1000
const JUMP_VELOCITY : float = -500.0
const RISING_GRAVITY_MODIFIER : float = 0.75
const FALL_GRAVITY : Vector2 = Vector2.DOWN * 2000

var has_bamboo : bool = true

var facing_right : bool = true
var running : bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0: # To make things snappier, we make gravity different if you're rising or falling.
			velocity += get_jump_gravity() * delta
		else:
			velocity += get_jump_gravity() * delta * RISING_GRAVITY_MODIFIER

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY/4
	
	if Input.is_action_pressed("throw") and has_bamboo:
		throwBamboo()
		has_bamboo = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if direction > 0:
			facing_right = true
		elif direction < 0:
			facing_right = false
		running = true
		velocity.x = direction * SPEED
	else:
		running = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if facing_right:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.offset.x = 21.51
	else:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.offset.x = -23.78
		
	if is_on_floor():
		if running:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")

	move_and_slide()

func get_jump_gravity() -> Vector2:
	if velocity.y < 0:
		return GRAVITY
	return FALL_GRAVITY
	

func throwBamboo():
	pass
