extends Node2D

export (PackedScene) var request

var gameState: GameState
var sceneManager: SceneManager

var waiting_for_action = false

# game description
var game_desc_displayed = false

# movement tutorial
var movement_tutorial_complete = false
var text_1_displayed = false
var text_2_displayed = false
var text_3_displayed = false
var moved_left = false
var moved_right = false

# jumping tutorial
var jumping_tutorial_complete = false

var text_4_displayed = false
var text_5_displayed = false
var jumped = false

# shooting tutorial
var shooting_tutorial_complete = false
var text_6_displayed = false
var text_7_displayed = false
var shot = false

# killing tutorial
var killing_tutorial_complete = false
var text_8_displayed = false
var text_9_displayed = false
var text_10_displayed = false
var text_11_displayed = false
var request_spawned = false
var request_dead = false

# health tutorial
var health_tutorial_complete = false
var text_12_displayed = false
var text_13_displayed = false
var text_14_displayed = false
var requests_spawned = false
var requests_dead = false

# buying tutorial
var buying_tutorial_complete = false
var text_15_displayed = false
var text_16_displayed = false
var text_17_displayed = false
var text_18_displayed = false
var text_19_displayed = false
var shop_enabled = false
var shop_open = false

# power of x tutorial
var power_of_x_tutorial_complete = false
var text_20_displayed = false
var text_21_displayed = false
var text_22_displayed = false
var text_23_displayed = false
var bought_power_of_x = false
var power_of_x_used = false
var more_requests_spawned = false
var more_requests_dead = false

# tutorials complete
var all_tutorials_complete = false
var complete_text1_displayed = false
var complete_text2_displayed = false
var complete_text3_displayed = false
var ready_to_quit = false


# Called when the node enters the scene tree for the first time.
func _ready():
	gameState = get_node("/root/GameState")
	sceneManager = get_node("/root/SceneManager")
	$GUI/HUD/PlayerHealth.hide()
	$GUI/HUD/ARSHealth.hide()
	$GUI/HUD/PlayerSkrilla.hide()
	$GUI/HUD/PlayerScore.hide()
	$ARS.hide()
	$ARS.disableCollisions()
	gameState.updatePlayerMessage("")
	gameState.reset_stats()
	gameState.tutorialMode = true
	
	$MessageBox.playPlayerMessage("welcome to the tutorial please press enter to continue or press escape at any time to go back to the main menu")
	
func toggleShop() -> void:
	if shop_open:
		$ShopCloseSound.play()
		$GUI/Shop.hide()
		$GUI/HUD.show()
	else:
		$ShopOpenSound.play()
		$GUI/HUD.hide()
		$GUI/Shop.show()
	shop_open = !shop_open
	gameState.shop_open = shop_open
	
func spawnRequest(target, pos, speed, type) -> void:
	var request_instance = request.instance() as Request
	add_child(request_instance)
	request_instance.spawn(target, pos, speed, type)
	
func progressTutorial() -> void:
	# game description
	if !game_desc_displayed:
		game_desc_displayed = true
		$MessageBox.playPlayerMessage("you are an ai tasked with the near impossible objective of keeping ars operational")
	# movement tutorial
	elif !movement_tutorial_complete:
		if !text_1_displayed:
			text_1_displayed = true
			$MessageBox.playPlayerMessage("if you think you are up to the task then you will first need to learn how to move")
		elif !text_2_displayed:
			text_2_displayed = true
			$MessageBox.playPlayerMessage("use the a key to move left and the d key to move right and give it a try  now")
			waiting_for_action = true
		else:
			if Input.is_action_just_pressed("ui_left"):
				moved_left = true
			if Input.is_action_just_pressed("ui_right"):
				moved_right = true
			if moved_left and moved_right:
				movement_tutorial_complete = true
				waiting_for_action = false
				$MessageBox.playPlayerMessage("excellent")
	# jumping tutorial
	elif !jumping_tutorial_complete:
		if !text_3_displayed:
			text_3_displayed = true
			$MessageBox.playPlayerMessage("next you will learn how to jump")
		elif !text_4_displayed:
			text_4_displayed = true
			$MessageBox.playPlayerMessage("to jump you can press and hold the space key and press it again mid air for a double jump")
		elif !text_5_displayed:
			text_5_displayed = true
			$MessageBox.playPlayerMessage("give it a try now and note that the longer you hold space the higher your initial jump will be")
			waiting_for_action = true
		else:
			if Input.is_action_just_pressed("ui_select"):
				jumped = true
			if jumped:
				jumping_tutorial_complete = true
				waiting_for_action = false
				$MessageBox.playPlayerMessage("nice jumping")
	# shooting tutorial
	elif !shooting_tutorial_complete:
		if !text_6_displayed:
			text_6_displayed = true
			$MessageBox.playPlayerMessage("next you will learn how to shoot")
		elif !text_7_displayed:
			text_7_displayed = true
			$MessageBox.playPlayerMessage("try it now by clicking the left mouse button and pointing at a location on the screen")
			waiting_for_action = true
		else:
			if shot:
				shooting_tutorial_complete = true
				waiting_for_action = false
				$MessageBox.playPlayerMessage("fantastic shooting")
	# killing tutorial
	elif !killing_tutorial_complete:
		if !text_8_displayed:
			$ARS.show()
			$ARS.enableCollisions()
			$GUI/HUD/ARSHealth.show()
			text_8_displayed = true
			$MessageBox.playPlayerMessage("this is ars the pride and joy of the ground segment")
		elif !text_9_displayed:
			text_9_displayed = true
			$MessageBox.playPlayerMessage("to keep ars operational you must ensure it does not receive too many requests")
		elif !text_10_displayed:
			text_10_displayed = true
			$MessageBox.playPlayerMessage("to accomplish this you must shoot the requests and destroy them before they get to ars")
		elif !text_11_displayed:
			text_11_displayed = true
			$GUI/HUD/PlayerScore.show()
			$GUI/HUD/PlayerSkrilla.show()
			$MessageBox.playPlayerMessage("quick here comes a RES REQ now")
			waiting_for_action = true
		else:
			if !request_spawned:
				request_spawned = true
				spawnRequest($ARS.position, $RequestSpawnPos.position, 1, 3)
			else:
				if(!get_tree().has_group("requests")):
					killing_tutorial_complete = true
					waiting_for_action = false
					$MessageBox.playPlayerMessage("nice work and note that the requests will come in waves")
	elif !health_tutorial_complete:
		if !text_12_displayed:
			text_12_displayed = true
			$MessageBox.playPlayerMessage("if a request gets to ars it will take damage and if a request touches you then you will take damage")
		elif !text_13_displayed:
			text_13_displayed = true
			$MessageBox.playPlayerMessage("if you fall off the screen then you will also take some damage but for now you are safe")
		elif !text_14_displayed:
			text_14_displayed = true
			$MessageBox.playPlayerMessage("if you or ars takes too much damage then ars will get overwhelmed with requests and you will fail your mission")
			$GUI/HUD/PlayerHealth.show()
			waiting_for_action = true
		else:
			if !requests_spawned:
				requests_spawned = true
				gameState.wave_in_progress = true
				spawnRequest($ARS.position, $RequestSpawnPos.position, 6, 2)
				spawnRequest(gameState.playerPosition, $RequestSpawnPos.position, 8, 1)
			else:
				if(!get_tree().has_group("requests")):
					gameState.wave_in_progress = false
					health_tutorial_complete = true
					waiting_for_action = false
					$MessageBox.playPlayerMessage("after analyzing results from that surprise test it appears you have suboptimal reflexes")	
	# buying tutorial
	elif !buying_tutorial_complete:
		if !text_15_displayed:
			text_15_displayed = true
			$MessageBox.playPlayerMessage("remember you can give up at any time but otherwise I will heal you now so we can continue")
		elif !text_16_displayed:
			gameState.reset_stats()
			text_16_displayed = true
			$MessageBox.playPlayerMessage("as you can see in the top right corner you have earned some skrilla for destroying the first request")
		elif !text_17_displayed:
			text_17_displayed = true
			$MessageBox.playPlayerMessage("you will only earn it when you destroy a request but I will generously give you some extra skrilla now")
		elif !text_18_displayed:
			text_18_displayed = true
			gameState.updatePlayerSkrilla(700)
			$MessageBox.playPlayerMessage("you can use skrilla to buy upgrades for your abilities in the shop but only in between waves of requests")
		elif !text_19_displayed:
			text_19_displayed = true
			$MessageBox.playPlayerMessage("try it now by buying 2 shooting upgrades you can press the b key to open and close the shop and then left click on the upgrade buttons")
			$GUI/Shop.addShopItem("Shooting")
			waiting_for_action = true
		else:
			if !shop_enabled:
				shop_enabled = true
			elif $Player.cur_shoot_level == 2:
				shop_enabled = false
				waiting_for_action = false
				buying_tutorial_complete = true
				if shop_open:
					toggleShop()
				$MessageBox.playPlayerMessage("as you already know you can try to compensate for your shortcomings by buying more things")
	# power of x tutorial
	elif !power_of_x_tutorial_complete:
		if !text_20_displayed:
			text_20_displayed = true
			$MessageBox.playPlayerMessage("the last thing you need to know is how to use the power of x")
		elif !text_21_displayed:
			text_21_displayed = true
			gameState.updatePlayerSkrilla(200)
			$MessageBox.playPlayerMessage("using the skrilla I have just given you use the shop to buy the power of x")
			$GUI/Shop.addShopItem("Power of X")
			waiting_for_action = true
		elif !bought_power_of_x:
			if !shop_enabled:
				shop_enabled = true
			elif gameState.power_of_x_max_charge == 1:
				bought_power_of_x = true
				shop_enabled = false
				waiting_for_action = false
				if shop_open:
					toggleShop()
				$MessageBox.playPlayerMessage("you can use the power of x during a wave to destroy all requests on the screen by pressing the x key")
		elif !text_22_displayed:
			text_22_displayed = true
			$MessageBox.playPlayerMessage("the more upgrades you buy for it the more times you can use it during a wave")
		elif !text_23_displayed:
			text_23_displayed = true
			$MessageBox.playPlayerMessage("more requests are inbound press the x key to unleash the power of x on them")
			waiting_for_action = true
		elif !power_of_x_used:
			if !more_requests_spawned:
				gameState.wave_in_progress = true
				more_requests_spawned = true
				spawnRequest($ARS.position, $RequestSpawnPos.position, 1, 2)
				spawnRequest($ARS.position, $RequestSpawnPos2.position, 1, 2)
				spawnRequest($ARS.position, $RequestSpawnPos3.position, 1, 2)
				spawnRequest($ARS.position, $RequestSpawnPos4.position, 1, 2)
			elif !more_requests_dead:
				if(!get_tree().has_group("requests")):
					gameState.wave_in_progress = false
					more_requests_dead = true
					waiting_for_action = false
					power_of_x_used = true
					power_of_x_tutorial_complete = true
					$MessageBox.playPlayerMessage("nice job but be warned that sometimes the power of x can backfire on you")
					all_tutorials_complete = true	
	elif all_tutorials_complete and !ready_to_quit:
		if !complete_text1_displayed:
			complete_text1_displayed = true
			$MessageBox.playPlayerMessage("that is it")
		elif !complete_text2_displayed:
			complete_text2_displayed = true
			$MessageBox.playPlayerMessage("now you are ready to take ars into production")
		elif !complete_text3_displayed:
			complete_text3_displayed = true
			$MessageBox.playPlayerMessage("hopefully you will remember something from this tutorial")
			ready_to_quit = true
	elif ready_to_quit:
		sceneManager.goto_scene("res://Main.tscn")
				
func _input(event):
	if waiting_for_action and !shooting_tutorial_complete and event is InputEventScreenTouch and event.pressed:
		shot = true
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("ui_cancel"):
		sceneManager.goto_scene("res://Main.tscn")
		
	if Input.is_action_just_pressed("open_shop") and shop_enabled:
		toggleShop()
		
	if $MessageBox.waiting_for_input and (Input.is_action_just_pressed("ui_accept") or waiting_for_action):
		progressTutorial()
		
	
	
