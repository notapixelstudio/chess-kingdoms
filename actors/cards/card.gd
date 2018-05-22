extends Control

export (Texture) var card_template
export (Resource) var card


# structure of the card

var selected = false
var focused = false

# Structure of the card
var piece_name = "shogi_pawn"
var kingdom = "ruby"

func _ready():
	$Template.texture =  card_template
	piece_name = "shogi_pawn"
	kingdom = "ruby"
	pass

func _on_Character_mouse_entered():
	focused = true
	if not selected:
		$AnimationPlayer.queue("focus")
		
func _on_Piece_mouse_exited():
	focused = false
	if not selected:
		$AnimationPlayer.queue("unfocus")

func _on_Card_input_event(viewport, event, shape_idx):
	if event.is_class("InputEventMouseButton") \
    and event.button_index == BUTTON_LEFT \
    and event.pressed and not selected:
		selected = true
		view.selected_card = self
		$AnimationPlayer.queue("unfocus")
		return(self) # returns a reference to this node
