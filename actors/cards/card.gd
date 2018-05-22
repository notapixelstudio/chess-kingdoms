extends Node2D

export (Resource) var this_card
export (Texture) var back_texture = "res://assets/cards/cardBack_red1.png"
export (bool) var back = true

var card_texture

# structure of the card
var selected = false
var focused = false

# Structure of the card
var piece_name = "shogi_pawn"
var kingdom = "ruby"

var list_power = []

func disable_card():
	$Template/Control.visible = false
	$BackgroundArtwork.visible = false
	$Template/Artwork.visible = false

func _ready():
	if back:
		disable_card()
		card_texture = back_texture
	else: 
		card_texture = this_card.card_template
	
	$Template.texture = card_texture
	

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
