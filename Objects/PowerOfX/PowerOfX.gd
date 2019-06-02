extends Node2D

var gameState : GameState

export var howard_damage = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible = false # TODO: REMOVE
	gameState = get_node("/root/GameState")
	gameState.connect("power_of_x_used", self, "_onPowerOfXUsed")
	
func _onPowerOfXUsed(tutorialMode: bool) -> void:
	var num = 0
	if tutorialMode:
		# if we're in tutorial mode, use Dan
		num = 2
	else:
		# 10% chance that Howard appears
		num = randi() % 10 + 1
	
	if num == 1:
		# Howard appears on sceen, causes damage to player and ARS
		$Label.visible = true # TODO: REMOVE 
		$Label.text = "HOWARD" # TODO: REMOVE 
		yield(get_tree().create_timer(1), "timeout")
		$Label.visible = false # TODO: REMOVE 
		gameState.updateARSHealth(-howard_damage)
		gameState.updatePlayerHealth(-howard_damage)
	else:
		# Dan appears on screen, destroys all requests currently on screen
		$Label.visible = true # TODO: REMOVE 
		$Label.text = "DAN" # TODO: REMOVE 
		yield(get_tree().create_timer(1), "timeout")
		for request in get_tree().get_root().get_tree().get_nodes_in_group("requests"):
			request.kill()
		$Label.visible = false # TODO: REMOVE
		
	gameState.power_of_x_in_progress = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
