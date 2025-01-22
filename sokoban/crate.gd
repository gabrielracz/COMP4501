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
	if body is RigidBody3D:
		freeze = true
		body.freeze = true
		
func _on_body_exited(body: Node3D):
	pass
	#if body is RigidBody3D:
		#touched_boxes -= 1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	#if get_contact_count() == 0:
		#freeze = true
		#return
	global_transform = Transform3D(
	original_transform.basis,  # Keep the original rotation
	global_transform.origin    # Allow position to change
	)
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3(linear_velocity.x, 0, linear_velocity.z)
	
	#var collision = move_and_collide(linear_velocity * delta)
