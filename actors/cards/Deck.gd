extends Node2D

var counselor_name
var cards = []
var Card

func add(card_id):
	var card_data = all_cards[self.counselor_name][card_id]
	self.cards.append(self.Card.new(self.counselor_name, card_id, card_data))

func draw(amount):
	var hand = []
	for i in range(amount):
		hand.append(self.cards.pop_front())

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