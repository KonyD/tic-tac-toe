extends Node

enum Player {NONE, X, O}

var grid: Array = []
var current_player: Player = Player.X
var game_over: bool = false
var empty_tiles: int = 9

func _ready() -> void:
	grid = [
		[Player.NONE, Player.NONE, Player.NONE],
		[Player.NONE, Player.NONE, Player.NONE],
		[Player.NONE, Player.NONE, Player.NONE]
	]
	
	for i in range(3):
		for j in range(3):
			var btn = $GridContainer.get_child(i*3+j)
			btn.connect("pressed", Callable(self, "_on_button_pressed").bind(i, j))

func _on_button_pressed(x: int, y: int):
	if game_over or grid[x][y] != Player.NONE:
		return
	
	empty_tiles -= 1

	grid[x][y] = current_player
	var btn = $GridContainer.get_child(x*3+y)
	btn.text = str(current_player)
	
	if check_winner():
		game_over = true
		
		$Label.text = "Player " + str(current_player) + " wins!"
		
		$RetryButton.visible = true
		$RetryButton.disabled = false
	elif empty_tiles == 0:
		$Label.text = "No winners!"
		
		$RetryButton.visible = true
		$RetryButton.disabled = false
	
	# Switch turns
	current_player = Player.O if current_player == Player.X else Player.X

func check_winner() -> bool:
	for i in range(3):
		if grid[i][0] == current_player and grid[i][1] == current_player and grid[i][2] == current_player:
			return true
		if grid[0][i] == current_player and grid[1][i] == current_player and grid[2][i] == current_player:
			return true
	
	if grid[0][0] == current_player and grid[1][1] == current_player and grid[2][2] == current_player:
		return true
	if grid[0][2] == current_player and grid[1][1] == current_player and grid[2][0] == current_player:
		return true
	
	return false


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
