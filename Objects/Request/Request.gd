extends RigidBody2D

class_name Request

var gameState : GameState

enum request_types {TLE, GET_PASSES, RES_REQ}

export var TLE_SPEED = 50
export var TLE_HEALTH = 20
export var TLE_DAMAGE = 20
export var TLE_REWARD = 7

export var GET_PASSES_SPEED = 75
export var GET_PASSES_HEALTH = 10
export var GET_PASSES_DAMAGE = 10
export var GET_PASSES_REWARD = 2

export var RES_REQ_SPEED = 25
export var RES_REQ_HEALTH = 50
export var RES_REQ_DAMAGE = 60
export var RES_REQ_REWARD = 15

var speed = 0
var health = 0
var damage = 0
var reward = 0
var request_type = null
var killed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisibilityNotifier2D.connect("screen_exited", self, "_onScreenExited")
	$Hitbox.connect("body_entered", self, "_onBodyEntered")
	gameState = get_node("/root/GameState")

func spawn(target: Vector2, initial_position: Vector2, speed_multiplier: float) -> void:
	initialize_request()
	speed *= speed_multiplier
	position = initial_position
	setLinearVelocity(target)
	
func setLinearVelocity(target: Vector2) -> void:
	rotation = (target - position).angle()
	linear_velocity = Vector2(speed, 0)
	linear_velocity = linear_velocity.rotated((target - position).angle())

func initialize_request():
	var num = randi() % 3 + 1
	# initialize as TLE
	if num == 1:
		speed = TLE_SPEED
		health = TLE_HEALTH
		damage = TLE_DAMAGE
		reward = TLE_REWARD
		request_type = request_types.TLE
		$Label.text = "TLE"
	# initialize as GET_PASSES
	elif num == 2:
		speed = GET_PASSES_SPEED
		health = GET_PASSES_HEALTH
		damage = GET_PASSES_DAMAGE
		reward = GET_PASSES_REWARD
		request_type = request_types.GET_PASSES
		$Label.text = "GET\nPASSES"
	# initialize as RES_REQ
	elif num == 3:
		speed = RES_REQ_SPEED
		health = RES_REQ_HEALTH
		damage = RES_REQ_DAMAGE
		reward = RES_REQ_REWARD
		request_type = request_types.RES_REQ
		$Label.text = "RES\nREQ"
	
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
	$Glow.visible = false
	$ColorRect.visible = false
	$Label.visible = false
	killed = true
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Hitbox/CollisionShape2D.call_deferred("set_disabled", true)
	linear_velocity = Vector2(0, 0)
	$Explosion.emitting = true
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
	
# _physics_process -----------------------------------------------------------------
# Description:
#	Called during the physics processing step of the main loop. Physics processing 
#   means that the frame rate is synced to the physics, i.e. the delta variable 
#   should be constant.
#
# Inputs:
#	delta	- the elapsed time since the previous frame
#-----------------------------------------------------------------------------------
func _physics_process(delta) -> void:
	# if this is a TLE, follow the player location
	if request_type == request_types.TLE and !killed:
		setLinearVelocity(gameState.playerPosition)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
