extends "res://addons/net.kivano.fsm/content/FSMState.gd";
################################### R E A D M E ##################################
# For more informations check script attached to FSM node
#
#

##################################################################################
#####  Variables (Constants, Export Variables, Node Vars, Normal variables)  #####
######################### var myvar setget myvar_set,myvar_get ###################
var pos
var selection
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
	logicRoot.get_node("EndTurn").disabled = false
	logicRoot.selected_piece = null
	logicRoot.get_node("Label").text = "Player " + str(logicRoot.game_model.turn) + " in action"
	 

#when updating state, paramx can be used only if updating fsm manually
func update(deltaTime, param0=null, param1=null, param2=null, param3=null, param4=null):
	if view.selected_card:
		logicRoot.selection = "card"
		
	if Input.is_action_just_pressed("select_piece"):
		pos = Vector2(round((get_viewport().get_mouse_position().x - logicRoot.tile_size.x/2)/logicRoot.tile_size.x), 
			round((get_viewport().get_mouse_position().y - logicRoot.tile_size.y/2)/logicRoot.tile_size.y))
		pos -= logicRoot.BOARD_OFFSET
		if logicRoot.is_within_the_grid(pos):
			# update with the offset
			var selected_cell = model.grid[pos.x][pos.y]
			if selected_cell and not selected_cell.exhausted:
				print("there is something here: " + logicRoot.dic_side[selected_cell.side] +" "+ selected_cell.piece_name)
				if selected_cell.state == selected_cell.IDLE and selected_cell.side == logicRoot.current_turn:
					logicRoot.selected_piece = selected_cell
					logicRoot.selection = "piece"
				else:
					print("but we cannot move it")
			else: 
				logicRoot.reset(logicRoot.cursor_map) 

#when exiting state
func exit(toState=null):
	print(logicRoot.selected_piece)

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
