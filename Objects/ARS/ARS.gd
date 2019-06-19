extends Area2D

class_name ARS

signal boot_complete

var gameState : GameState
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", self, "_onBodyEntered")
	gameState = get_node("/root/GameState")
	gameState.connect("ars_dead", self, "_onARSDead")
	$Sounds/Boot.connect("finished", self, "_onBootComplete")
	
	
func setBootAnim() -> void:
	$AnimatedSprite.animation = "Boot"
	$AnimatedSprite.frame = 0

func boot() -> void:
	$AnimatedSprite.animation = "Boot"
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("Boot")
	$Sounds/Boot.play()
	
func playHitAnim() -> void:
	$AnimatedSprite.animation = "Hit"
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("Hit")
	
func _onBootComplete() -> void:
	emit_signal("boot_complete")

func _onARSDead():
	dead = true
	$AnimatedSprite.visible = false
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Sounds/ARSDead.play()
	$Explosion.emitting = true
	yield(get_tree().create_timer(4), "timeout")
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
		$Sounds/BulletImpact.play()
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
