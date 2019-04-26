extends Node2D

export (PackedScene) var Request

var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.connect("timeout", self, "_onSpawnTimerTimeout")
	
func start(spawn_frequency : float, target : Vector2):
	self.target = target
	$SpawnTimer.start(spawn_frequency)

func _onSpawnTimerTimeout():
	
	# choose a random location on the RequestPath
	$RequestPath/SpawnLocation.set_offset(randi())
	
	# spawn the request at the random location
	var request = Request.instance()
	add_child(request)
	request.spawn(target, $RequestPath/SpawnLocation.position)
	

