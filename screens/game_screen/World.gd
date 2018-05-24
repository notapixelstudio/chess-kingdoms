# World.gd
# This is the model. It will handle the state, getting data and modifying the model
extends Node

const BOARD_OFFSET = Vector2(4,1)

# reference to model
var game_model 
var current_turn

# cursor
var preview_map
var cursor_map
var last_cursor_pos

# variables for the game
var possible_moves
var selected_piece
var selected_card
var selection 

var list_summonable_pieces = [
	"knight", "rook", "bishop", "queen", "ferz", "alfil", "dabbaba", "centurion", "gold_general", "lance", "shogi_pawn", "wall",
	]
var tile_size
var half_tile_size
var taken_grid = Vector2(10,0)
var cont_taken = {model.PLAYER1:0, model.PLAYER2:0}

var hand
var deck

# state variables

var map
var tiledict
var dic_side = {model.PLAYER1:"player1", model.PLAYER2:"player2"}
var players
var dic_tiles = {
	"move": 12,
	"take": 4,
	"summon":20,
	"preview":21
	}

onready var Card = preload("res://actors/cards/Card.tscn")

func _ready():
	
	game_model = model
	players = {model.PLAYER1 : model.player1, model.PLAYER2: model.player2}
	
	map = get_node("ChessBoard/board")
	cursor_map = get_node("ChessBoard/cursor")
	preview_map = get_node("ChessBoard/preview_cursor")

	tiledict = map.get_tileset().get_meta('tile_meta')
	tile_size = map.get_cell_size()
	half_tile_size = tile_size / 2

	selection = null
	possible_moves = []
	selected_piece = null
	selected_card = null
	
	# in order to put the object at the center
	#Player1
	model.player1.position = assign_position(model.player1.pos_in_the_grid)
	# model.grid[model.player1.pos_in_the_grid.x][model.player1.pos_in_the_grid.y] = model.player1
	add_child(model.player1)

	#Player2
	model.player2.position = assign_position(model.player2.pos_in_the_grid)
	# model.grid[model.player2.pos_in_the_grid.x][model.player2.pos_in_the_grid.y] = model.player2
	add_child(model.player2)
	
	# hide enemy hand
	for card in $EnemyHand.get_children():
		var c = Card.instance()
		card.add_child(c)
	# flip your hand
	for card in $YourHand.get_children():
		print(card)
		var c  = Card.instance()
		card.add_child(c)
		if card.get_child(0):
			card.get_child(0).back = false

func update_child_pos(child_node):
	# Move a child to a new position in the grid Array
	# Returns the new target world position of the child
	var grid_pos = map.world_to_map(child_node.position)
	var new_grid_pos = grid_pos + child_node.direction
	
	child_node.pos_in_the_grid = new_grid_pos - BOARD_OFFSET
	var target_pos = map.map_to_world(new_grid_pos) + half_tile_size
	return target_pos

func show_legal_moves(piece, legal_moves, map_to_show = cursor_map):
	var grid_pos = piece.pos_in_the_grid
	var action = "preview"
	for cell in legal_moves:
		# cell[action] could be move, attack
		if map_to_show == cursor_map:
			action = cell["action"]
		map_to_show.set_cellv(cell["step"] + grid_pos, dic_tiles[action])
	
func reset_cells(map_to_reset):
	for x in range(model.grid_size.x):
		for y in range(model.grid_size.y):
			map_to_reset.set_cellv(Vector2(x,y), -1)

func is_within_the_grid(pos):
	return pos.x >= 0 and pos.x < model.grid_size.x and pos.y >= 0 and pos.y < model.grid_size.y

func select_piece(piece):
	var moves_in_the_grid = []
	var moves = model.get_legal_moves(piece)
	show_legal_moves(piece, moves, cursor_map)
	for movement in moves:
		moves_in_the_grid.append(piece.pos_in_the_grid + movement["step"])
	possible_moves = moves_in_the_grid
	return possible_moves

func assign_position(pos_in_the_grid):
	return map.map_to_world(pos_in_the_grid+ BOARD_OFFSET) + half_tile_size

func _input(event):
	
	# GAME OVER CONDITION
	if not model.playing:
		return
	
	var pos = 0
	# this handles the preview when you hover on cells
	if event is InputEventMouse:
		pos = Vector2(round((event.global_position.x - tile_size.x/2)/tile_size.x), round((event.global_position.y - tile_size.y/2)/tile_size.y))
		pos -= BOARD_OFFSET
		if is_within_the_grid(pos):
			reset(preview_map)
			var selected_cell1 = model.grid[pos.x][pos.y]
			if selected_cell1 != selected_piece and selected_cell1 and selected_cell1.state == selected_cell1.IDLE:
				var moves = model.get_legal_moves(selected_cell1)
				show_legal_moves(selected_cell1, moves, preview_map)
		else:
			reset(preview_map)
			
	
	if Input.is_action_pressed("pause"):
		if get_tree().is_paused():
			get_tree().set_pause(false)
		else:
			get_tree().set_pause(true)

func reset(map_to_reset):
	reset_cells(map_to_reset)

func _on_Timer_timeout():
	print("timeout")
	model.reset()
	get_tree().reload_current_scene()

func _process(delta):
	current_turn = model.turn
	selected_card = view.selected_card