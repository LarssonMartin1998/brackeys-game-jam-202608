extends Node2D
@onready var main_menu: Node2D = $"."

var mute: bool=false


func _on_new_game_pressed() -> void:

	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_sound_pressed() -> void: #we can split this later into SFX and 
	var SFX_audio = AudioServer.get_bus_index("SFX")
	if mute == false:
		AudioServer.set_bus_mute(SFX_audio, true)
		mute = true
	else:
		AudioServer.set_bus_mute(SFX_audio, false)
		mute = false

func _on_dialogue_pressed() -> void:
	var dialogue_audio = AudioServer.get_bus_index("Dialogue")
	if mute == false:
		AudioServer.set_bus_mute(dialogue_audio, true)
		mute = true
	else:
		AudioServer.set_bus_mute(dialogue_audio, false)
		mute = false

func _on_continue_pressed() -> void:
	get_tree().paused = false
	hide()
