class_name LevelManager extends Node3D

var levelNum = -1
var grates: Array[Grate]
var completed: bool = false

signal level_completed

func registerTiles():
	for child in get_children():
		if child is Grate:
			grates.append(child)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var activeGrates: Dictionary = {}
	for g in grates:
		if g.overlappedCrate != -1:
			activeGrates[g.overlappedCrate] = null
	
	if activeGrates.size() == len(grates):
		if not completed:
			completed = true
			emit_signal("level_completed", levelNum)
	else:
		completed = false
	pass
