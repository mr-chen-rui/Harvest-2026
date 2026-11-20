extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const RISING_GRAVITY_MODIFIER = 0.75

var has_bamboo : bool = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0: # To make things snappier, we make gravity different if you're rising or falling.
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * delta * RISING_GRAVITY_MODIFIER

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("throw") and has_bamboo:
		throwBamboo()
		has_bamboo = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func throwBamboo():
	pass
