extends RigidBody2D

export var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	$VisibilityNotifier2D.connect("screen_exited", self, "_onScreenExited")

func spawn(target, initial_position):
	position = initial_position
	rotation = (target - position).angle()
	linear_velocity = Vector2(speed, 0)
	linear_velocity = linear_velocity.rotated((target - position).angle())
	
func _onScreenExited():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
