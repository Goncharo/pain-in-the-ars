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
export var max_jump_speed = -550
# the speed at which the player will dash while he is falling, not jumping, and has not 
# dashed yet
export var dash_speed = -700
# player movement speed along the x axis
export var speed = 450

var START_POS : Vector2		# stores the player's original spawn position

var velocity = Vector2()	# stores the player's current velocity
var jumping = false			# whether or not the player is jumping
var falling = true			# whether or not the player is falling
var dashing = false			# whether or not the played is (or has) dashed while falling	
var screen_size				# stores the game's window size
var started_jumping = false
var facing_right = true

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

# respawn --------------------------------------------------------------------------
# Description:
#	Will respawn the player at the their original spawn position, and reset their
#   velocity vector.
#-----------------------------------------------------------------------------------	
func respawn() -> void:
	velocity = Vector2()
	position = START_POS

# getInput -------------------------------------------------------------------------
# Description:
#	Gets keyboard input, and adjusts player's velocity accordingly
#-----------------------------------------------------------------------------------	
func getInput() -> void:
	
	velocity.x = 0
	
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	update_orientation(left, right)
	#var up = Input.is_action_pressed("ui_up")
	#var down = Input.is_action_pressed("ui_down")
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

func shoot() -> void:
	# spawn the the bullet at the player location
	var bullet = Bullet.instance() as Bullet
	get_parent().add_child(bullet)
	var direction = Vector2(1,0) if facing_right else Vector2(-1,0)
	bullet.spawn(direction, position)
	
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
	if Input.is_action_just_pressed("shoot"):
		shoot()