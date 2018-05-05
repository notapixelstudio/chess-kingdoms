extends Camera2D

var magnitude = 1.0
var time_spam = 0
var is_shaking = false
onready var initial_pos = get_position()
func shake(new_mag, new_spam):
	if magnitude > new_mag:
		return
	magnitude = new_mag
	time_spam = new_spam
	
	if is_shaking:
		return
	is_shaking = true
	
	while time_spam > 0:
		var shake = Vector2()
		print("shake")
		shake.x = rand_range(-magnitude, magnitude)
		shake.y = rand_range(-magnitude, magnitude)
		
		set_position(shake)
		time_spam -= get_process_delta_time()
		yield(get_tree(), "idle_frame")
	set_position(initial_pos)
	magnitude = 0
	is_shaking = false