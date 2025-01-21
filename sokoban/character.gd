extends CharacterBody3D

@export var speed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Character spwaned")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	velocity = Vector3.ZERO

	# Hardcoded key checks
	if Input.is_key_pressed(KEY_W):  # Move forward
		velocity.z -= 1.0
	if Input.is_key_pressed(KEY_S):  # Move backward
		velocity.z += 1.0
	if Input.is_key_pressed(KEY_A):  # Move left
		velocity.x -= 1.0
	if Input.is_key_pressed(KEY_D):  # Move right
		velocity.x += 1.0

	# Normalize direction and scale by speed
	if velocity != Vector3.ZERO:
		velocity = velocity.normalized() * speed

	# Apply the movement
	move_and_slide()
	#var collision: KinematicCollision3D = move_and_collide(velocity)
	#if collision:
		#print("collision")
