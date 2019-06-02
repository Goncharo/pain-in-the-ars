extends Control

export (PackedScene) var ShopItem

class_name Shop

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func initShopItems() -> void:
	addShopItem("Shooting")
	addShopItem("Player Health")
	addShopItem("Speed")
	addShopItem("Jump")
	addShopItem("ARS Health")
	addShopItem("Power of X")

func addShopItem(shopItem: String) -> void:
	# Player shooting upgrades
	if shopItem == "Shooting":
		var shootingItem = ShopItem.instance() as ShopItem
		shootingItem.setItemName("Shooting")
		shootingItem.addItemLevel("Junior Engineer", 200)
		shootingItem.addItemLevel("Staff Engineer", 500)
		shootingItem.addItemLevel("Team Lead", 1000) 
		shootingItem.addItemLevel("Mission Manager", -1)
		$ShopItems.add_child(shootingItem)
		shootingItem.update()
	# Player health upgrades
	elif shopItem == "Player Health":
		var playerHealthItem = ShopItem.instance() as ShopItem
		playerHealthItem.setItemName("Player Health")
		playerHealthItem.addItemLevel("Junior Engineer", 200)
		playerHealthItem.addItemLevel("Staff Engineer", 500)
		playerHealthItem.addItemLevel("Team Lead", 1000) 
		playerHealthItem.addItemLevel("Mission Manager", -1)
		$ShopItems.add_child(playerHealthItem)
		playerHealthItem.update()
	# Player speed upgrades
	elif shopItem == "Speed":
		var playerSpeedItem = ShopItem.instance() as ShopItem
		playerSpeedItem.setItemName("Speed")
		playerSpeedItem.addItemLevel("Junior Engineer", 200)
		playerSpeedItem.addItemLevel("Staff Engineer", 500)
		playerSpeedItem.addItemLevel("Team Lead", 1000) 
		playerSpeedItem.addItemLevel("Mission Manager", -1)
		$ShopItems.add_child(playerSpeedItem)
		playerSpeedItem.update()
	# Player jump upgrades
	elif shopItem == "Jump":
		var playerJumpItem = ShopItem.instance() as ShopItem
		playerJumpItem.setItemName("Jump")
		playerJumpItem.addItemLevel("Junior Engineer", 200)
		playerJumpItem.addItemLevel("Staff Engineer", 500)
		playerJumpItem.addItemLevel("Team Lead", 1000) 
		playerJumpItem.addItemLevel("Mission Manager", -1)
		$ShopItems.add_child(playerJumpItem)
		playerJumpItem.update()
	# ARS Health upgrades
	elif shopItem == "ARS Health":
		var arsHealthItem = ShopItem.instance() as ShopItem
		arsHealthItem.setItemName("ARS Health")
		arsHealthItem.addItemLevel("v1", 200)
		arsHealthItem.addItemLevel("v2", 500)
		arsHealthItem.addItemLevel("v3", 1000) 
		arsHealthItem.addItemLevel("v4", -1)
		$ShopItems.add_child(arsHealthItem)
		arsHealthItem.update()
	# Power of X ability
	elif shopItem == "Power of X":
		var powerOfXItem = ShopItem.instance() as ShopItem
		powerOfXItem.setItemName("Power of X")
		powerOfXItem.addItemLevel("0 Charges", 200)
		powerOfXItem.addItemLevel("1 Charge", 500)
		powerOfXItem.addItemLevel("2 Charges", 1000) 
		powerOfXItem.addItemLevel("3 Charges", -1)
		$ShopItems.add_child(powerOfXItem)
		powerOfXItem.update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
