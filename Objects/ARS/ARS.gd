extends Area2D

class_name ARS

var gameState : GameState
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", self, "_onBodyEntered")
	gameState = get_node("/root/GameState")
	gameState.connect("ars_dead", self, "_onARSDead")

func _onARSDead():
	dead = true
	$Sprite.visible = false
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Explosion.emitting = true
	yield(get_tree().create_timer(4), "timeout")
	queue_free()

func _onBodyEntered(body : PhysicsBody2D) -> void:
	if dead:
		return
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
