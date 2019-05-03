extends RigidBody2D

class_name Bullet

export var speed = 2000
export var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisibilityNotifier2D.connect("screen_exited", self, "_onScreenExited")

func spawn(direction : Vector2, initial_position : Vector2) -> void:
	position = initial_position
	linear_velocity = direction * speed
	
func _onScreenExited() -> void:
	queue_free()
	
func kill() -> void:
	$CollisionShape2D.call_deferred("set_disabled", true)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
