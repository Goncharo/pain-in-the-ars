extends Area2D

export var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_onBodyEntered")

func _onBodyEntered(body : PhysicsBody2D):
	if body.is_in_group("requests"):
		health -= body.damage
		body.kill()

func kill():
	print("ARS dead")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
