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
var shoot_toggle = false

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
	$Sounds/FallOff.play()
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
		$AnimatedSprite.play("Jumping")
		playJumpSound()
	# if player holds the jump key, add additional velocity until the max is reached
	elif jump and jumping and velocity.y > max_jump_speed:
		velocity.y 	+= additional_jump_speed
	else: 
		jumping = false
	
	# allow player to dash up once, if they haven't already in the current jump	
	if Input.is_action_just_pressed("ui_select") and !jumping and !dashing and falling:
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0
		$AnimatedSprite.play("Jumping")
		playDoubleJumpSound()
		dashing = true
		velocity.y = dash_speed
		
	if left:
		velocity.x -= speed
		if is_on_floor() and !(jumping or dashing):
			playFootstepsSound()
			$AnimatedSprite.play("Running")
	if right:
		velocity.x += speed
		if is_on_floor() and !(jumping or dashing):
			playFootstepsSound()
			$AnimatedSprite.play("Running")
			
	if is_on_floor() and !(left or right) and !(jumping or dashing):
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0
		
func _onPlayerDead() -> void:
	dead = true
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Hitbox/CollisionShape2D.call_deferred("set_disabled", true)
	
func playJumpSound() -> void:
	if cur_jump_level == 0:
		$Sounds/Jump/Jump1.play()
	elif cur_jump_level == 1:
		$Sounds/Jump/Jump2.play()
	elif cur_jump_level == 2:
		$Sounds/Jump/Jump3.play()
	elif cur_jump_level == 3:
		$Sounds/Jump/Jump4.play()
	
func playShootSound() -> void:
	if cur_shoot_level == 0:
		$Sounds/Shoot/Shoot1.play()
	elif cur_shoot_level == 1:
		$Sounds/Shoot/Shoot2.play()
	elif cur_shoot_level == 2:
		$Sounds/Shoot/Shoot3.play()
	elif cur_shoot_level == 3:
		$Sounds/Shoot/Shoot4.play()
	
func playDoubleJumpSound() -> void:
	if cur_jump_level == 0:
		$Sounds/DoubleJump/DoubleJump1.play()
	elif cur_jump_level == 1:
		$Sounds/DoubleJump/DoubleJump2.play()
	elif cur_jump_level == 2:
		$Sounds/DoubleJump/DoubleJump3.play()
	elif cur_jump_level == 3:
		$Sounds/DoubleJump/DoubleJump4.play()
	
func playFootstepsSound() -> void:
	if cur_speed_level == 0 and !$Sounds/Footsteps/Footsteps1.playing:
		$Sounds/Footsteps/Footsteps1.play()
	elif cur_speed_level == 1 and !$Sounds/Footsteps/Footsteps2.playing:
		$Sounds/Footsteps/Footsteps2.play()
	elif cur_speed_level == 2 and !$Sounds/Footsteps/Footsteps3.playing: 
		$Sounds/Footsteps/Footsteps3.play()
	elif cur_speed_level == 3 and !$Sounds/Footsteps/Footsteps4.playing:
		$Sounds/Footsteps/Footsteps4.play()
	
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
	$Sounds/Hit.play()
	gameState.updatePlayerHealth(-damage)
		
func update_orientation(left: bool, right: bool) -> void:
	if (left and right) or right:
		facing_right = true
		$AnimatedSprite.flip_h = false
	elif left:
		$AnimatedSprite.flip_h = true
		facing_right = false

func shoot(target: Vector2) -> void:
	# spawn the the bullet at the player eye location
	shoot_toggle = !shoot_toggle
	var spawn_position = position + $Eye1.position
	if shoot_toggle:
		spawn_position = position + $Eye2.position
	var bullet = Bullet.instance() as Bullet
	get_parent().add_child(bullet)
	bullet.spawn(target, spawn_position, cur_shoot_level)
	playShootSound()
	if cur_shoot_level > 1:
		var bullet2 = Bullet.instance() as Bullet
		get_parent().add_child(bullet2)
		var target2 = target
		target2.x += 20
		target2.y += 20
		bullet2.spawn(target2, spawn_position, cur_shoot_level)
	if cur_shoot_level > 2:
		var bullet3 = Bullet.instance() as Bullet
		get_parent().add_child(bullet3)
		var target3 = target
		target3.x -= 20
		target3.y -= 20
		bullet3.spawn(target3, spawn_position, cur_shoot_level)
	
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
	if dead or gameState.shop_open:
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