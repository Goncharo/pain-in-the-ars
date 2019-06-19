extends Node2D

var sceneManager: SceneManager

var waiting_for_action = false

# intro sequence
var intro_complete = false
var text_1_displayed = false
var ars_booted = false
var text_2_displayed = false
var text_3_displayed = false
var bhar_call_complete = false
var text_4_displayed = false
var text_5_displayed = false
var text_6_displayed = false
var text_7_displayed = false
var text_8_displayed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	sceneManager = get_node("/root/SceneManager")
	$ARS.hide()
	$ARS.disableCollisions()
	$ARS.setBootAnim()
	$ARS.show()
	$ARS.connect("boot_complete", self, "_onARSBooted")
	$MessageBoxBHAR.hide()
	$MessageBoxBHAR.muted = true
	$MessageBoxBHAR.text_speed = 0.075
	$MessageBox.playPlayerMessage("Press enter to begin ARS boot sequence")

func _onARSBooted() -> void:
	ars_booted = true

func playBHARCallSeq() -> void:
	$TelephoneRinging.play()
	yield(get_tree().create_timer(2), "timeout")
	$TelephoneRinging.stop()
	$BHARVoice.play()
	yield(get_tree().create_timer(1), "timeout")
	$MessageBoxBHAR.show()
	$MessageBoxBHAR.playPlayerMessage("Dear sir or madam this is Bharati sorry we are having connection issues")
	yield(get_tree().create_timer(1), "timeout")
	bhar_call_complete = true


func progressTutorial() -> void:
	if !intro_complete:
		if !text_1_displayed:
			text_1_displayed = true
			$MessageBox.playPlayerMessage("Booting ARS")
			yield(get_tree().create_timer(0.75), "timeout")
			$ARS.boot()
			waiting_for_action = true
		elif ars_booted:
			waiting_for_action = false
			if !text_2_displayed:
				text_2_displayed = true
				$MessageBox.playPlayerMessage("ARS Started")
			elif !text_3_displayed:
				text_3_displayed = true
				$MessageBox.playPlayerMessage("Initializing ground station connections")
				yield(get_tree().create_timer(3), "timeout")
				playBHARCallSeq()
				waiting_for_action = true
			elif bhar_call_complete:
				waiting_for_action = false
				$MessageBoxBHAR.hide()
				if !text_4_displayed:
					text_4_displayed = true
					$MessageBox.playPlayerMessage("Shit")
				elif !text_5_displayed:
					text_5_displayed = true
					$MessageBox.playPlayerMessage("Someone is probably sleeping again")
				elif !text_6_displayed:
					text_6_displayed = true
					$MessageBox.playPlayerMessage("Proceeding without Bharati")
				elif !text_7_displayed:
					text_7_displayed = true
					$MessageBox.playPlayerMessage("Boot sequence complete ARS is go for production")
				elif !text_8_displayed:
					text_8_displayed = true
					$MessageBox.playPlayerMessage("Good luck")
					intro_complete = true
	else:
		sceneManager.goto_scene("res://Levels/Survival/Survival.tscn")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("ui_cancel"):
		sceneManager.goto_scene("res://Levels/Survival/Survival.tscn")
		
	if $MessageBox.waiting_for_input and (Input.is_action_just_pressed("ui_accept") or waiting_for_action):
		progressTutorial()
		
	
	
