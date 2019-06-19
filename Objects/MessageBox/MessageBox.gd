extends TextEdit

var waiting_for_input: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	text = ""
	
func flashWaitingSymbol() -> void:
	var flashed = true
	while waiting_for_input:
		yield(get_tree().create_timer(0.5), "timeout")
		if !waiting_for_input:
			return
		flashed = !flashed
		if flashed:
			text = text.rstrip(" 0")
		else:
			text += " 0"
	
func playPlayerMessage(message: String) -> void:
	waiting_for_input = false
	text = ""
	for i in range(message.length()):
		if !$TextSound.playing:
			$TextSound.play()
		yield(get_tree().create_timer(0.05), "timeout")
		text += message[i]
	$TextSound.stop()
	waiting_for_input = true
	flashWaitingSymbol()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
