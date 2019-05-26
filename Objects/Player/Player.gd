extends KinematicBody2D

class_name Player

export (PackedScene) var Bullet

var gameState : GameState

# the world gravity
export var gravity = 1600
# the speed at which the player will jump when jump is first pressed
export var initial_jump_speed = -250
# the speed to add to jump velocity while jump is held
export var additional_jump_speed = -50
# the player's maximum jump speed, if this limit is reached the player can no longer jump
export var max_jump_speed = -425
# the speed at which the player will dash while he is falling, not jumping, and has not 
# dashed yet
export var dash_speed = -550
# player movement speed along the x axis
export var speed = 200
export var fall_damage = 10

# player health
export var initial_health = 100
var cur_health_level = 0

# speed upgrade
export var speed_upgrade = 150
var cur_speed_level = 0

# jump upgrade values
export var initial_jump_speed_upgrade = -75
export var additional_jump_speed_upgrade = -10
export var max_jump_speed_upgrade = -75
export var dash_speed_upgrade = -150
var cur_jump_level = 0

var cur_shoot_level = 0

# health upgrade values
export var health_upgrade = 25


var START_POS : Vector2		# stores the player's original spawn position

var velocity = Vector2()	# stores the player's current velocity
var jumping = false			# whether or not the player is jumping
var falling = true			# whether or not the player is falling
var dashing = false			# whether or not the played is (or has) dashed while falling	
var screen_size				# stores the game's window size
var started_jumping = false
var facing_right = true
var dead = false

# _ready ---------------------------------------------------------------------------
# Description:
#	Called when the node enters the scene tree for the first time.
#-----------------------------------------------------------------------------------
func _ready() -> void:
	START_POS = position
	screen_size = get_viewport_rect().size
	$VisibilityNotifier2D.connect("screen_exited", self, "respawn")
	$Hitbox.connect("body_entered", self, "_onBodyEntered")
	gameState = get_node("/root/GameState")
	gameState.connect("update_player_ability", self, "_onUpgradePlayerAbility")
	gameState.connect("player_dead", self, "_onPlayerDead")
	gameState.playerMaxHealth = initial_health

# respawn --------------------------------------------------------------------------
# Description:
#	Will respawn the player at the their original spawn position, reset their
#   velocity vector, and make them take fall damage.
#-----------------------------------------------------------------------------------	
func respawn() -> void:
	gameState.updatePlayerHealth(-fall_damage)
	if gameState.playerHealth > 0:
		velocity = Vector2()
		position = START_POS
	else:
		$CollisionShape2D.call_deferred("set_disabled", true)
		$Hitbox/CollisionShape2D.call_deferred("set_disabled", true)
		queue_free()
		gameState.emit_signal("player_dead_and_gone")

# getInput -------------------------------------------------------------------------
# Description:
#	Gets keyboard input, and adjusts player's velocity accordingly
#-----------------------------------------------------------------------------------	
func getInput() -> void:
		
	velocity.x = 0
	
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	update_orientation(left, right)
	var jump = Input.is_action_pressed("ui_select") || Input.is_action_just_pressed("ui_select")

	# jump if player is on the floor
	if jump and is_on_floor():
		jumping = true
		velocity.y = initial_jump_speed
	# if player holds the jump key, add additional velocity until the max is reached
	elif jump and jumping and velocity.y > max_jump_speed:
		velocity.y 	+= additional_jump_speed
	else: 
		jumping = false
	
	# allow player to dash up once, if they haven't already in the current jump	
	if Input.is_action_just_pressed("ui_select") and !jumping and !dashing and falling:
		dashing = true
		velocity.y = dash_speed
		
	if left:
		velocity.x -= speed
	if right:
		velocity.x += speed
		
func _onPlayerDead() -> void:
	dead = true
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Hitbox/CollisionShape2D.call_deferred("set_disabled", true)
	
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
	if dead:
		velocity.x = 0
		velocity.y = 700
	else:		
		if jumping and is_on_floor():
			jumping = false
	
		if dashing and is_on_floor():
			dashing = false
			
		if !falling and is_on_floor():
			velocity.y = 0
		
		getInput()
		
		if !is_on_floor():
			falling = true
			velocity.y += delta * gravity
		else:
			falling = false
			
	move_and_slide(velocity, Vector2(0,-1))
	
	# restrict player movement left/right
	position.x = clamp(position.x, 0, screen_size.x)
	# restrict player movement up, but allow them to fall through the bottom of 
	# the screen
	position.y = max(0, position.y)
	
	gameState.playerPosition = position
	
func _onBodyEntered(body : PhysicsBody2D) -> void:
	var request := body as Request
	if not request:
		return
	hit(request.damage)
	request.kill()
		
func hit(damage : int) -> void:
	gameState.updatePlayerHealth(-damage)
		
func update_orientation(left: bool, right: bool) -> void:
	if (left and right) or right:
		facing_right = true
	elif left:
		facing_right = false

func shoot(target: Vector2) -> void:
	# spawn the the bullet at the player location
	var bullet = Bullet.instance() as Bullet
	get_parent().add_child(bullet)
	bullet.spawn(target, position, cur_shoot_level)
	if cur_shoot_level > 1:
		var bullet2 = Bullet.instance() as Bullet
		get_parent().add_child(bullet2)
		var target2 = target
		target2.x += 20
		target2.y += 20
		bullet2.spawn(target2, position, cur_shoot_level)
	if cur_shoot_level > 2:
		var bullet3 = Bullet.instance() as Bullet
		get_parent().add_child(bullet3)
		var target3 = target
		target3.x -= 20
		target3.y -= 20
		bullet3.spawn(target3, position, cur_shoot_level)
	
func _onUpgradePlayerAbility(abilityName: String) -> void:
	if abilityName == "Shooting":
		cur_shoot_level += 1
	elif abilityName == "Player Health":
		gameState.playerMaxHealth += health_upgrade
		gameState.reset_stats()
		cur_health_level += 1
	elif abilityName == "Speed":
		speed += speed_upgrade
		cur_speed_level += 1
	elif abilityName == "Jump":
		initial_jump_speed += initial_jump_speed_upgrade
		additional_jump_speed += additional_jump_speed_upgrade
		max_jump_speed += max_jump_speed_upgrade
		dash_speed += dash_speed_upgrade
		cur_jump_level += 1
		
func _input(event):
	if dead:
		return
	if event is InputEventScreenTouch and event.pressed:
		shoot(event.position)
	
# _process -------------------------------------------------------------------------
# Description:
#	Called during the processing step of the main loop. Processing happens at every 
#   frame and as fast as possible, so the delta time since the previous frame is 
#   not constant.
#
# Inputs:
#	delta	- the elapsed time since the previous frame
#-----------------------------------------------------------------------------------
func _process(delta) -> void:
	if dead:
		return
	if Input.is_action_just_pressed("power_of_x"):
		gameState.power_of_x()