extends Node

class_name GameState

signal update_player_message
signal update_player_health
signal update_player_skrilla
signal update_player_score
signal update_player_ability
signal update_ars_health
signal game_over

var playerHealth = 0
var playerSkrilla = 0
var arsHealth = 0
var playerScore = 0
var playerPosition = Vector2()

var playerMaxHealth = 100
export var arsMaxHealth = 100
export var arsHealthUpgrade = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func upgradeAbility(name: String, cost: int) -> void:
	updatePlayerSkrilla(-cost)
	if(name == "ARS Health"):
		arsMaxHealth += arsHealthUpgrade
		reset_health_stats()
		return
	emit_signal("update_player_ability", name)

func reset_health_stats() -> void:
	setPlayerHealth(playerMaxHealth)
	setARSHealth(arsMaxHealth)

func updatePlayerMessage(message: String) -> void:
	emit_signal("update_player_message", message)

func updatePlayerHealth(health: int) -> void:
	setPlayerHealth(playerHealth + health)
	
func updatePlayerSkrilla(skrilla: int) -> void:
	if(skrilla > 0):
		playerScore += skrilla
		emit_signal("update_player_score", playerScore)
	setPlayerSkrilla(playerSkrilla + skrilla)
	
func updateARSHealth(health: int) -> void:
	setARSHealth(arsHealth + health)
	
func setPlayerHealth(curHealth : int) -> void:
	playerHealth = max(curHealth, 0)
	emit_signal("update_player_health", playerHealth)
	if(playerHealth == 0):
		emit_signal("game_over")
	
func setPlayerSkrilla(curSkrilla : int) -> void:
	playerSkrilla = max(curSkrilla, 0)
	emit_signal("update_player_skrilla", playerSkrilla)
	
func setARSHealth(curHealth : int) -> void:
	arsHealth = max(curHealth, 0)
	emit_signal("update_ars_health", arsHealth)
	if(arsHealth == 0):
		emit_signal("game_over")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
