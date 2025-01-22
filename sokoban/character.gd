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
		velocity = velocity.slide(collision.get_normal())
		if collision.get_collider().is_class("RigidBody3D"):
			var rigidbody = collision.get_collider() as RigidBody3D
			# Calculate the direction from player to rigidbody
			var push_direction = (rigidbody.get_global_transform().origin - global_transform.origin).normalized()
			var d = push_direction.dot(collision.get_normal())
			#push_direction = largest_absolute_element_vector(push_direction)
			push_direction = largest_absolute_element_vector(-collision.get_normal())
			var impulse = push_direction * push_force
			# Apply the impulse
			#rigidbody.linear_velocity += impulse
			
			#var space_state = get_world_3d().direct_space_state
			#
			## Set up the ray query parameters
			#var ray_query = PhysicsRayQueryParameters3D.new()
			#ray_query.from = collision.get_collider().get_transform().origin
			#ray_query.to = ray_query.from + push_direction.normalized() * 0.54
			#ray_query.collision_mask = rigidbody.collision_mask  # Adjust this to the collision layer you want to test
			#
			## Perform the raycast
			#var result = space_state.intersect_ray(ray_query)
			#if result:
				#if result["collider"].is_class("RigidBody3D"):
					#rigidbody.freeze = true
					#return
			
			rigidbody.freeze = false
			rigidbody.apply_force(impulse * 100)
			
		#print(Time.get_ticks_msec(), " collision ", collision.get_collider().get_name(), " " + name)
