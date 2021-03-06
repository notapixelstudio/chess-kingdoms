extends KinematicBody2D

var direction = Vector2()

const WALK = "walk"
const IDLE = "idle"
const SETUP = "setup"
const ATTACK = "attack"
const DIE = "die"
const STAGGER = "stagger"
const EXHAUSTED = "exhausted"

const TOP = Vector2(0, -1)
const RIGHT = Vector2(1, 0)
const DOWN = Vector2(0, -1)
const LEFT = Vector2(-1, 0)

#condition of being alive
var taken = false
const MAX_SPEED = 0.5

var sprite 
var speed = 0
var velocity = Vector2()

var target_pos = Vector2()
var is_moving = false
# when first summoned it is exhausted
var exhausted = true

var type
var state
var battlefield

var side
# Structure of the piece
var piece_name
var moves
var legal_moves
var pos_in_the_grid
var target_pos_in_the_grid
var taken_pos

# Shadoran-specific
var kingdom = "ruby"
var powers = []
var move_again = false
var has_celerity = false
var card

# structure of piece
var time_unit_cost 
var time_unit_multiplier = 2

export var baseScale = 1
onready var representation = get_node("AnimationPlayer")
onready var pivot = get_node("Pivot")

func _ready():
	representation.play(SETUP)
	battlefield = get_parent()
	representation.play("summon")
	# set_piece_texture("res://assets/chess/pieces/chess_piece_"+str(side)+"_"+piece_name+".png")
	face_with_side()
	#$StateInfo/Label.set_text(self.piece_name)
	# set_piece_texture("res://assets/chess/pixel_pieces/"+kingdom+"_"+piece_name+".png")
	$Pivot/Body.texture = sprite
	$Kingdom.text = kingdom
	moves = model.get_moves(self.piece_name)
	
	if "quick" in powers:
		time_unit_multiplier = 1
	time_unit_cost = card.data.time_cost * time_unit_multiplier

	if "restless" in powers:
		has_celerity = true
		move_again = true
	if "swarm" in powers:
		exhausted = false

func animate(keyword):
	representation.play(keyword)

func face_with_side():
	if side:
		face_right()
	else:
		face_left()

func face_left():
	pivot.scale = Vector2(-baseScale, baseScale)

func face_right():
	pivot.scale = Vector2(baseScale, baseScale)

func set_piece_texture(img_filename):
	$Pivot/Body.texture = load(img_filename)

func _physics_process(delta):
	speed = 0
	
	if not is_moving and target_pos != Vector2():
		# Actually I think target_pos cannot be NON vacant
		# if battlefield.is_cell_vacant(position, target_pos):
		# target_pos = battlefield.update_child_pos(self)
		is_moving = true
	elif is_moving:
		speed = MAX_SPEED
		velocity = speed * direction
		var pos = position
		var distance_to_target = Vector2(abs(target_pos.x - position.x), abs(target_pos.y - pos.y))
		if distance_to_target == Vector2():
			is_moving = false
			if move_again:
				move_again = false
			else:
				exhausted = true
		if abs(velocity.x) > distance_to_target.x: 
			velocity.x = distance_to_target.x * target_pos.x
			target_pos = Vector2()	
		if abs(velocity.y) > distance_to_target.y: 
			velocity.y = distance_to_target.y * target_pos.y	
			target_pos = Vector2()	
		move_and_collide(velocity)
		