class_name SceneManager extends Node

const levelDirname = "res://levels/"

enum {
	TILE_TYPE = 0,
	TILE_ROW = 1,
	TILE_COL = 2
}

class LevelPlan:
	var width: int 			= 0
	var height: int 		= 0
	var tiles: Array[Array] = [];

@export var level_manager_scene: PackedScene
@export var character_scene: PackedScene
@export var wall_scene: PackedScene
@export var crate_scene: PackedScene
@export var grate_scene: PackedScene
@export var tree_scene: PackedScene
#@export var text_scene: PackedScene

var tile_map: Dictionary = {}

const number_key_map = {
	Key.KEY_1: 0,
	Key.KEY_2: 1,
	Key.KEY_3: 2,
	Key.KEY_4: 3,
	Key.KEY_5: 4,
	Key.KEY_6: 5,
	Key.KEY_7: 6,
	Key.KEY_8: 7,
	Key.KEY_9: 8
}

var levels: Array[LevelManager]
var levelPlans: Array[LevelPlan] = []
var levelIndex: int = 0
var levelDimensions: Array = []

func _read_level_file(filename: String) -> LevelPlan:
	var result = LevelPlan.new()
	if not FileAccess.file_exists(filename):
		print("Level file", filename, "does not exist.")
		return result
	
	var levelFile = FileAccess.open(filename, FileAccess.READ)
	if not levelFile:
		print("Failed to open level file:", filename)
		return result

	var row = 0
	while not levelFile.eof_reached():
		var col = 0
		var line = levelFile.get_line()
		result.width = max(result.width, line.length())
		for tile in line:
			result.tiles.append([tile, row, col])
			col += 1
		row += 1
	result.height = row - 1
	levelFile.close()
	return result


func _load_levels():
	var levelDir = DirAccess.open(levelDirname)
	var levelEntries = levelDir.get_files()
	for filename in levelEntries:
		if filename.begins_with("l-") and filename.ends_with(".txt"):
			var level = _read_level_file(levelDirname + filename)
			if not level.tiles.is_empty():
				levelPlans.append(level)
	levelPlans.reverse()

func _build_level(levelNum: int):
	var levelPlan = levelPlans[levelNum]
	var levelRootNode = level_manager_scene.instantiate()
	levelRootNode.levelNum = levelNum + 1
	levelRootNode.visible = false
	levelRootNode.connect("level_completed", $HUD.on_level_completed)
	add_child(levelRootNode)
	for tileDesc in levelPlan.tiles:
		var tile
		var colVal = 2**levelNum
		match tileDesc[TILE_TYPE]:
			"S":
				tile = character_scene.instantiate()
				tile.name = "player " + str(levelNum)
				tile.collision_layer = colVal
				tile.collision_mask = colVal
			"W":
				tile = wall_scene.instantiate()
				tile.collision_layer = colVal
				tile.collision_mask = colVal
			"X":
				tile = crate_scene.instantiate()
				tile.collision_layer = colVal
				tile.collision_mask = colVal
			"o":
				tile = grate_scene.instantiate()
				tile.collision_layer = colVal
				tile.collision_mask = colVal
			"+":
				tile = tree_scene.instantiate()
			_:
				continue

		tile.visible = true
		tile.global_translate(Vector3(
			float(tileDesc[TILE_COL]) - levelPlan.width/2.0,
			0,
			float(tileDesc[TILE_ROW]) - levelPlan.height/2.0
		))
		levelRootNode.add_child(tile)

		
		
	# Create floor
	var floorTile = MeshInstance3D.new()
	var floorPlane = PlaneMesh.new()
	floorPlane.size = Vector2(levelPlan.width, levelPlan.height)
	floorPlane.center_offset = Vector3(-0.5, -0.5, -0.5)
	floorTile.mesh = floorPlane
	levelRootNode.add_child(floorTile)
	levelRootNode.registerTiles()
			
	#var text: RichTextLabel = text_scene.instantiate() as RichTextLabel
	#text.add_text("Level Complete")
	#text.set_position(Vector2(0, 0))
	#levelRootNode.add_child(text)
	
	#if levelNum < len(levels):
		#levels[levelNum] = levelRootNode
	#else:
	levels.append(levelRootNode)

func _build_levels():
	for levelNum in range(len(levelPlans)):
		_build_level(levelNum)
	$HUD.numLevels = len(levelPlans)
		
func set_root_activity(root_node: Node, active: bool) -> void:
	root_node.set_process(active)
	root_node.set_physics_process(active)
	root_node.set_process_input(active)  # Enable/disable input processing

	# Optionally toggle visibility
	#if root_node is CanvasItem:
	root_node.visible = active

	# Recursively apply to all children
	for child in root_node.get_children():
		set_root_activity(child, active)

func _change_active_level(newActiveLevel):
	if newActiveLevel >= len(levels):
		return
	
	for i in range(len(levels)):
		set_root_activity(levels[i], false)
	
	set_root_activity(levels[newActiveLevel], true)
	levelIndex = newActiveLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_levels()
	_build_levels()
	_change_active_level(0)
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is not InputEventKey or not event.is_pressed():
		return
		
	if event.keycode == KEY_R:
		_build_levels()
		
		

	if not number_key_map.has(event.keycode):
		return
	
	_change_active_level(number_key_map[event.keycode])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
