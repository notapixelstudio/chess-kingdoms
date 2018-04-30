# Model.gd 
# Global singleton that have the state of the grid. And its changing state.
extends Node

var grid_size = Vector2(8, 8)
var grid = []
var piece_defs = {}
var list_piece_name = []

const MOVES = "moves"
const PIECE_DEF_JSON = "res://assets/logic/piece_def.json"

onready var Piece = preload("res://scenes/characters/character.tscn")
var player1 
var player2

var rand_dir = [-1, 0, 1]
enum players {PLAYER1,PLAYER2}
var sign_of_moves = {PLAYER1:-1, PLAYER2:1}
var dic_players = {PLAYER1:"player1", PLAYER2:"player2"}
var turn = 0

const MOVE = "move"
const ATTACK = "take"
const MAX_COUNT = 20

func _ready():
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
		list_piece_name.append(k)
	player1 = Piece.instance()
	player1.piece_name = "king"
	player1.side = PLAYER1
	player1.pos_in_the_grid = Vector2(4,7)
	
	# REMEMBER to add_child to the root
	
	player2 = Piece.instance()
	player2.piece_name = "king"
	player2.side = PLAYER2
	player2.pos_in_the_grid = Vector2(4,0)

	# add players to the grid
	grid[player1.pos_in_the_grid.x][player1.pos_in_the_grid.y] = player1
	grid[player2.pos_in_the_grid.x][player2.pos_in_the_grid.y] = player2


func change_turn():
	turn = (turn + 1) % 2


func get_moves(piece_name):
	# function that get the json for the legal moves. 
	# return array of cells where the piece can move.
	return piece_defs[piece_name][MOVES]


func get_legal_moves(piece):
	# TODO: we don't like repetition of code
	var legal_moves = []
	var pos_to_check = Vector2()

	for pos in piece.moves:
		var step = Vector2(pos["step"].front()*sign_of_moves[piece.side], pos["step"].back()*sign_of_moves[piece.side])
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
					print("someone is on the way")
					pos_to_check = piece.pos_in_the_grid + repeated_step
					if is_within_the_grid(pos_to_check):
						if grid[pos_to_check.x][pos_to_check.y].side != piece.side:
							legal_moves.append({"step":repeated_step, "action":ATTACK})
						else: 
							print("it is our friend")
					break
		else: 
			if is_cell_vacant(piece.pos_in_the_grid, step):
				
				legal_moves.append({"step":step, "action":MOVE})
			else:
				print("someone is on the way")
				pos_to_check = piece.pos_in_the_grid + step
				if is_within_the_grid(pos_to_check):
					if grid[pos_to_check.x][pos_to_check.y].side != piece.side:
						legal_moves.append({"step":step, "action":ATTACK})
					else: 
						print("it is our friend")
	print(legal_moves)
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
	if grid[new_pos.x][new_pos.y]:
		taken_piece = take_piece(piece, grid[new_pos.x][new_pos.y])
	grid[new_pos.x][new_pos.y] = piece
	piece.pos_in_the_grid = new_pos
	change_turn()
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
	print(tmp_list)
	return shuffledList

func summon(king, piece_name):
	var piece = Piece.instance()
	piece.piece_name = piece_name
	piece.side = king.side 
	var possible_direction = Vector2()
	var all = []
	rand_dir = shuffleList(rand_dir)
	for x in rand_dir:
		for y in rand_dir:
			all.append(Vector2(x,y))
	for pos in all:
		
		if is_cell_vacant(king.pos_in_the_grid, pos):
			possible_direction = pos
			break
		
		print(possible_direction)
	if possible_direction:
		piece.pos_in_the_grid = king.pos_in_the_grid + possible_direction
		grid[piece.pos_in_the_grid.x][piece.pos_in_the_grid.y] = piece
		change_turn()
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

func reset():
	_ready()