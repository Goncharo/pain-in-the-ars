extends Node2D

var sceneManager: SceneManager
var gameState: GameState
var currentLevel: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sceneManager = get_node("/root/SceneManager")
	gameState = get_node("/root/GameState")
	$GUI/MainMenu/VBoxContainer/Buttons/MarginContainer/StartButton.connect("pressed", self, "startGame")
	$GUI/MainMenu/VBoxContainer/Buttons/MarginContainer2/ScoresButton.connect("pressed", self, "openHighscores")
	$GUI/MainMenu/VBoxContainer/Buttons/MarginContainer3/TutorialButton.connect("pressed", self, "startTutorial")
	
func startGame() -> void:
	$ButtonSound.play()
	yield(get_tree().create_timer(0.5), "timeout")
	sceneManager.goto_scene(_getLevelPath("Survival"))
	
func startTutorial() -> void:
	$ButtonSound.play()
	yield(get_tree().create_timer(0.5), "timeout")
	sceneManager.goto_scene(_getLevelPath("Tutorial"))
	
func openHighscores() -> void:
	$ButtonSound.play()
	yield(get_tree().create_timer(0.5), "timeout")
	sceneManager.goto_scene("res://GUI/Highscores/Highscores.tscn")

func _getLevelPath(levelName: String) -> String:
	return "res://Levels/" + levelName + "/" + levelName + ".tscn"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
