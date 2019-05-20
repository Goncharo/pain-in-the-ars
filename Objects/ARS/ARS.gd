extends Area2D

class_name ARS

var gameState : GameState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", self, "_onBodyEntered")
	gameState = get_node("/root/GameState")

func _onBodyEntered(body : PhysicsBody2D) -> void:
	var bullet := body as Bullet
	if bullet:
		bullet.kill()
		
	var request := body as Request
	if not request:
		return
	gameState.updateARSHealth(-request.damage)
	request.kill()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
