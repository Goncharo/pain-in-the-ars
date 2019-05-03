extends RigidBody2D

class_name Request

var gameState : GameState

export var speed = 75
export var health = 100
export var damage = 10
export var reward = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisibilityNotifier2D.connect("screen_exited", self, "_onScreenExited")
	$Hitbox.connect("body_entered", self, "_onBodyEntered")
	gameState = get_node("/root/GameState")

func spawn(target: Vector2, initial_position: Vector2, speed_multiplier: float) -> void:
	speed *= speed_multiplier
	position = initial_position
	rotation = (target - position).angle()
	linear_velocity = Vector2(speed, 0)
	linear_velocity = linear_velocity.rotated((target - position).angle())
	
func _onBodyEntered(body : PhysicsBody2D) -> void:
	var bullet := body as Bullet
	if not bullet:
		return
	hit(bullet.damage)
	bullet.kill()

func hit(damage: int) -> void:
	health = max(health - damage, 0)
	if health == 0:
		kill(true)
	else:
		pass

func _onScreenExited() -> void:
	queue_free()
	
func kill(bullet: bool = false) -> void:
	if(bullet):
		gameState.updatePlayerSkrilla(reward)
	$CollisionShape2D.call_deferred("set_disabled", true)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
