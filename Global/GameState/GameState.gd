extends Node

class_name GameState

signal update_player_message
signal update_player_health
signal update_player_skrilla
signal update_player_score
signal update_player_ability
signal update_ars_health
signal power_of_x_used
signal game_over

var playerHealth = 0
var playerSkrilla = 0
var arsHealth = 0
var playerScore = 0
var playerPosition = Vector2()

var playerMaxHealth = 100

# power of X upgrade values
export var power_of_x_charge_upgrade = 1
var power_of_x_max_charge = 0
var power_of_x_cur_charge = 0
var power_of_x_in_progress = false

export var arsMaxHealth = 100
export var arsHealthUpgrade = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func upgradeAbility(name: String, cost: int) -> void:
	updatePlayerSkrilla(-cost)
	if(name == "ARS Health"):
		arsMaxHealth += arsHealthUpgrade
		reset_stats()
		return
	elif(name == "Power of X"):
		power_of_x_max_charge += 1
		power_of_x_cur_charge = power_of_x_max_charge
	else:
		emit_signal("update_player_ability", name)

func reset_stats() -> void:
	power_of_x_cur_charge = power_of_x_max_charge
	setPlayerHealth(playerMaxHealth)
	setARSHealth(arsMaxHealth)
	
func power_of_x() -> void:
	if power_of_x_in_progress || power_of_x_cur_charge == 0:
		return
	power_of_x_cur_charge -= 1
	if power_of_x_cur_charge >= 0 :
		power_of_x_in_progress = true
		emit_signal("power_of_x_used")

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
		emit_signal("game_over", playerScore)
	
func setPlayerSkrilla(curSkrilla : int) -> void:
	playerSkrilla = max(curSkrilla, 0)
	emit_signal("update_player_skrilla", playerSkrilla)
	
func setARSHealth(curHealth : int) -> void:
	arsHealth = max(curHealth, 0)
	emit_signal("update_ars_health", arsHealth)
	if(arsHealth == 0):
		emit_signal("game_over", playerScore)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
