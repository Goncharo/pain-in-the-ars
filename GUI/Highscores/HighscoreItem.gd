extends MarginContainer

class_name HighscoreItem

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setFields(number: String, playerName: String, score: String) -> void:
	$NumberText.text = number
	$NameText.text = playerName
	$ScoreText.text = score
