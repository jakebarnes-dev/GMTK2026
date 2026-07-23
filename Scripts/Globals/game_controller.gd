extends Node

const MAX_CHICKS := 10

var chicks = MAX_CHICKS
var player_position : Vector3

@warning_ignore("unused_signal") signal start_button_pressed
@warning_ignore("unused_signal") signal next_level
@warning_ignore("unused_signal") signal kill_player
@warning_ignore("unused_signal") signal jump
@warning_ignore("unused_signal") signal kill_chick(formation_pos : int)
