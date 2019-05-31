extends Node2D

class_name Survival

var gameState: GameState
var sceneManager: SceneManager

export var initial_spawn_speed: float = 1.5
export var min_spawn_speed: float = 0.2
export var additional_speed: float = -0.1

export var initial_request_speed_mult: float = 1.0
export var max_request_speed_mult: float = 3.0
export var additional_request_speed: float = 0.15

export var initial_num_requests: int = 20
export var num_additional_requests: int = 5

export var wave_wait_time: int = 10

var cur_spawn_speed: float = 0
var cur_num_requests: float = 0
var cur_request_speed_mult: float = 0
var cur_wave: int = 0
var shop_enabled: bool = false
var shop_open: bool = false
var game_over: bool = false
var ars_dead: bool = false
var player_dead: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameState = get_node("/root/GameState")
	sceneManager = get_node("/root/SceneManager")
	gameState.updatePlayerMessage("")
	gameState.connect("player_dead", self, "_onPlayerDead")
	gameState.connect("ars_dead", self, "_onARSDead")
	gameState.connect("player_dead_and_gone", self, "_onPlayerDeadAndGone")
	$RequestSpawner.connect("wave_complete", self, "_onWaveComplete")
	$WaveTimer.connect("timeout", self, "_onWaveTimerTimeout")
	$SecondTimer.connect("timeout", self, "_onSecondTimerTimeout")
	$WaveTimer.one_shot = true
	$SecondTimer.one_shot = false
	$GUI/Shop.hide()
	$GUI/HUD.show()
	$GUI/ScoreSubmit.hide()
	gameState.reset_stats()
	nextWave()
	
func _onPlayerDead() -> void:
	game_over = true
	player_dead = true
	
func _onPlayerDeadAndGone() -> void:
	# spawn a bunch of requests to kill ARS if it's not dead already
	if !ars_dead:
		gameState.playerPosition = $ARS.position
		$RequestSpawner.stop()
		$RequestSpawner.start(0.001, $ARS.position, 20, 4)
	
func _onARSDead() -> void:
	game_over = true
	ars_dead = true
	$RequestSpawner.stop()
	yield(get_tree().create_timer(.25), "timeout")
	if !player_dead:
		gameState.updatePlayerHealth(-gameState.playerMaxHealth)
	for request in get_tree().get_root().get_tree().get_nodes_in_group("requests"):
			yield(get_tree().create_timer(.025), "timeout")
			var wr = weakref(request)
			if wr.get_ref():
				wr.get_ref().kill()
	yield(get_tree().create_timer(4), "timeout")
	game_over()

func _onSecondTimerTimeout() -> void:
	if game_over:
		return
	gameState.updatePlayerMessage("NEXT WAVE    " + String(int($WaveTimer.time_left)))

func _onWaveTimerTimeout() -> void:
	if game_over:
		return
	$SecondTimer.stop()
	gameState.updatePlayerMessage("")
	nextWave()

func _onWaveComplete() -> void:
	if game_over:
		return
	$WaveTimer.start(wave_wait_time)
	$SecondTimer.start(1)
	gameState.reset_stats()
	gameState.wave_in_progress = false
	# enable buy menu access
	shop_enabled = true
	gameState.updatePlayerMessage("NEXT WAVE    " + String(wave_wait_time))
	
func nextWave() -> void:
	if game_over:
		return
	# disable buy menu access & hide shop GUI
	shop_enabled = false
	gameState.wave_in_progress = true
	$GUI/Shop.hide()
	$GUI/HUD.show()
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

func toggleShop() -> void:
	if shop_open:
		$GUI/Shop.hide()
		$GUI/HUD.show()
	else:
		$GUI/HUD.hide()
		$GUI/Shop.show()
	shop_open = !shop_open
	
func game_over() -> void:
	sceneManager.goto_scene("res://GUI/ScoreSubmit/ScoreSubmit.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_over:
		return
	if Input.is_action_just_pressed("open_shop") and shop_enabled:
		toggleShop()
	if Input.is_action_just_pressed("debug_mode"):
		$WaveTimer.stop()
		$SecondTimer.stop()
		shop_enabled = true
		gameState.updatePlayerSkrilla(100000)
		gameState.updatePlayerMessage("")
