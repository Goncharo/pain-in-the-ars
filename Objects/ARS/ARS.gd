extends Area2D

class_name ARS

var gameState : GameState
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", self, "_onBodyEntered")
	gameState = get_node("/root/GameState")
	gameState.connect("ars_dead", self, "_onARSDead")
	$AnimatedSprite.play("Boot")

func playBootAnim() -> void:
	$AnimatedSprite.animation = "Boot"
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("Boot")
	
func playHitAnim() -> void:
	$AnimatedSprite.animation = "Hit"
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("Hit")

func _onARSDead():
	dead = true
	$AnimatedSprite.visible = false
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Explosion.emitting = true
	yield(get_tree().create_timer(5), "timeout")
	queue_free()
	
func disableCollisions():
	$CollisionShape2D.call_deferred("set_disabled", true)
	
func enableCollisions():
	$CollisionShape2D.call_deferred("set_disabled", false)

func _onBodyEntered(body : PhysicsBody2D) -> void:
	if dead:
		return
	var bullet := body as Bullet
	if bullet:
		bullet.kill()
		
	var request := body as Request
	if not request:
		return
	playHitAnim()
	gameState.updateARSHealth(-request.damage)
	request.kill()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
