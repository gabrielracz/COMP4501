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
		
func _on_body_exited(body: Node3D):
	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if freeze:
		#var node = get_node("MeshInstance3D")
		#node.mesh.surface_get_material(0).material.albedo_color = Color(1.0, 0.0, 1.0)a
	pass

func _physics_process(delta: float) -> void:
	global_transform = Transform3D(
		original_transform.basis,  # Keep the original rotation
		global_transform.origin    # Allow position to change
	)
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3(linear_velocity.x, 0, linear_velocity.z)
	
	# Ensure no crates will be pushed by this one
	var space_state = get_world_3d().direct_space_state
	if(linear_velocity.length() > 0.001):
		var box_shape = BoxShape3D.new()
		box_shape.size = Vector3(0.9, 0.9, 0.9)

		var shape_query = PhysicsShapeQueryParameters3D.new()
		shape_query.shape = box_shape
		shape_query.transform = Transform3D(Basis(), global_position + (linear_velocity.normalized() * 0.05))
		shape_query.collision_mask = collision_mask

		var results = space_state.intersect_shape(shape_query, 10)
		if results.size() > 0:
			for result in results:
				if result.collider is Crate and result.collider.get_instance_id() != get_instance_id():
					result.collider.freeze = true
					linear_velocity = Vector3.ZERO
					return
