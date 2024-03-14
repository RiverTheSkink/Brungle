extends CharacterBody3D

@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var navigation_agent_3d = $NavigationAgent3D
var projectile = preload("res://ENEMYTSCN/warriorprojectile.tscn")

var DEAD = false
var SPEED = 6
var HEALTH := 3
var ATTACKING := false
var collisionpoint

func _physics_process(_delta):
	collisionpoint = $RayCast3D.target_position
	if !DEAD and !ATTACKING:
		var current_location = global_position
		var next_location = navigation_agent_3d.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		velocity = new_velocity
		move_and_slide()

func update_target_location(target_location):
	navigation_agent_3d.set_target_position(target_location)
	$RayCast3D.target_position = to_local(target_location)


func kill():
	if HEALTH == 1:
		DEAD = true
		$AudioStreamPlayer3D.play()
		#animated_sprite_3d.play("dead")
		visible = false
		collision_layer = 0
		get_tree().call_group("level", "enemykilled")
		get_tree().call_group("warriorprojectile", "killed")
	else:
		HEALTH -= 1

func _on_navigation_agent_3d_target_reached():
	if !DEAD and !ATTACKING:
		ATTACKING = true
		$Timer.start()


func _on_timer_timeout():
	var projectileinst = projectile.instantiate()
	projectileinst.position = $Marker3D.position
	$RayCast3D.add_child(projectileinst)
	get_tree().call_group("warriorprojectile", "collisionpoint", collisionpoint)
	ATTACKING = false

