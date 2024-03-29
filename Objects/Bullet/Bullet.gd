extends RigidBody2D

class_name Bullet

export var speed = 2000
export var damage = 10
export var damage_upgrade = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisibilityNotifier2D.connect("screen_exited", self, "_onScreenExited")

func spawn(direction : Vector2, initial_position : Vector2, bullet_level: int) -> void:
	if bullet_level > 0:
		damage += damage_upgrade
	if bullet_level > 1:
		pass
	if bullet_level > 2:
		pass
	position = initial_position
	rotation = (direction - initial_position).angle()
	linear_velocity = Vector2(speed, 0)
	linear_velocity = linear_velocity.rotated(rotation)

	
func _onScreenExited() -> void:
	queue_free()
	
func kill() -> void:
	$Glow.visible = false
	$CollisionShape2D.call_deferred("set_disabled", true)
	linear_velocity = Vector2(0, 0)
	$Explosion.emitting = true
	yield(get_tree().create_timer(1), "timeout")
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
