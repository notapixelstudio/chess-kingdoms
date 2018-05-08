extends KinematicBody2D

var selected = false
var focused = false

func _ready():
	pass

func _on_Character_mouse_entered():
	focused = true
	$AnimationPlayer.queue("focus")
	
	
func _on_Piece_mouse_exited():
	focused = false
	$AnimationPlayer.queue("unfocus")

