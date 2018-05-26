extends Resource

# https://godotengine.org/qa/8139/need-help-with-exporting-a-custom-ressource-type

export (Texture) var card_template
export (Texture) var artwork
export (String) var kingdom = "ruby"
export (String) var piece_name = "shogi_pawn"
export (String) var powers = "shield"
export (String) var tribe = "royal" 
export (String) var profession = "blacksmith"
export (int) var mana_cost = 1
export (int) var time_cost = 1



# structure of the card

var selected = false
var focused = false

