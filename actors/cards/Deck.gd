extends Node2D

var cards = []
onready var Card = preload("res://actors/cards/Card.tscn")
const DIR_RESOURCES = "res://actors/cards/deck/"
var all_resources = list_files_in_directory(DIR_RESOURCES)

func _ready():
	create_deck(40)
	cards = shuffleList(cards)
	
# TODO: Resources needs to be handled
func create_deck(amount):
	for i in range(amount):
		var c = Card.instance()
		c.data = load(DIR_RESOURCES+all_resources[i% all_resources.size()])
		cards.append(c)
	

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files
	
func add(card_res):
	pass

func draw(amount):
	var hand = []
	for i in range(amount):
		hand.append(cards.pop_front())

	return hand
	
# from https://godotengine.org/qa/2547/how-to-randomize-a-list-array
func shuffleList(list):
	var shuffledList = []
	var indexList = range(list.size())
	for i in range(list.size()):
		randomize()
		var x = randi()%indexList.size()
		shuffledList.append(list[x])
		indexList.remove(x)
		list.remove(x)
	return shuffledList