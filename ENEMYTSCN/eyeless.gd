extends CharacterBody3D

@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var navigation_agent_3d = $NavigationAgent3D


var DEAD = false
var SPEED = 9
var HEALTH := 3
var SWIPED := false


func _physics_process(_delta):
	if !DEAD and SWIPED == false:
		var current_location = global_position
		var next_location = navigation_agent_3d.target_position
		var new_velocity = (next_location - current_location).normalized() * SPEED
		velocity = new_velocity
		move_and_slide()
	elif !DEAD:
		var current_location = global_position
		var next_location = navigation_agent_3d.target_position
		var new_velocity = (next_location - current_location).normalized() * SPEED
		velocity.x = -(new_velocity.x)
		velocity.z = -(new_velocity.z)
		move_and_slide()

func update_target_location(target_location):
	navigation_agent_3d.set_target_position(target_location)
	if SWIPED:
		global_position.y = target_location.y


func kill():
	if HEALTH == 1:
		DEAD = true
		#$death.play()
		#animated_sprite_3d.play("dead")
		visible = false
		collision_layer = 0
		get_tree().call_group("level", "enemykilled")
		get_tree().call_group("player", "eyeregained")
	else:
		HEALTH -= 1

func _on_navigation_agent_3d_target_reached():
	if !DEAD:
		get_tree().call_group("player", "blindness")
		SPEED = 3
		SWIPED = true
