extends Node2D

class_name RequestSpawner

export (PackedScene) var request

var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.connect("timeout", self, "_onSpawnTimerTimeout")
	
func start(spawn_frequency : float, target : Vector2) -> void:
	self.target = target
	$SpawnTimer.start(spawn_frequency)

func _onSpawnTimerTimeout() -> void:
	
	# choose a random location on the RequestPath
	$RequestPath/SpawnLocation.set_offset(randi())
	
	# spawn the request at the random location
	var request_instance = request.instance()
	add_child(request_instance)
	request_instance.spawn(target, $RequestPath/SpawnLocation.position)
	

