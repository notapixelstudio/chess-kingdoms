extends "res://addons/net.kivano.fsm/content/FSMState.gd";
################################### R E A D M E ##################################
# For more informations check script attached to FSM node
#
#

##################################################################################
#####  Variables (Constants, Export Variables, Node Vars, Normal variables)  #####
######################### var myvar setget myvar_set,myvar_get ###################
var pos
var this_card
##################################################################################
#########                       Getters and Setters                      #########
##################################################################################
#you will want to use those
func getFSM(): return fsm; #defined in parent class
func getLogicRoot(): return logicRoot; #defined in parent class 

##################################################################################
#########                 Implement those below ancestor                 #########
##################################################################################
#you can transmit parameters if fsm is initialized manually
func stateInit(inParam1=null,inParam2=null,inParam3=null,inParam4=null, inParam5=null): 
	pass

#when entering state, usually you will want to reset internal state here somehow
func enter(fromStateID=null, fromTransitionID=null, inArg0=null,inArg1=null, inArg2=null):
	logicRoot.get_node("Label").text = "Please choose the target cell"
	print(logicRoot.possible_moves)

#when updating state, paramx can be used only if updating fsm manually
func update(deltaTime, param0=null, param1=null, param2=null, param3=null, param4=null):
	if Input.is_action_just_pressed("select_piece"):
		pos = Vector2(round((get_viewport().get_mouse_position().x - logicRoot.tile_size.x/2)/logicRoot.tile_size.x), 
			round((get_viewport().get_mouse_position().y - logicRoot.tile_size.y/2)/logicRoot.tile_size.y))
		pos -= logicRoot.BOARD_OFFSET
		print(model.selected_card)
		print(pos)
		print(logicRoot.possible_moves)
		if logicRoot.is_within_the_grid(pos) and pos in logicRoot.possible_moves and model.selected_card:
			var piece = model.summon(logicRoot.players[model.turn], model.selected_card.piece_name, pos)
			piece.position = logicRoot.assign_position(piece.pos_in_the_grid)
			logicRoot.add_child(piece)
			print("boomba")
		
		if logicRoot.is_within_the_grid(pos) and logicRoot.selected_piece \
		and pos in logicRoot.possible_moves and logicRoot.selected_piece.state == logicRoot.selected_piece.IDLE:
				# state: MOVE OR TAKE
				# this piece is going to move
				logicRoot.selected_piece.target_pos_in_the_grid = pos
				logicRoot.selected_piece.direction = pos - logicRoot.selected_piece.pos_in_the_grid 
				
				var taken_piece = model.move(logicRoot.selected_piece, pos)
				if taken_piece:
					taken_piece.pos_in_the_grid = Vector2(logicRoot.taken_grid.x+taken_piece.side, logicRoot.cont_taken[taken_piece.side])
					logicRoot.cont_taken[taken_piece.side] += 1
					taken_piece.taken_pos = logicRoot.map.map_to_world(taken_piece.pos_in_the_grid) + logicRoot.half_tile_size
					
				# this will be made by character.gd
				# the position of the piece will be updated by the view.
				logicRoot.selected_piece.target_pos = logicRoot.update_child_pos(logicRoot.selected_piece)

		this_card = model.selected_card
		logicRoot.possible_moves = []
		logicRoot.game_model.selected_card = null


#when exiting state
func exit(toState=null):
	logicRoot.selection = null
	logicRoot.selected_piece = null
	logicRoot.reset(logicRoot.cursor_map)
	if this_card:
		this_card.queue_free()


##################################################################################
#########                       Connected Signals                        #########
##################################################################################

##################################################################################
#########     Methods fired because of events (usually via Groups interface)  ####
##################################################################################

##################################################################################
#########                         Public Methods                         #########
##################################################################################

##################################################################################
#########                         Inner Methods                          #########
##################################################################################

##################################################################################
#########                         Inner Classes                          #########
##################################################################################
