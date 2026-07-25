extends Node

const MAX_CHICKS := 10

var chicks = MAX_CHICKS
var player_position : Vector3

@warning_ignore("unused_signal") signal start_button_pressed
@warning_ignore("unused_signal") signal next_level
@warning_ignore("unused_signal") signal kill_player
@warning_ignore("unused_signal") signal jump
@warning_ignore("unused_signal") signal kill_chick(formation_pos : int)
@warning_ignore("unused_signal") signal win_game
@warning_ignore("unused_signal") signal reset_game

func _ready() -> void:
	kill_chick.connect(chick_killed)
	reset_game.connect(reset_globals)
	
func chick_killed(_formation_pos : int):
	chicks -= 1
	print("Chicks: " + str(chicks))

func reset_globals():
	chicks = MAX_CHICKS
