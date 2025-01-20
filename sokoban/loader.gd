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

@export var crate_mesh: Mesh
@export var wall_mesh: Mesh
@export var player_mesh: Mesh

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


var levels: Array[Node] = []
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
	result.height = row
	levelFile.close()
	return result


func _load_levels():
	var levelDir = DirAccess.open(levelDirname)
	var levelEntries = levelDir.get_files()
	for filename in levelEntries:
		if filename.begins_with("l-") and filename.ends_with(".txt"):
		# if filename == "l-tutorial.txt":
			var level = _read_level_file(levelDirname + filename)
			if not level.tiles.is_empty():
				levelPlans.append(level)
	levelPlans.reverse()

func _init_meshes():
	tile_map = {
		"W": wall_mesh,
		# "o": SphereMesh.new(),
		"o": ResourceLoader.load("res://meshes/grate.obj"),
		"S": CapsuleMesh.new(),
		"X": crate_mesh,
	}

	# var crateMesh = ResourceLoader.load("res://meshes/prop_floor_crate.obj")
	# var crateInstance = MeshInstance3D.new()
	# crateInstance.mesh = 
	# tile_map["X"] = crateInstance

func _build_levels():
	for levelPlan in levelPlans:
		var root_node = Node3D.new();
		root_node.visible = false
		add_child(root_node)
		for tileDesc in levelPlan.tiles:
			if not tile_map.has(tileDesc[TILE_TYPE]):
				continue

			var tile = MeshInstance3D.new()
			tile.mesh = tile_map[tileDesc[TILE_TYPE]]
			tile.global_transform.origin = Vector3(
				float(tileDesc[TILE_COL]) - levelPlan.width/2.0,
				0,
				float(tileDesc[TILE_ROW]) - levelPlan.height/2.0
			)
			root_node.add_child(tile)
		var floorTile = MeshInstance3D.new()
		var floorPlane = PlaneMesh.new()
		floorPlane.size = Vector2(levelPlan.width, levelPlan.height)
		floorPlane.center_offset = Vector3(-0.5, -0.5, -0.5)
		floorTile.mesh = floorPlane
		root_node.add_child(floorTile)
		levels.append(root_node)

func _change_active_level(newActiveLevel):
	if(newActiveLevel >= len(levels)):
		return
	levels[levelIndex].visible = false
	levels[newActiveLevel].visible = true
	levelIndex = newActiveLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_levels()
	_init_meshes()
	_build_levels()
	_change_active_level(0)
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is not InputEventKey or not event.is_pressed():
		return

	if not number_key_map.has(event.keycode):
		return
	
	_change_active_level(number_key_map[event.keycode])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
