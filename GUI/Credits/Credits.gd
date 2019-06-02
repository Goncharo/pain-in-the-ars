extends MarginContainer

export var time_to_display = 5

var sceneManager : SceneManager

# Called when the node enters the scene tree for the first time.
func _ready():
	sceneManager = get_node("/root/SceneManager")
	yield(get_tree().create_timer(time_to_display), "timeout")
	sceneManager.goto_scene("res://Main.tscn")