extends "res://addons/net.kivano.fsm/content/FSMState.gd"
################################### R E A D M E ##################################
# For more informations check script attached to FSM node
#
#

##################################################################################
#####  Variables (Constants, Export Variables, Node Vars, Normal variables)  #####
######################### var myvar setget myvar_set,myvar_get ###################
var possible_moves
var this_card
var prev_container
var player
var moves
##################################################################################
#########                       Getters and Setters                      #########
##################################################################################
#you will want to use those
func getFSM(): return fsm #defined in parent class
func getLogicRoot(): return logicRoot #defined in parent class 

##################################################################################
#########                 Implement those below ancestor                 #########
##################################################################################
#you can transmit parameters if fsm is initialized manually
func stateInit(inParam1=null,inParam2=null,inParam3=null,inParam4=null, inParam5=null): 
	pass

#when entering state, usually you will want to reset internal state here somehow
func enter(fromStateID=null, fromTransitionID=null, inArg0=null,inArg1=null, inArg2=null):
	print(view.selected_card)
	this_card  = view.selected_card
	select_card(view.selected_card)
	player = logicRoot.players[logicRoot.current_turn]
	var moves_in_the_grid = []
	moves = model.get_legal_summon(player)
	for movement in moves:
		moves_in_the_grid.append(player.pos_in_the_grid + movement["step"])
	logicRoot.possible_moves = moves_in_the_grid
	possible_moves = logicRoot.possible_moves
	view.possible_moves = possible_moves

#when updating state, paramx can be used only if updating fsm manually
func update(deltaTime, param0=null, param1=null, param2=null, param3=null, param4=null):
	if view.selected_card != this_card:
		print("boom")
		fsm.setState(name)

#when exiting state
func exit(toState=null):
	
	if not toState or toState == name:
		deselect_card(this_card)
	

##################################################################################
#########                       Connected Signals                        #########
##################################################################################

##################################################################################
#########     Methods fired because of events (usually via Groups interface)  ####
##################################################################################

##################################################################################
#########                         Public Methods                         #########
##################################################################################
func select_card(card):
	prev_container = card.get_parent()
	prev_container.remove_child(card)
	$CenterContainer.add_child(card)

func deselect_card(card):
	# first you have to remove it and then added
	$CenterContainer.remove_child(card)
	prev_container.add_child(card)


	
##################################################################################
#########                         Inner Methods                          #########
##################################################################################

##################################################################################
#########                         Inner Classes                          #########
##################################################################################
