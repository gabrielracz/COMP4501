extends CanvasLayer

var numLevels: int

# Called when the node enters the scene tree for the first time.
func on_level_completed(levelNum: int):
	if(levelNum < numLevels):
		$LevelCompleteText.text = "Level " + str(levelNum) + " Complete!\nPress \"" + str(levelNum + 1) + "\" to continue"
	else:
		$LevelCompleteText.text = "Final Level Complete!"
	$LevelCompleteText.show()
	$MessageTimer.start()
	await $MessageTimer.timeout
	$LevelCompleteText.hide()

func _ready() -> void:
	#$LevelStatusText.show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
