# Model.gd 
# Global singleton that have the state of the grid. And its changing state.
extends Node

var grid_size = Vector2(8, 8)
var grid = []
var piece_defs = {}

const PIECE_DEF_JSON = "res://assets/piece_def.json"

func _ready():
    
    # Create the grid Array with null in it.
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
	# load the piece definition
    piece_defs = load(PIECE_DEF_JSON)
            
func get_legal_moves():
	# function that get the json for the legal moves. 
	# return array of cells where the piece can move.
	pass

func move():
	pass

func update_board():
	pass

func load(file_path):
	# example of file path: "res://Ress/panelTextn2.json"
	# ref: https://godotengine.org/qa/8291/how-to-parse-a-json-file-i-wrote-myself
	
	var dict = {}	
	var file = File.new()
	file.open(file_path, file.READ)
	var text = file.get_as_text()
	dict.parse_json(text)
	file.close()
	return dict

func save():
	pass