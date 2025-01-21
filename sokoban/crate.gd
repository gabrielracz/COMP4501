class_name Crate extends RigidBody3D

var original_transform

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_transform = global_transform
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	global_transform = Transform3D(
	original_transform.basis,  # Keep the original rotation
	global_transform.origin    # Allow position to change
	)
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3(linear_velocity.x, 0, linear_velocity.z)
