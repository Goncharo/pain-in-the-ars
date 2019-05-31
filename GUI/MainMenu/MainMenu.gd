extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	$VBoxContainer/Pain.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$VBoxContainer/HBoxContainer/In.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$VBoxContainer/HBoxContainer/The.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$VBoxContainer/ARS.show()
	yield(get_tree().create_timer(1.25), "timeout")
	$VBoxContainer/Buttons.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
