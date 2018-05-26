# Model.gd 
# Global singleton that have the state of the grid. And its changing state.
extends Node

# MANA and TIME UNIT
const MANA = "mana"
const TIME_UNIT = "time_unit"
const MAX_MANA = 9
const MAX_TIME = 6 # it is actually 3 
var mana_count
var current_mana_count
var unit_count
var current_unit_count

var grid_size = Vector2(8, 8)
var grid = []
var piece_defs = {}
var list_piece_name = []

const MOVES = "moves"
const PIECE_DEF_JSON = "res://assets/logic/piece_def.json_data"

onready var Piece = preload("res://actors/characters/character.tscn")

var player1 
var player2
var players_struct = {}

var rand_dir = [-1, 0, 1]
enum players {PLAYER1,PLAYER2}
var sign_of_moves = {PLAYER1:-1, PLAYER2:1}
var dic_players = {PLAYER1:"player1", PLAYER2:"player2"}
var turn = 0

const MOVE = "move"
const ATTACK = "take"
const SUMMON = "summon"
const MAX_COUNT = 20
var playing


var selected_card

func _ready():
	mana_count = 2
	current_mana_count = mana_count
	unit_count = 1
	current_unit_count = unit_count
	randomize()
	# list characters
	# Create the grid Array with null in it.
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)

	# load the piece definition
	piece_defs = load_JSON(PIECE_DEF_JSON)
	for k in piece_defs.keys():
		if k != "king":
			list_piece_name.append(k)
	player1 = Piece.instance()
	player1.piece_name = "king"
	player1.side = PLAYER1
	player1.pos_in_the_grid = Vector2(7,4)
	player1.kingdom = "amber"
	player1.set_piece_texture("res://assets/chess/pixel_pieces/ruby_king.png")
	
	players_struct[PLAYER1] = {"king":player1, MANA: mana_count, TIME_UNIT: unit_count}
	# REMEMBER to add_child to the root
	
	player2 = Piece.instance()
	player2.piece_name = "king"
	player2.side = PLAYER2
	player2.kingdom = "emerald"
	player2.pos_in_the_grid = Vector2(0,4)

	players_struct[PLAYER2] = {"king":player2, MANA: mana_count, TIME_UNIT: unit_count}

	# add players to the grid
	grid[player1.pos_in_the_grid.x][player1.pos_in_the_grid.y] = player1
	grid[player2.pos_in_the_grid.x][player2.pos_in_the_grid.y] = player2
	playing = true

func change_turn():
	turn = (turn + 1) % 2
	players_struct[turn][MANA] = min(players_struct[turn][MANA] + 1, MAX_MANA)
	players_struct[turn][TIME_UNIT] = min(players_struct[turn][TIME_UNIT] + 1, MAX_TIME)
	current_unit_count = players_struct[turn][TIME_UNIT]
	print(str(current_unit_count), str(floor(float(current_unit_count)/2)))
	current_unit_count = floor(float(current_unit_count)/2)
	
	current_mana_count = players_struct[turn][MANA]

func get_moves(piece_name):
	# function that get the json for the legal moves. 
	# return array of cells where the piece can move.
	return piece_defs[piece_name][MOVES]

func get_legal_summon(piece):
	var legal_moves = []
	for pos in piece.moves:
		var step = Vector2(pos["step"].back()*sign_of_moves[piece.side], pos["step"].front()*sign_of_moves[piece.side])
		if is_cell_vacant(piece.pos_in_the_grid, step):
			legal_moves.append({"step":step, "action":SUMMON})
	return legal_moves
	
func get_legal_moves(piece):
	# TODO: we don't like repetition of code
	var legal_moves = []
	var pos_to_check = Vector2()

	for pos in piece.moves:
		var step = Vector2(pos["step"].back()*sign_of_moves[piece.side], pos["step"].front()*sign_of_moves[piece.side])
		if pos.has("repeat"):
			var repeated_step = Vector2()
			# we just need one multiplier
			for i in range(1,model.grid_size.x):
				repeated_step.x = step.x * i
				repeated_step.y = step.y * i

				# TODO: check if leaps or not
				if is_cell_vacant(piece.pos_in_the_grid, repeated_step):
					legal_moves.append({"step":repeated_step, "action":MOVE})
				else:
					pos_to_check = piece.pos_in_the_grid + repeated_step
					if is_within_the_grid(pos_to_check):
						if grid[pos_to_check.x][pos_to_check.y].side != piece.side:
							legal_moves.append({"step":repeated_step, "action":ATTACK})
						
					break
		else: 
			if is_cell_vacant(piece.pos_in_the_grid, step):
				
				legal_moves.append({"step":step, "action":MOVE})
			else:
				pos_to_check = piece.pos_in_the_grid + step
				if is_within_the_grid(pos_to_check):
					if grid[pos_to_check.x][pos_to_check.y].side != piece.side:
						legal_moves.append({"step":step, "action":ATTACK})
					
	return legal_moves

# return the piece that occupies the cell, if hit the boundaries, return null
func is_cell_vacant(pos_in_the_grid, direction):
	var grid_pos = pos_in_the_grid + direction
	# world boundaries
	if is_within_the_grid(grid_pos):
		return model.grid[grid_pos.x][grid_pos.y] == null
			
func is_within_the_grid(pos):
	return pos.x >= 0 and pos.x < grid_size.x and pos.y >= 0 and pos.y < grid_size.y
				
func take_piece(attacker, defender):
	grid[defender.pos_in_the_grid.x][defender.pos_in_the_grid.y] = null
	defender.taken = true
	print(defender.piece_name + " has been taken")
	if defender.piece_name == "king":
		game_over(defender)
	return defender

func move(piece, new_pos):
	# this function needs to exist . but I need the grid! and the map! 
	# maybe we need the grid position for the piece?
	print(dic_players[piece.side] +" "+ piece.piece_name + " is going to move")
	
	grid[piece.pos_in_the_grid.x][piece.pos_in_the_grid.y] = null
	var taken_piece = null

	current_unit_count -= piece.time_unit_cost
	
	if grid[new_pos.x][new_pos.y]:
		taken_piece = take_piece(piece, grid[new_pos.x][new_pos.y])
	grid[new_pos.x][new_pos.y] = piece
	piece.pos_in_the_grid = new_pos
	return taken_piece
	
# from https://godotengine.org/qa/2547/how-to-randomize-a-list-array
func shuffleList(list):
	var tmp_list = list
	var shuffledList = []
	var indexList = range(list.size())
	for i in range(list.size()):
		randomize()
		var x = randi()%indexList.size()
		shuffledList.append(list[x])
		indexList.remove(x)
		list.remove(x)
	list = tmp_list
	return shuffledList

func summon(king, card, target_pos = null):
	var piece = Piece.instance()
	var piece_name = card.piece_name
	piece.piece_name = piece_name
	piece.kingdom = card.data.kingdom
	print(piece.kingdom)
	piece.side = king.side 
	var possible_direction = Vector2()
	var all = []
	if not target_pos:
		rand_dir = shuffleList(rand_dir)
		for x in rand_dir:
			for y in rand_dir:
				all.append(Vector2(x,y))
		for pos in all:
			if is_cell_vacant(king.pos_in_the_grid, pos):
				possible_direction = pos
				break
	else:
		possible_direction = target_pos	- king.pos_in_the_grid
	if possible_direction:
		piece.pos_in_the_grid = king.pos_in_the_grid + possible_direction
		grid[piece.pos_in_the_grid.x][piece.pos_in_the_grid.y] = piece
		current_mana_count -= card.mana_cost
		# change_turn()
		return piece
	else:
		return null

func update_board():
	pass

func load_JSON(file_path):
	# example of file path: "res://Ress/panelTextn2.json"
	# ref: https://godotengine.org/qa/8291/how-to-parse-a-json-file-i-wrote-myself
	
	var dict = {}	
	var file = File.new()
	file.open(file_path, file.READ)
	var text = file.get_as_text()
	dict = parse_json(text)
	file.close()
	return dict


func game_over(king_defeated):
	print("game_over")
	print(str((king_defeated.side + 1)%2) + " won")
	playing = false

func reset():
	_ready()