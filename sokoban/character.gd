extends CharacterBody3D

@export var speed: float
@export var push_force: float

func largest_absolute_element_vector(vec: Vector3) -> Vector3:
	var abs_vec = Vector3(abs(vec.x), abs(vec.y), abs(vec.z))
	var max_value = max(abs_vec.x, abs_vec.y, abs_vec.z)

	if abs_vec.x == max_value:
		return Vector3(vec.x, 0, 0)
	elif abs_vec.y == max_value:
		return Vector3(0, vec.y, 0)
	else:
		return Vector3(0, 0, vec.z)

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
	#move_and_slide()
	var collision: KinematicCollision3D = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_class("RigidBody3D"):
			var rigidbody = collision.get_collider() as RigidBody3D
			# Calculate the direction from player to rigidbody
			var push_direction = (rigidbody.get_global_transform().origin - global_transform.origin).normalized()
			#push_direction = largest_absolute_element_vector(push_direction)
			push_direction = largest_absolute_element_vector(-collision.get_normal())
			var impulse = push_direction * push_force
			# Apply the impulse
			rigidbody.linear_velocity += impulse
			
		print(Time.get_ticks_msec(), " collision ", collision.get_collider().get_name(), " " + name)
