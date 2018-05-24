# UI.gd - View
# information about the UI. States stack, global variables etc.
extends Node

enum SELECT {PIECE, CARD}

var selection
var selected_card
var selected_piece
var possible_moves
var current_turn