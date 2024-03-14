#extends CharacterBody3D
#
#
#@onready var animated_sprite_3d = $AnimatedSprite3D
#
#
#@export var move_speed = 2.0
#@export var attack_range = 2.0
#
#@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
#var DEAD = false
#
#func _physics_process(delta):
	#if DEAD:
		#return
	#if player == null:
		#return
	#
	#var dir = player.global_position - global_position
	#dir.y = 0.0
	#dir = dir.normalized()
	#
	#velocity = dir * move_speed
	#move_and_slide()
#
#
#func kill():
	#DEAD = true
	#$Death.play()
	#animated_sprite_3d.play("dead")
	#$CollisionShape3D.disabled = true
