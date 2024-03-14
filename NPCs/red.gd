extends Node3D

var interactred := false
var dialoguestarted := false
func _on_area_3d_body_entered(_body):
	interactred = true
func _on_area_3d_body_exited(_body):
	interactred = false

func _process(_delta):
	if interactred == true and Input.is_action_just_pressed("interact") and dialoguestarted == false:
		dialoguestarted = true
		DialogueManager.show_example_dialogue_balloon(load("res://DIALOGUE/red.dialogue"), "start")
