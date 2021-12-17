extends Node

export (PackedScene) var Bombe
export (PackedScene) var Player
export (PackedScene) var Explosion

var player
func _ready():
	new_game()

func new_game():
	player = pre_configure_game()
	add_child(player)
	player.connect("plant_bombe", self, "bombe_insert")
	player.start($StartPosition.position)

func bombe_insert(pos):
	var bombe = Bombe.instance()
	add_child(bombe)
	var cell_pos = $TileMap.get_cell_center_position(pos)
	bombe.position = cell_pos
	bombe.connect("explosion", self, "bombe_finish")

func pre_configure_game():
	var myPlayer = Player.instance()
	myPlayer.set_name("my_player")
	return myPlayer

func bombe_finish(pos):
	var player_reach = player.get_reach()
	expand(pos, player_reach)

func expand(pos, player_reach):
	expode(pos)
	var size = $TileMap/TileMap.get_cell_size()
	for i in range(player_reach+1):
		var plus = pos.x + (size.x * i)
		var location = Vector2(plus, pos.y)
		if($TileMap.is_wall(location)):
			break
		expode(location)
		
	for i in range(player_reach+1):
		var minus = pos.x - (size.x * i)
		var location = Vector2(minus, pos.y)
		if($TileMap.is_wall(location)):
			break
		expode(location)
	
	for i in range(player_reach+1):
		var plus = pos.y + (size.y * i)
		var location = Vector2(pos.y, plus)
		if($TileMap.is_wall(location)):
			break
		expode(location)
		
	for i in range(player_reach+1):
		var minus = pos.y - (size.y * i)
		var location = Vector2(pos.x, minus)
		if($TileMap.is_wall(location)):
			break
		expode(location)
		
	player.planted -= 1

func expode(pos):
	var explosion = Explosion.instance()
	add_child(explosion)
	explosion.position = pos
