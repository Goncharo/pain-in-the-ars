extends Control

var gameState: GameState

const SEPARATOR = "    "
const PLAYER_HEALTH_LABEL = "HEALTH"
const ARS_HEALTH_LABEL = "ARS HEALTH"
const SKRILLA_LABEL = "SKRILLA"
const SCORE_LABEL = "SCORE"

# Called when the node enters the scene tree for the first time.
func _ready():
	gameState = get_node("/root/GameState")
	gameState.connect("update_player_message", self, "_onUpdatePlayerMessage")
	gameState.connect("update_player_health", self, "_onUpdatePlayerHealth")
	gameState.connect("update_player_skrilla", self, "_onUpdatePlayerSkrilla")
	gameState.connect("update_ars_health", self, "_onUpdateARSHealth")
	gameState.connect("update_player_score", self, "_onUpdatePlayerScore")
	

func _onUpdatePlayerMessage(message: String):
	$PlayerMessage.text = message
	
func _onUpdatePlayerHealth(playerHealth: int):
	$PlayerHealth.text = PLAYER_HEALTH_LABEL + SEPARATOR + String(playerHealth)
	
func _onUpdateARSHealth(arsHealth: int):
	$ARSHealth.text = ARS_HEALTH_LABEL + SEPARATOR + String(arsHealth)
	
func _onUpdatePlayerSkrilla(playerSkrilla: int):
	$PlayerSkrilla.text = SKRILLA_LABEL + SEPARATOR + String(playerSkrilla)
	
func _onUpdatePlayerScore(playerScore: int):
	$PlayerScore.text = SCORE_LABEL + SEPARATOR + String(playerScore)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
