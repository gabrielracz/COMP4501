class_name Crate extends RigidBody3D

var original_transform
var touched_boxes = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 5
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	original_transform = global_transform

func _on_body_entered(body: Node3D):
	pass
	#print(body.get_class())
	#if body is RigidBody3D:
		#freeze = true
		#body.freeze = true
		
func _on_body_exited(body: Node3D):
	pass
	#if body is RigidBody3D:
		#touched_boxes -= 1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if freeze:
		#var node = get_node("MeshInstance3D")
		#node.mesh.surface_get_material(0).material.albedo_color = Color(1.0, 0.0, 1.0)a
	pass

func _physics_process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	
	#Set up the ray query parameters
	if(linear_velocity.length() > 0.001):
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = global_position
		ray_query.to = global_position + linear_velocity.normalized() * 0.55
		ray_query.collision_mask = collision_mask
		# Perform the raycast
		var result = space_state.intersect_ray(ray_query)
		if result:
			if result["collider"].is_class("RigidBody3D"):
				result["collider"].freeze = true
				linear_velocity = Vector3.ZERO
				#print("frozen")
				return
	#else:
		#return
	
	#if freeze: print("unfreeze")
	#freeze = false
	global_transform = Transform3D(
		original_transform.basis,  # Keep the original rotation
		global_transform.origin    # Allow position to change
	)
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3(linear_velocity.x, 0, linear_velocity.z)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	return
	for contact in state.get_contact_count():
		var other_body = state.get_contact_collider_object(contact)
		if other_body is RigidBody3D:
			# Suppress velocity to simulate static behavior
			state.linear_velocity = Vector3.ZERO
			state.angular_velocity = Vector3.ZERO
			#freeze = true
			return  # Exit after processing one contact to avoid unnecessary checks
