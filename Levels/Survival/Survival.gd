extends Node2D

class_name Survival

var gameState: GameState

export var initial_spawn_speed: float = 1.5
export var min_spawn_speed: float = 0.1
export var additional_speed: float = -0.05

export var initial_request_speed_mult: float = 1.0
export var max_request_speed_mult: float = 4.0
export var additional_request_speed: float = 0.25

export var initial_num_requests: int = 20
export var num_additional_requests: int = 10

export var wave_wait_time: int = 10

var cur_spawn_speed: float = 0
var cur_num_requests: float = 0
var cur_request_speed_mult: float = 0
var cur_wave: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameState = get_node("/root/GameState")
	gameState.updatePlayerMessage("")
	$RequestSpawner.connect("wave_complete", self, "_onWaveComplete")
	$WaveTimer.connect("timeout", self, "_onWaveTimerTimeout")
	$SecondTimer.connect("timeout", self, "_onSecondTimerTimeout")
	$WaveTimer.one_shot = true
	$SecondTimer.one_shot = false
	gameState.reset_health_stats()
	nextWave()

func _onSecondTimerTimeout() -> void:
	gameState.updatePlayerMessage("NEXT WAVE    " + String(int($WaveTimer.time_left)))

func _onWaveTimerTimeout() -> void:
	$SecondTimer.stop()
	gameState.updatePlayerMessage("")
	# disable buy menu access
	nextWave()

func _onWaveComplete() -> void:
	$WaveTimer.start(wave_wait_time)
	$SecondTimer.start(1)
	gameState.reset_health_stats()
	gameState.updatePlayerMessage("NEXT WAVE    " + String(wave_wait_time))
	# enable buy menu access
	
func nextWave() -> void:
	cur_wave += 1
	if(cur_wave == 1):
		cur_num_requests = initial_num_requests
		cur_spawn_speed = initial_spawn_speed
		cur_request_speed_mult = initial_request_speed_mult
	else:
		cur_num_requests += num_additional_requests
		cur_request_speed_mult = min(cur_request_speed_mult + additional_request_speed, max_request_speed_mult)
		cur_spawn_speed = max(cur_spawn_speed + additional_speed, min_spawn_speed)
		
	$RequestSpawner.start(cur_spawn_speed, $ARS.position, cur_num_requests, cur_request_speed_mult)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
