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
var dic_side = {model.PLAYER1:"player1", model.PLAYER2:"player2"}


func _ready():
	map = get_node("ChessBoard/board")
	tiledict = map.get_tileset().get_meta('tile_meta')
	tile_size = map.get_cell_size()
	half_tile_size = tile_size / 2

	cursor_map = get_node("ChessBoard/cursor")
	
	possible_moves = []
	
	# in order to put the object at the center
	#Player1
	model.player1.position = map.map_to_world(model.player1.pos_in_the_grid)
	# model.grid[model.player1.pos_in_the_grid.x][model.player1.pos_in_the_grid.y] = model.player1
	model.player1.position =  update_child_pos(model.player1)
	add_child(model.player1)

	#Player2
	model.player2.position = map.map_to_world(model.player2.pos_in_the_grid)
	# model.grid[model.player2.pos_in_the_grid.x][model.player2.pos_in_the_grid.y] = model.player2
	model.player2.position = update_child_pos(model.player2)
	add_child(model.player2)
	
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
	var new_grid_pos = grid_pos + child_node.direction
	
	child_node.pos_in_the_grid = new_grid_pos
	var target_pos = map.map_to_world(new_grid_pos) + half_tile_size
	return target_pos

func show_legal_moves(piece, legal_moves):
	var grid_pos = map.world_to_map(piece.position)
	
	for cell in legal_moves:
		cursor_map.set_cellv(cell + grid_pos, 4)
	cursor_shape = legal_moves
	
func reset_cells(force = false):
	if not selected_piece or force:
		possible_moves = []
		for x in range(model.grid_size.x):
			for y in range(model.grid_size.y):
				cursor_map.set_cellv(Vector2(x,y), -1)
	cursor_shape= []
	

func is_within_the_grid(pos):
	return pos.x >= 0 and pos.x < model.grid_size.x and pos.y >= 0 and pos.y < model.grid_size.y

func select_piece(piece):
	var moves_in_the_grid = []
	var moves = model.get_legal_moves(piece)
	show_legal_moves(piece, moves)
	for movement in moves:
		moves_in_the_grid.append(map.world_to_map(piece.position) + movement)
	possible_moves = moves_in_the_grid
	

func _input(event):
	# this is case of moving
	if event is InputEventMouseButton:
		pass
		
	if event.is_action_pressed("select_piece"):
		var pos = Vector2(round((event.global_position.x - position.x - tile_size.x/2)/tile_size.x), round((event.global_position.y - position.y - tile_size.y/2)/tile_size.y))
		if is_within_the_grid(pos):
			var selected_cell = model.grid[pos.x][pos.y]
			if selected_cell and not selected_piece:
				selected_piece = selected_cell
				print("there is something here: " + dic_side[selected_piece.side] +" "+ selected_piece.piece_name)
				if selected_piece.state == selected_piece.IDLE and selected_piece.side == model.turn:
					select_piece(selected_piece)
				else:
					print("but we cannot move it")
				
			elif selected_piece and pos in possible_moves and selected_piece.state == selected_piece.IDLE:
				# this piece is going to move
				selected_piece.target_pos_in_the_grid = pos
				selected_piece.direction = pos - selected_piece.pos_in_the_grid 
				
				model.move(selected_piece, pos)
				if model.turn == 0:
					$Label.text = "White moves"
				else:
					$Label.text = "Black moves"
				# this will be made by character.gd
				# the position of the piece will be updated by the view.
				selected_piece.target_pos = update_child_pos(selected_piece)
				reset()

			else: 
				reset() 
				
	if event.is_action_pressed("pause"):
		if get_tree().is_paused():
			get_tree().set_pause(false)
		else:
			get_tree().set_pause(true)

func reset():
	possible_moves = []
	selected_piece = null
	reset_cells()