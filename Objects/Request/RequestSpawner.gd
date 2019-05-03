extends Node2D

class_name RequestSpawner

export (PackedScene) var request

signal wave_complete

var target = Vector2()
var num_to_spawn = 0
var request_speed_multiplier = 1.0
var waveComplete = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.connect("timeout", self, "_onSpawnTimerTimeout")
	
func start(spawn_frequency: float, target: Vector2, num_to_spawn: int, request_speed_multiplier: float) -> void:
	waveComplete = false
	self.target = target
	self.num_to_spawn = num_to_spawn
	self.request_speed_multiplier = request_speed_multiplier
	$SpawnTimer.start(spawn_frequency)

func stop() -> void:
	$SpawnTimer.stop()

func _onSpawnTimerTimeout() -> void:
	
	# if there's nothing left to spawn, stop the timer
	# and wait until all requests have been killed,
	# then emit the signal specifying the wave is complete
	if(num_to_spawn == 0):
		stop()
		waveComplete = true
	
	num_to_spawn -= 1
	
	# choose a random location on the RequestPath
	$RequestPath/SpawnLocation.set_offset(randi())
	
	# spawn the request at the random location
	var request_instance = request.instance() as Request
	add_child(request_instance)
	request_instance.spawn(target, $RequestPath/SpawnLocation.position, request_speed_multiplier)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(waveComplete and !get_tree().has_group("requests")):
		waveComplete = false
		emit_signal("wave_complete")

