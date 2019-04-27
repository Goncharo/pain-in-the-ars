extends Area2D

class_name ARS

export var health : float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", self, "_onBodyEntered")

func _onBodyEntered(body : PhysicsBody2D) -> void:
	var request := body as Request
	if not request:
		return
	health -= request.damage
	request.kill()

func kill() -> void:
	print("ARS dead")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
