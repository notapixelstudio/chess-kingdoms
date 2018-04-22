# Model.gd 
# Global singleton that have the state of the grid. And its changing state.
extends Node

var grid_size = Vector2(8, 8)
var grid = []
var piece_defs = {}

var battlefield
const MOVES = "moves"
const PIECE_DEF_JSON = "res://assets/logic/piece_def.json"

onready var Piece = preload("res://scenes/characters/character.tscn")
var player1 
func _ready():
	# Create the grid Array with null in it.
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
	# load the piece definition
	piece_defs = load_JSON(PIECE_DEF_JSON)
	
	player1 = Piece.instance()
	player1.piece_name = "rook"
	# grid[player1.position.x][player1.position.y] = player1.piece_name
	print(piece_defs[player1.piece_name])
	# REMEMBER to add_child to the root
            
func get_legal_moves(piece_name):
	# function that get the json for the legal moves. 
	# return array of cells where the piece can move.
	return piece_defs[piece_name][MOVES]


func move(piece, new_pos):
	# this function needs to exist . but I need the grid! and the map! 
	# maybe we need the grid position for the piece?
	print(piece.piece_name + " is going to move")
	grid[piece.pos_in_the_grid.x][piece.pos_in_the_grid.y] = null
	grid[new_pos.x][new_pos.y] = piece
	piece.pos_in_the_grid = new_pos
	

func summon():
	pass

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

func save():
	pass