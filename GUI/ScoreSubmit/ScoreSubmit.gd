extends Control

var gameState : GameState
var sceneManager : SceneManager

var apiURL: String = "http://localhost:8666/highscore/"
var waiting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	gameState = get_node("/root/GameState")
	sceneManager = get_node("/root/SceneManager")
	$HTTPRequest.connect("request_completed", self, "_on_HTTPRequest_request_completed")
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
	
	
func startWaitUpdate() -> void:
	while waiting:
		yield(get_tree().create_timer(0.5), "timeout")
		if !waiting: return
		$VBoxContainer/MarginContainer/Status.text += " 0"

func _onSubmitPressed() -> void:
	# submit score to server
	$VBoxContainer/MarginContainer/SubmitButton.hide()
	$VBoxContainer/MarginContainer/Status.text = "Submitting"
	$VBoxContainer/MarginContainer/Status.show()
	var score = $VBoxContainer/HBoxContainer2/ScoreNum.text
	var playerName = $VBoxContainer/HBoxContainer3/NameTextBox.text
	$HTTPRequest.request(apiURL + playerName + "/" + score, ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, "")
	waiting = true
	startWaitUpdate()

	
func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	waiting = false
	if result == $HTTPRequest.RESULT_SUCCESS and response_code == 200:
		$VBoxContainer/MarginContainer/Status.text = "Submission successful"
	else:
		$VBoxContainer/MarginContainer/Status.text = "Failed to submit"
	yield(get_tree().create_timer(2), "timeout")
	sceneManager.goto_scene("res://GUI/Credits/Credits.tscn")

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
