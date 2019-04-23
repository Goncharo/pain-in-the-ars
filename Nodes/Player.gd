extends KinematicBody2D

export var gravity = 1600
export var initial_jump_speed = -250
export var additional_jump_speed = -50
export var max_jump_speed = -550
export var dash_speed = -700
export var speed = 450


var velocity = Vector2()
var jumping = false
var falling = true
var dashing = false
var START_POS : Vector2
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	START_POS = position
	screen_size = get_viewport_rect().size
	$VisibilityNotifier2D.connect("screen_exited", self, "respawn")
	
func respawn():
	velocity = Vector2()
	position = START_POS
	
func getInput(delta):
	
	velocity.x = 0
	
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	#var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var jump = Input.is_action_pressed("ui_up") || Input.is_action_just_pressed("ui_up")

	
	if jump and is_on_floor():
		jumping = true
		velocity.y = initial_jump_speed
	elif jump and jumping and velocity.y > max_jump_speed:
		velocity.y 	+= additional_jump_speed
	else: 
		jumping = false
		
	if Input.is_action_just_pressed("ui_select") and !jumping and !dashing:
		dashing = true
		velocity.y = dash_speed

		
	if left:
		velocity.x -= speed
	if right:
		velocity.x += speed
	
	
func _physics_process(delta):
	
	if jumping and is_on_floor():
		jumping = false
		
	if dashing and is_on_floor():
		dashing = false
		
	if !falling and is_on_floor():
		velocity.y = 0
	
	getInput(delta)
	
	if !is_on_floor():
		falling = true
		velocity.y += delta * gravity
	else:
		falling = false
		
	move_and_slide(velocity, Vector2(0,-1))
	
	# restrict player movement left/right/up	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = max(0, position.y)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
