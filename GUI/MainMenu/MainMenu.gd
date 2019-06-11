extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	$IntroSnare.play()
	$VBoxContainer/Pain.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$IntroSnare.play()
	$VBoxContainer/HBoxContainer/In.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$IntroSnare.play()
	$VBoxContainer/HBoxContainer/The.show()
	yield(get_tree().create_timer(0.5), "timeout")
	$IntroDrop.play()
	$VBoxContainer/ARS.show()
	yield(get_tree().create_timer(2), "timeout")
	$VBoxContainer/Buttons.show()
	$FilteredBackgroundMusic.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
