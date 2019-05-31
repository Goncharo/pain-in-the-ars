extends Control

var gameState : GameState
var sceneManager : SceneManager

# Called when the node enters the scene tree for the first time.
func _ready():
	gameState = get_node("/root/GameState")
	sceneManager = get_node("/root/SceneManager")
	$VBoxContainer/MarginContainer/SubmitButton.connect("pressed", self, "_onSubmitPressed")
	yield(get_tree().create_timer(0.5), "timeout")
	$VBoxContainer/HBoxContainer/Game.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$VBoxContainer/HBoxContainer/Over.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$VBoxContainer/HBoxContainer2/Score.show()
	var numToIncrement = int(gameState.playerScore * 0.01) + 1
	var curScore = 0
	$VBoxContainer/HBoxContainer2/ScoreNum.text = str(curScore)
	$VBoxContainer/HBoxContainer2/ScoreNum.show()
	for i in range(100):
		yield(get_tree().create_timer(0.01), "timeout")
		curScore += numToIncrement
		var numToSet = min(gameState.playerScore, curScore)
		$VBoxContainer/HBoxContainer2/ScoreNum.text = str(numToSet)
		if numToSet == gameState.playerScore:
			break
	$VBoxContainer/HBoxContainer3.show()
	$VBoxContainer/MarginContainer.show()
	
	
func _onSubmitPressed() -> void:
	# submit score to server
	# goto credits or main?
	sceneManager.goto_scene("res://Main.tscn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	# ensure text input is alphanumeric only
	var regex = RegEx.new()
	regex.compile("[a-zA-Z0-9]*")
	var nameInput = $VBoxContainer/HBoxContainer3/NameTextBox.text
	var filteredName = regex.search(nameInput)
	if filteredName:
		filteredName = filteredName.get_string()
	else:
		filteredName = ""
	$VBoxContainer/HBoxContainer3/NameTextBox.text = filteredName
	$VBoxContainer/HBoxContainer3/NameTextBox.caret_position = len(filteredName)
	if filteredName == "":
		$VBoxContainer/MarginContainer/SubmitButton.disabled = true
	else:
		$VBoxContainer/MarginContainer/SubmitButton.disabled = false
