extends Node
class_name DialogLine

export(Texture) var actor_texture : Texture
export(String, MULTILINE) var dialog_line := "salut"

export(String, "visible", "hidden", "come_in", "come_out", "fade_in", "fade_out") var on_dialog_start := "visible"
export(String, "visible", "hidden", "come_in", "come_out", "fade_in", "fade_out") var on_dialog_end := "visible"

export(bool) var emit_a_signal_on_dialog_end := false
export(String) var signal_id := "dialog"

func get_actor_texture() -> Texture:
	return actor_texture

func get_dialog_line() -> String:
	return dialog_line

func does_signal_on_dialog_end() -> bool:
	return emit_a_signal_on_dialog_end

func get_signal_id() -> String:
	return signal_id

func get_start_animation() -> String:
	return on_dialog_start

func get_end_animation() -> String:
	return on_dialog_end