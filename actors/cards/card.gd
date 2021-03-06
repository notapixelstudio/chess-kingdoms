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

var list_modulation = {"ruby": Color(0.66, 0, 0 , 1), "emerald": Color("#00d24c"), "sapphire":Color("#0da0e6"), "amber":Color("#e6a000")}

func set_infocard(data_card):
	var info = $CardControl/Template/CardUI
	info.get_node("InfoCard/PieceName").text = data_card.piece_name.capitalize()
	info.get_node("InfoCard/Tribe").text = data_card.tribe.capitalize()
	info.get_node("InfoCard/Profession").text = data_card.profession.capitalize()
	var powerstring = ""
	for power in data_card.powers:
		powerstring += power + " "
	info.get_node("DescriptionBox/VBoxContainer/Power").text = powerstring.capitalize()
	info.get_node("DescriptionBox/VBoxContainer/Quote").text = data_card.quote.capitalize()
	
	info.get_node("CardTitle/CardName").text = data_card.character_name.capitalize()
	info.get_node("CardTitle/SubName").text = data_card.title.capitalize()
	
	info.get_node("Mana").text = str(data_card.mana_cost)
	info.get_node("TimeUnit").text = str(data_card.time_cost)
	
	
func setup(card):
	data = card
	piece_name = data.piece_name
	mana_cost = data.mana_cost
	set_infocard(card)
	
	# set color  to the artwork
	$CardControl/Template/Artwork.set_modulate(list_modulation[data.kingdom])
	
	$CardControl/Template/Artwork.texture = data.artwork
	flipcard(true)
	
	
func toggle_card(value):
	$CardControl/Template/CardUI.visible = value
	$CardControl/BackgroundArtwork.visible = value
	$CardControl/Template/Artwork.visible = value

func flipcard(new_value):
	back = new_value
	toggle_card(not back)

	card_texture = back_texture if back else data.card_template
	$CardControl/Template.texture = card_texture

func _on_input_event(viewport, event, shape_idx):
	if event.is_class("InputEventMouseButton") \
    and event.button_index == BUTTON_LEFT \
    and event.pressed and not selected and not back:
		selected = true
		view.selected_card = self
		$AnimationPlayer.queue("unfocus")
		return(self) # returns a reference to this node
