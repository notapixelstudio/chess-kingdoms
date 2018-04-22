# World.gd
# This is the model. It will handle the state, getting data and modifying the model
extends Node2D

# cursor
var cursor_shape
var cursor_map
var last_cursor_pos
var possible_moves

var selected_piece

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
	model.king.position = map.map_to_world(Vector2(4,7))
	model.grid[4][7] = model.king
	var start_pos = update_child_pos(model.king)
	model.king.position = start_pos
	add_child(model.king)
	
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
	print("position on the grid")
	print(grid_pos)	
	var new_grid_pos = grid_pos + child_node.direction
	model.grid[new_grid_pos.x][new_grid_pos.y] = child_node
	
	child_node.pos_in_the_grid = new_grid_pos
	var target_pos = map.map_to_world(new_grid_pos) + half_tile_size
	return target_pos

func show_legal_moves(piece, legal_moves):
	var grid_pos = map.world_to_map(piece.position)
	print(legal_moves)
	for cell in legal_moves:
		print(cell+grid_pos)
		cursor_map.set_cellv(cell + grid_pos, 4)
	
func reset_cells(force = false):
	if not selected_piece or force:
		possible_moves = []
		for x in range(model.grid_size.x):
			for y in range(model.grid_size.y):
				cursor_map.set_cellv(Vector2(x,y), -1)
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

func select_piece(piece):
	var moves_in_the_grid = []
	for movement in get_legal_moves(piece):
		moves_in_the_grid.append(map.world_to_map(piece.position) + movement)
	print(moves_in_the_grid)
	possible_moves = moves_in_the_grid
	

func _input(event):
	# this is case of moving
	if event is InputEventMouseButton:
		pass
		
	if event.is_action_pressed("select_piece"):
		var pos = Vector2(round((event.global_position.x - position.x - tile_size.x/2)/tile_size.x), round((event.global_position.y - position.y - tile_size.y/2)/tile_size.y))
		var selected_cell = model.grid[pos.x][pos.y]
		if selected_cell and not selected_piece:
			selected_piece = selected_cell
			select_piece(selected_piece)
			print("there is something here: " + selected_piece.piece_name)
		elif selected_piece and pos in possible_moves:
			# this piece is going to move
			selected_piece.target_pos_in_the_grid = pos
			print(selected_piece.pos_in_the_grid)
			selected_piece.direction = pos - selected_piece.pos_in_the_grid 
			print("direction before movement")
			print(selected_piece.direction)
			
			model.move(selected_piece, pos)
			# this will be made by character.gd
			# the position of the piece will be updated by the view.
			selected_piece.target_pos = update_child_pos(selected_piece)
			
			reset()

		else: 
			selected_piece = null
			possible_moves = []
			reset_cells(true)
	if event.is_action_pressed("pause"):
		if get_tree().is_paused():
			get_tree().set_pause(false)
		else:
			get_tree().set_pause(true)

func reset():
	possible_moves = []
	selected_piece = null
	reset_cells()