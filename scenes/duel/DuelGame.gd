extends Node2D
class_name DuelGame

signal end_state(state_index)
signal begin_state(state_index)
signal opponent_hurt(pv)

onready var states: Dictionary = {
	"start": $States/Start,
	"river": $States/River,
	"pick": $States/PickCard,
	"choose": $States/ChooseCard,
	"execute": $States/ExecuteCard
}

var playing := false
var current_state_name : String = "start"
var current_state: DuelGameState
var player: Duelist
var opponent: Duelist

func _ready() -> void:
	for state in $States.get_children():
		if state is DuelGameState:
			state.set_duel_game(self)
			state.connect("state_ended", self, "_on_state_ended")
			state.connect("state_leaved", self, "_on_state_leaved")

func start_new_game(the_player: Duelist, the_opponent: Duelist) -> void:
	player = the_player
	opponent = the_opponent
	current_state = _get_state("start")
	$CardBoard.first_distribution(the_player, the_opponent)
	yield($CardBoard, "first_distribution_over")
	$CardBoard.distribute_river()
	yield($CardBoard, "river_distributed")
	$CardBoard.pick_a_card()
	yield($CardBoard, "cards_picked")
	$CardBoard.pick_cards_to_play()
	yield($CardBoard, "cards_to_play_selected")
	print("cards to play selected")
	
	$CardBoard.distribute_river()
	yield($CardBoard, "river_distributed")
	$CardBoard.pick_a_card()
	yield($CardBoard, "cards_picked")
	$CardBoard.pick_cards_to_play()
	yield($CardBoard, "cards_to_play_selected")
	print("cards to play selected")
	#start_state()

func _process(delta: float) -> void:
	if playing and current_state is DuelGameState:
		current_state.process_state(delta)

func _input(event: InputEvent) -> void:
	if current_state is DuelGameState:
		current_state.input(event)

func _get_state(state_name: String) -> DuelGameState:
	return states[state_name] as DuelGameState

func start_state() -> void:
	current_state.enter_state()
	emit_signal("begin_state", current_state_name)

func next_state() -> void:
	print("next_state ", current_state_name)
	if current_state_name == "execute" && someone_is_dead():
		game_over()
	else:
		var next_state_name = next_state_name()
		current_state = _get_state(next_state_name)
		current_state_name = next_state_name
		start_state()

func someone_is_dead() -> bool:
	print("is dead = ", player.is_dead(), " live = ", player.current_life)
	return player.is_dead() or opponent.is_dead()

func next_state_name() -> String:
	return current_state.get_next_state_name()

func game_over() -> void:
	print("game over")
	
func _on_state_ended(state: DuelGameState) -> void:
	print("ended")
	state.leave_state()

func _on_state_leaved(_state: DuelGameState) -> void:
	print("leaved")
	next_state()