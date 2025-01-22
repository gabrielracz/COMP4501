class_name Grate extends Area3D

func _on_body_entered(body: Node3D):
	if body is Crate:
		print("entered")
	pass
	
func _on_body_exited(body: Node3D):
	if body is Crate:
		print("exited")
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
