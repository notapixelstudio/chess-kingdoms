extends "res://addons/net.kivano.fsm/content/FSMState.gd"
################################### R E A D M E ##################################
# For more informations check script attached to FSM node
#
#

##################################################################################
#####  Variables (Constants, Export Variables, Node Vars, Normal variables)  #####
######################### var myvar setget myvar_set,myvar_get ###################
var timeout = false
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
	timeout = false
	$Timer.start()
	print(view.current_turn)
	logicRoot.get_node("GUI/VBoxContainer/HBoxContainer/TimeUnit").set_counter(model.current_unit_count)
	logicRoot.get_node("GUI/VBoxContainer/HBoxContainer/ManaUnit").set_counter(model.current_mana_count)
	logicRoot.get_node("GUI/VBoxContainer/Label").text = "Drawing a card"

#when updating state, paramx can be used only if updating fsm manually
func update(deltaTime, param0=null, param1=null, param2=null, param3=null, param4=null):
	pass

#when exiting state
func exit(toState=null):
	for card in logicRoot.get_node("Hand" + str(logicRoot.current_turn)).get_children():
		if card.get_child(0):
			card.get_child(0).back = false

	for piece in logicRoot.active_pieces:
		if view.current_turn == piece.side:
			piece.exhausted  = false

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


func _on_Timer_timeout():
	timeout = true
	var enemy = (view.current_turn + 1) % 2
	for card in logicRoot.get_node("Hand" + enemy).get_children():
		if card.get_child(0):
			card.get_child(0).back = true
	for card in logicRoot.get_node("Hand" + logicRoot.currnet_turn).get_children():
		if card.get_child(0):
			card.get_child(0).back = false
