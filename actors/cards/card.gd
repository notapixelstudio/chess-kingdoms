extends Node2D

# export (Resource) var data setget setup
export (Texture) var back_texture = "res://assets/cards/cardBack_red1.png"
var back = true setget flipcard
var data setget setup
var card_texture

# structure of the card
var piece_name
var kingdom
var mana_cost
var selected = false
var focused = false

# Structure of the card

var list_power = []


func setup(card):
	data = card
	piece_name = data.piece_name
	mana_cost = data.mana_cost
	print(data)
	$CardControl/Template/Artwork.texture = data.artwork
	flipcard(true)
	
	
func toggle_card(value):
	$CardControl/Template/CardUI.visible = value
	$CardControl/BackgroundArtwork.visible = value
	$CardControl/Template/Artwork.visible = value

func flipcard(new_value):
	back = new_value
	toggle_card(not back)
	print(data)
	print(data.card_template)
	card_texture = back_texture if back else data.card_template
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
