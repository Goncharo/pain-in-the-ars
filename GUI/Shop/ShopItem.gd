extends Control

class_name ShopItem

var gameState: GameState

var itemName: String = ""
var itemLevels: Array = []
var curItemLevel: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UpgradeButton.connect("pressed", self, "_onUpgradePressed")
	gameState = get_node("/root/GameState")
	gameState.connect("update_player_skrilla", self, "update")
	
func setItemName(itemName: String) -> void:
	self.itemName = itemName
	
func addItemLevel(levelName: String, nextLevelCost: int) -> void:
	itemLevels.append({
		"levelName": levelName,
		"nextLevelCost": nextLevelCost
	});
	
func update(unused: int = -1) -> void:
	$ProgressBar.min_value = 0
	$ProgressBar.max_value = itemLevels.size() - 1
	$ProgressBar.value = curItemLevel
	$ItemName.text = itemName
	if curItemLevel == itemLevels.size() - 1:
		$LevelName.text = itemLevels[curItemLevel].levelName
		$UpgradeButton.text = "MAXXED OUT"
		$UpgradeButton.disabled = true
		$NextLevelCost.text = ""
		return
	$LevelName.text = itemLevels[curItemLevel].levelName
	$NextLevelCost.text = "COSTS    " + String(itemLevels[curItemLevel].nextLevelCost) + "    SKRILLA"
	if gameState.playerSkrilla >= itemLevels[curItemLevel].nextLevelCost:
		$UpgradeButton.disabled = false
	else:
		$UpgradeButton.disabled = true
	
	
func _onUpgradePressed() -> void:
	gameState.upgradeAbility(itemName, itemLevels[curItemLevel].nextLevelCost)
	curItemLevel += 1
	update()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta) -> void:
#	pass
