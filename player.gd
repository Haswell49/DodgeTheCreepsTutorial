extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var min_player_bounds
var max_player_bounds

func _ready():
	hide()
	var collisionShape = $CollisionShape2D.get_shape()
	var screen_size = get_viewport_rect().size
	min_player_bounds = Vector2(collisionShape.radius, collisionShape.height / 2)
	max_player_bounds = Vector2(screen_size.x - collisionShape.radius, screen_size.y - (collisionShape.height / 2))

func _process(delta):
	var input_vector = get_movement_input_vector()
	
	var velocity = input_vector.normalized() * speed
	
	position = calulate_new_position(velocity, delta)
	
	animate(velocity)

func _on_body_entered(body: Node2D) -> void:	
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func calulate_new_position(velocity: Vector2, delta: float):
	var newPosition = position + (velocity * delta);
	return newPosition.clamp(min_player_bounds, max_player_bounds);

func get_movement_input_vector():
	var input_vector: Vector2 = Vector2.ZERO
	if (Input.is_action_pressed("move_right")):
		input_vector.x += 1
		
	if (Input.is_action_pressed("move_left")):
		input_vector.x -= 1
		
	if (Input.is_action_pressed("move_up")):
		input_vector.y -= 1
		
	if (Input.is_action_pressed("move_down")):
		input_vector.y += 1
	
	return input_vector.normalized()

func animate(velocity: Vector2):
	if (velocity.length() == 0.0):
		$AnimatedSprite2D.stop()
		return;

	if velocity.x != 0:
		$AnimatedSprite2D.animation = 'walk'
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = 'up'
		$AnimatedSprite2D.flip_v = velocity.y > 0
