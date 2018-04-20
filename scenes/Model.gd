# Model.gd 
# Global singleton that have the state of the grid. And its changing state.
extends Node

var grid_size = Vector2(8, 8)
var grid = []
var piece_defs = {}

const MOVES = "moves"
const PIECE_DEF_JSON = "res://assets/logic/piece_def.json"

onready var Piece = preload("res://scenes/characters/character.tscn")
var king 
func _ready():
	# Create the grid Array with null in it.
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
	# load the piece definition
	piece_defs = load_JSON(PIECE_DEF_JSON)
	
	king = Piece.instance()
	king.piece_name = "king"
	# grid[king.position.x][king.position.y] = king.piece_name
	print(piece_defs[king.piece_name])
	# REMEMBER to add_child to the root
            
func get_legal_moves(piece_name):
	# function that get the json for the legal moves. 
	# return array of cells where the piece can move.
	return piece_defs[piece_name][MOVES]
	

func move():
	pass

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