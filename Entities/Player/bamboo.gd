extends Node2D

var stuck_in_wall : bool = false
var returning : bool = false
var velocity : Vector2 = Vector2(0,0)

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if velocity.x < 0:
		$cant_pierce.target_position = -$cant_pierce.target_position
		$can_pierce.target_position = -$can_pierce.target_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stuck_in_wall and Input.is_action_just_pressed("throw"):
		stuck_in_wall = false
		returning = true
		$Bamboo.play("spin")
	elif $can_pierce.is_colliding() and not stuck_in_wall and not returning:
		$Bamboo.play("stuck")
		stuck_in_wall = true
		returning = false
	
	if not stuck_in_wall and not returning:
		$Bamboo.play("spin")
		position += velocity * delta
	
	if returning:
		position += -(position - player.position).normalized() * 500 * delta
		if (position - player.position).length() < 10:
			queue_free()
			player.has_bamboo = true
	
	if stuck_in_wall:
		if len($Area2D.get_overlapping_areas()) > 0:
			for body in $Area2D.get_overlapping_areas():
				if body.get_parent() is Player:
					if player.velocity.y > player.JUMP_VELOCITY:
						player.velocity.y = player.JUMP_VELOCITY
						player.play_jump_anim()
