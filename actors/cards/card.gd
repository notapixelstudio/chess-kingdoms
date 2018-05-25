extends Node2D

export (Resource) var this_card
export (Texture) var back_texture = "res://assets/cards/cardBack_red1.png"
var back = true setget flipcard

var card_texture

# structure of the card
var piece_name
var mana_cost
var selected = false
var focused = false

# Structure of the card

var list_power = []

func _ready():
	piece_name = this_card.piece_name
	mana_cost = this_card.mana_cost
	flipcard(true)
	
func toggle_card(value):
	$CardControl/Template/CardUI.visible = value
	$CardControl/BackgroundArtwork.visible = value
	$CardControl/Template/Artwork.visible = value

func flipcard(new_value):
	back = new_value
	card_texture = back_texture if back else this_card.card_template
	toggle_card(not back)	
	$CardControl/Template.texture = card_texture


func _on_mouse_entered():
	focused = true
	if not selected and not back:
		$AnimationPlayer.queue("focus")
		
func _on_mouse_exited():
	focused = false
	if not selected and not back:
		$AnimationPlayer.queue("unfocus")

func _on_input_event(viewport, event, shape_idx):
	if event.is_class("InputEventMouseButton") \
    and event.button_index == BUTTON_LEFT \
    and event.pressed and not selected:
		selected = true
		view.selected_card = self
		$AnimationPlayer.queue("unfocus")
		return(self) # returns a reference to this node
