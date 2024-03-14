extends CharacterBody3D

var SPEED = 3.5
var ATTACKING := false
var KILLMODE := false
var DEAD := false
var ACTIVE := true

@onready var navigation_agent_3d = $NavigationAgent3D

func _physics_process(_delta):
	if DEAD:
		return
	if !ACTIVE:
		return
	else:
		$AnimatedSprite3D.visible = true
	var playerpos = get_tree().get_first_node_in_group("player").global_position
	if !ATTACKING:
		var current_location = global_position
		var next_location = navigation_agent_3d.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		if !navigation_agent_3d.is_target_reached():
			velocity = new_velocity
			move_and_slide()
	if ATTACKING:
		global_position.y -= (global_position.y - (playerpos.y - 5)) * 0.05
		global_position.x -= (global_position.x - playerpos.x) * 0.05
		global_position.z -= (global_position.z - playerpos.z) * 0.05
	if KILLMODE == true:
		get_tree().call_group("player", "kill")
func _on_area_3d_body_entered(body):
	print (body)
	if body.is_in_group("player"):
		KILLMODE = true

func update_target_location(target_location):
	navigation_agent_3d.set_target_position(target_location)
func _on_navigation_agent_3d_target_reached():
	ATTACKING = true

func kill():
	DEAD = true
	$AudioStreamPlayer3D.play()
	#$AnimatedSprite3D.play("dead")
	collision_layer = 0
	$AnimatedSprite3D.visible = false
	get_tree().call_group("level", "enemykilled")


