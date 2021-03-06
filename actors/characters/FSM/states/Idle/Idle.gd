extends "res://addons/net.kivano.fsm/content/FSMState.gd"
################################### R E A D M E ##################################
# For more informations check script attached to FSM node
#
#

##################################################################################
#####  Variables (Constants, Export Variables, Node Vars, Normal variables)  #####
######################### var myvar setget myvar_set,myvar_get ###################


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
	logicRoot.state=name.to_lower()
	logicRoot.animate("idle")
	#logicRoot.get_node("Pivot/Body/StateInfo/Label").set_text("idle")

#when updating state, paramx can be used only if updating fsm manually
func update(deltaTime, param0=null, param1=null, param2=null, param3=null, param4=null):
	# idle has to reiterate its animation
	if not logicRoot.representation.is_playing():
		logicRoot.animate("idle")
	

#when exiting state
func exit(toState=null):
	logicRoot.representation.stop()

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
