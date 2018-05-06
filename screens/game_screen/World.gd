# World.gd
# This is the model. It will handle the state, getting data and modifying the model
extends Node2D

const BOARD_OFFSET = Vector2(4,1)

# cursor
var cursor_shape
var cursor_map
var last_cursor_pos
var possible_moves

var selected_piece
var list_summonable_pieces = [
	"knight", "rook", "bishop", "queen", "ferz", "alfil", "dabbaba", "centurion", "gold_general", "lance", "shogi_pawn", "wall"]
var tile_size
var half_tile_size
var taken_grid = Vector2(10,0)
var cont_taken = {model.PLAYER1:0, model.PLAYER2:0}

var map
var tiledict
var dic_side = {model.PLAYER1:"player1", model.PLAYER2:"player2"}
var players
var dic_tiles = {
	"move": 12,
	"take": 4,
	"preview":0
	}

func _ready():

	players = {model.PLAYER1 : model.player1, model.PLAYER2: model.player2}
	map = get_node("ChessBoard/board")
	tiledict = map.get_tileset().get_meta('tile_meta')
	tile_size = map.get_cell_size()
	half_tile_size = tile_size / 2

	cursor_map = get_node("ChessBoard/cursor")
	
	possible_moves = []
	
	# in order to put the object at the center
	#Player1
	model.player1.position = assign_position(model.player1.pos_in_the_grid)
	# model.grid[model.player1.pos_in_the_grid.x][model.player1.pos_in_the_grid.y] = model.player1
	add_child(model.player1)

	#Player2
	model.player2.position = assign_position(model.player2.pos_in_the_grid)
	# model.grid[model.player2.pos_in_the_grid.x][model.player2.pos_in_the_grid.y] = model.player2
	add_child(model.player2)

	var squire = null
	squire = model.summon(model.player1, model.list_piece_name[randi()%len(model.list_piece_name)])
	squire.position = assign_position(squire.pos_in_the_grid)
	add_child(squire)

	squire = model.summon(model.player2, model.list_piece_name[randi()% len(model.list_piece_name)])
	squire.position = assign_position(squire.pos_in_the_grid)
	add_child(squire)

func update_child_pos(child_node):
	# Move a child to a new position in the grid Array
	# Returns the new target world position of the child
	var grid_pos = map.world_to_map(child_node.position)
	var new_grid_pos = grid_pos + child_node.direction
	
	child_node.pos_in_the_grid = new_grid_pos - BOARD_OFFSET
	var target_pos = map.map_to_world(new_grid_pos) + half_tile_size
	return target_pos

func show_legal_moves(piece, legal_moves):
	var grid_pos = piece.pos_in_the_grid
	
	for cell in legal_moves:
		# cell[action] could be move, attack
		cursor_map.set_cellv(cell["step"] + grid_pos, dic_tiles[cell["action"]])
		
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
		moves_in_the_grid.append(piece.pos_in_the_grid + movement["step"])
	possible_moves = moves_in_the_grid

func assign_position(pos_in_the_grid):
	return map.map_to_world(pos_in_the_grid+ BOARD_OFFSET) + half_tile_size

func _input(event):
	# this is case of moving
	if not model.playing:
		return
	
	if Input.is_action_just_pressed("summon"):
		var summoned = model.summon(players[model.turn], list_summonable_pieces[randi() % len(list_summonable_pieces)])
		if summoned:
			summoned.position = assign_position(summoned.pos_in_the_grid)
			add_child(summoned)
			if model.turn == 0:
				$Label.text = "White moves or summon"
			else:
				$Label.text = "Black moves or summon"
		else:
			print("we cannot summon any other piece")

	if Input.is_action_pressed("select_piece"):
		var pos = Vector2(round((event.global_position.x - position.x - tile_size.x/2)/tile_size.x), round((event.global_position.y - position.y - tile_size.y/2)/tile_size.y))
		print(pos)
		pos -= BOARD_OFFSET
		if is_within_the_grid(pos):
			# update with the offset
			print("dentro")
			print(pos)
			var selected_cell = model.grid[pos.x][pos.y]
			print(selected_cell)
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
				
				var taken_piece = model.move(selected_piece, pos)
				if taken_piece:
					taken_piece.pos_in_the_grid = Vector2(taken_grid.x+taken_piece.side, cont_taken[taken_piece.side])
					cont_taken[taken_piece.side] += 1
					taken_piece.taken_pos = map.map_to_world(taken_piece.pos_in_the_grid) + half_tile_size
					
				# this will be made by character.gd
				# the position of the piece will be updated by the view.
				selected_piece.target_pos = update_child_pos(selected_piece)
				if model.turn == 0:
					$Label.text = "White moves or summon"
				else:
					$Label.text = "Black moves or summon"
				reset()

			else: 
				reset() 
				
	if Input.is_action_pressed("pause"):
		if get_tree().is_paused():
			get_tree().set_pause(false)
		else:
			get_tree().set_pause(true)

func reset():
	possible_moves = []
	selected_piece = null
	reset_cells()

func _on_Timer_timeout():
	print("timeout")
	model.reset()
	get_tree().reload_current_scene()