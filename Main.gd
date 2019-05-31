extends Node2D

var sceneManager: SceneManager
var gameState: GameState
const LEVELS: Array = ["Survival"]
var currentLevel: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sceneManager = get_node("/root/SceneManager")
	gameState = get_node("/root/GameState")
	$GUI/MainMenu/VBoxContainer/Buttons/MarginContainer/StartButton.connect("pressed", self, "startGame")
	
func startGame() -> void:
	$GUI/MainMenu.hide()
	sceneManager.goto_scene(_getLevelPath(LEVELS[currentLevel]))
	
func nextLevel() -> void:
	if ++currentLevel == LEVELS.size():
		pass
	else:
		sceneManager.goto_scene(_getLevelPath(LEVELS[currentLevel]))

func _getLevelPath(levelName: String) -> String:
	return "res://Levels/" + levelName + "/" + levelName + ".tscn"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
