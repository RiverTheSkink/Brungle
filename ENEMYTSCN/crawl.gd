extends CharacterBody3D


@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var navigation_agent_3d = $NavigationAgent3D


var DEAD = false
var SPEED = 4.5
var ACTIVE := true
var HEALTH := 2


func _physics_process(_delta):
	if DEAD:
		return
	if !ACTIVE:
		return
	else:
		$AnimatedSprite3D.visible = true
	var current_location = global_position
	var next_location = navigation_agent_3d.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	navigation_agent_3d.set_velocity(new_velocity)
	


func update_target_location(target_location):
	navigation_agent_3d.set_target_position(target_location)
func kill():
	if !ACTIVE:
		return
	if HEALTH == 1:
		DEAD = true
		$death.play()
		animated_sprite_3d.play("dead")
		collision_layer = 0
		get_tree().call_group("level", "enemykilled")
		print ("crawl")
	else:
		HEALTH -= 1


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if DEAD:
		return
	if !ACTIVE:
		return
	velocity = velocity.move_toward(safe_velocity, 5)
	move_and_slide()


func _on_navigation_agent_3d_target_reached():
	if DEAD:
		return
	get_tree().call_group("player", "kill")
