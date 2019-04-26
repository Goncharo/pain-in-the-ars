extends KinematicBody2D

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
# player's health
# export var health = 100

var START_POS : Vector2		# stores the player's original spawn position

var velocity = Vector2()	# stores the player's current velocity
var jumping = false			# whether or not the player is jumping
var falling = true			# whether or not the player is falling
var dashing = false			# whether or not the played is (or has) dashed while falling	
var screen_size				# stores the game's window size
var started_jumping = false

# _ready ---------------------------------------------------------------------------
# Description:
#	Called when the node enters the scene tree for the first time.
#-----------------------------------------------------------------------------------
func _ready():
	START_POS = position
	screen_size = get_viewport_rect().size
	$VisibilityNotifier2D.connect("screen_exited", self, "respawn")

# respawn --------------------------------------------------------------------------
# Description:
#	Will respawn the player at the their original spawn position, and reset their
#   velocity vector.
#-----------------------------------------------------------------------------------	
func respawn():
	velocity = Vector2()
	position = START_POS

# getInput -------------------------------------------------------------------------
# Description:
#	Gets keyboard input, and adjusts player's velocity accordingly
#-----------------------------------------------------------------------------------	
func getInput():
	
	velocity.x = 0
	
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
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
func _physics_process(delta):
	
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

# _process -------------------------------------------------------------------------
# Description:
#	Called during the processing step of the main loop. Processing happens at every 
#   frame and as fast as possible, so the delta time since the previous frame is 
#   not constant.
#
# Inputs:
#	delta	- the elapsed time since the previous frame
#-----------------------------------------------------------------------------------
func _process(delta):
	pass
