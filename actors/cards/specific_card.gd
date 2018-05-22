extends Resource

# https://godotengine.org/qa/8139/need-help-with-exporting-a-custom-ressource-type

export (Texture) var card_template
export (String) var kingdom = "ruby"
export (String) var piece_name = "shogi_pawn"


# structure of the card

var selected = false
var focused = false

