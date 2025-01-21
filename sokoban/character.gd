extends CharacterBody3D

@export var speed: float
@export var push_force: float



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
			
			# Calculate push direction only on the horizontal plane (lateral motion)
			var push_direction = collision.get_normal() * -1.0  # Invert normal to get the direction of impact
			push_direction.y = 0  # Remove any vertical component
			push_direction = push_direction.normalized()  # Normalize to keep consistent force

			# Apply lateral force by directly modifying the linear velocity		 
			var lateral_velocity = push_direction * push_force
			rigidbody.linear_velocity += lateral_velocity
			
		print(Time.get_ticks_msec(), " collision ", collision.get_collider().get_name(), " " + name)
