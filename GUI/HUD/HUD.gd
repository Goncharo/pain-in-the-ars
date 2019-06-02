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
	$ARSHealth/ARSHealthBar.max_value = gameState.arsMaxHealth
	$PlayerHealth/PlayerHealthBar.max_value = gameState.playerMaxHealth
	

func _onUpdatePlayerMessage(message: String):
	$PlayerMessage.text = message
	
func _onUpdatePlayerHealth(playerHealth: int):
	if playerHealth == gameState.playerMaxHealth :
		$PlayerHealth/PlayerHealthBar.max_value = gameState.playerMaxHealth
		$ARSHealth/ARSHealthBar.max_value = gameState.arsMaxHealth
	$PlayerHealth/PlayerHealthBar.value = playerHealth
	if playerHealth != gameState.playerMaxHealth:
		flashPlayerText()
	
func _onUpdateARSHealth(arsHealth: int):
	if arsHealth == gameState.arsMaxHealth :
		$ARSHealth/ARSHealthBar.max_value = gameState.arsMaxHealth
	$ARSHealth/ARSHealthBar.value = arsHealth
	if arsHealth != gameState.arsMaxHealth :
		flashARSText()
	
func _onUpdatePlayerSkrilla(playerSkrilla: int):
	$PlayerSkrilla.text = SKRILLA_LABEL + SEPARATOR + String(playerSkrilla)
	flashSkrillaText()
	
func _onUpdatePlayerScore(playerScore: int):
	$PlayerScore.text = SCORE_LABEL + SEPARATOR + String(playerScore)
	flashScoreText()
	
func flashPlayerText() -> void:
	$PlayerHealth/PlayerText/AnimationPlayer.play("FlashRed")
	yield(get_tree().create_timer(1), "timeout")
	$PlayerHealth/PlayerText/AnimationPlayer.stop()

func flashARSText() -> void:
	$ARSHealth/ARSText/AnimationPlayer.play("FlashRed")
	yield(get_tree().create_timer(1), "timeout")
	$ARSHealth/ARSText/AnimationPlayer.stop()
	
func flashScoreText() -> void:
	$PlayerScore/AnimationPlayer.play("FlashGreen")
	yield(get_tree().create_timer(1), "timeout")
	$PlayerScore/AnimationPlayer.stop()
	
func flashSkrillaText() -> void:
	$PlayerSkrilla/AnimationPlayer.play("FlashGreen")
	yield(get_tree().create_timer(1), "timeout")
	$PlayerSkrilla/AnimationPlayer.stop()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ARSHealth/ARSHealthBar.max_value = gameState.arsMaxHealth
	$PlayerHealth/PlayerHealthBar.max_value = gameState.playerMaxHealth
