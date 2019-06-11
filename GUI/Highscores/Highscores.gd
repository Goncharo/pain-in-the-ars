extends MarginContainer

export (PackedScene) var HighscoreItem
export var num_to_query = 10

var sceneManager : SceneManager

var apiURL: String = "http://localhost:8666/highscore?num=" + str(num_to_query)

var waiting = true

# Called when the node enters the scene tree for the first time.
func _ready():
	sceneManager = get_node("/root/SceneManager")
	$HTTPRequest.connect("request_completed", self, "_on_HTTPRequest_request_completed")
	$VBoxContainer/Button/MarginContainer/MainMenuButton.connect("pressed", self, "_onMainMenuButtonPressed")
	$VBoxContainer/Text/HighscoresText.text= "Loading"
	$VBoxContainer/Text.show()
	startWaitUpdate()
	$HTTPRequest.request(apiURL)
	
func startWaitUpdate() -> void:
	while waiting:
		yield(get_tree().create_timer(0.5), "timeout")
		if !waiting: return
		$VBoxContainer/Text/HighscoresText.text += " 0"

func _onMainMenuButtonPressed() -> void:
	sceneManager.goto_scene("res://Main.tscn")
	
func addScoreItem(number: String, playerName: String, score: String) -> void:
	var highscoreItem = HighscoreItem.instance() as HighscoreItem
	highscoreItem.setFields(number, playerName, score)
	$VBoxContainer/Highscores.add_child(highscoreItem)

func populateHighScores(body) -> void:
	var highscores = JSON.parse(body.get_string_from_utf8()).result
	var cur_num = 1
	for highscore in highscores:
		addScoreItem(str(cur_num), highscore.name, str(highscore.score))
		cur_num += 1
	var remainingRange = num_to_query - cur_num + 1
	for remainingIndex in range(num_to_query - cur_num + 1):
		addScoreItem(str(cur_num), "NOT SET", str(0))
		cur_num += 1
	
func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	waiting = false
	if result == $HTTPRequest.RESULT_SUCCESS and response_code == 200:
		$VBoxContainer/Text/HighscoresText.text = "Highscores"
		populateHighScores(body)
	else:
		$VBoxContainer/Text/HighscoresText.text  = "Failed to load"
	$VBoxContainer/Button.show()
	
