# World.gd
# This is the model. It will handle the state, getting data and modifying the model
extends Node2D

# cursor
var cursor_shape
var last_cursor_pos = Vector2(0,0)
var cursor_map

var tile_size
var half_tile_size

var map
var tiledict

enum ENTITY_TYPES {PLAYER}

func _ready():
	map = get_node("ChessBoard/board")
	tiledict = map.get_tileset().get_meta('tile_meta')
	tile_size = map.get_cell_size()
	cursor_map = get_node("ChessBoard/cursor")
	
	# in order to put the object at the center
	half_tile_size = tile_size / 2
	print(model.king.position)
	model.king.position = map.map_to_world(Vector2(4,7))
	model.grid[4][7] = model.king.piece_name
	print(model.king.position)
	var start_pos = update_child_pos(model.king)
	print(start_pos)
	model.king.position = start_pos
	add_child(model.king)
	print(model.grid)
	
# the object will ask if the cell is vacant
func is_cell_vacant(pos, direction):
	# Return true if the cell is vacant, else false

	var grid_pos = map.world_to_map(pos) + direction
	
	var tile_id = map.get_cellv(grid_pos)
	var solid = tile_id in tiledict and tiledict[tile_id]["solid"]
	
	# world boundaries
	if grid_pos.x < model.grid_size.x and grid_pos.x >=0:
		if grid_pos.y < model.grid_size.y and grid_pos.y >=0:
			return model.grid[grid_pos.x][grid_pos.y] == null and not solid
			
	return false
	
func update_child_pos(child_node):
	# Move a child to a new position in the grid Array
	# Returns the new target world position of the child
	var grid_pos = map.world_to_map(child_node.position)
	model.grid[grid_pos.x][grid_pos.y] = null
	
	var new_grid_pos = grid_pos + child_node.direction
	model.grid[new_grid_pos.x][new_grid_pos.y] = child_node.piece_name
	
	var target_pos = map.map_to_world(new_grid_pos) + half_tile_size
	return target_pos

func show_legal_moves(piece, legal_moves):
	var grid_pos = map.world_to_map(piece.position)
	for cell in legal_moves:
		cursor_map.set_cellv(cell + grid_pos, 11)
	
func reset_cells(piece):
	var grid_pos = map.world_to_map(piece.position)
	for cell in cursor_shape:
		cursor_map.set_cellv(cell + grid_pos, -1)
	cursor_shape= []
	
func get_legal_moves(piece):
	var legal_moves = []
	for pos in piece.moves:
		var step = Vector2(pos["step"].front(), pos["step"].back())
		if is_cell_vacant(piece.position, step):
			legal_moves.append(step)
	show_legal_moves(piece, legal_moves)
	cursor_shape = legal_moves
	return legal_moves

func is_within_the_grid(pos):
	return pos.x >= 0 and pos.x < model.grid_size.x and pos.y >= 0 and pos.y < model.grid_size.y
	
func _input(event):
	
	if event is InputEventMouseButton:
		var pos = Vector2(round((event.global_position.x - position.x - tile_size.x/2)/tile_size.x), round((event.global_position.y - position.y - tile_size.y/2)/tile_size.y))
		if pos != last_cursor_pos:	
			cursor_map.set_cellv(pos, 11)
			last_cursor_pos = pos
		
	if event.is_action_pressed("pause"):
		if get_tree().is_paused():
			get_tree().set_pause(false)
		else:
			get_tree().set_pause(true)