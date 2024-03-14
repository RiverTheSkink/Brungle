extends CharacterBody3D

var DEAD := false
@onready var raycast = $laser
var READY := true
var ATTACKPHASE := false

func _physics_process(_delta):
	if DEAD:
		return
	var playerpos = get_tree().get_first_node_in_group("player").global_position
	playerpos.y -= 3
	if !READY:
		return
	look_at(playerpos)
	if ATTACKPHASE:
		return
	if raycast.is_colliding() and raycast.get_collider().is_in_group("player"):
		ATTACKPHASE = true
		get_tree().call_group("player", "silentmarked")
		$abouttofire.start()

func _on_abouttofire_timeout():
	if raycast.is_colliding() and raycast.get_collider().is_in_group("player") and !DEAD:
		READY = false
		get_tree().call_group("player", "kill")
		$Timer.start()
	else:
		ATTACKPHASE = false
func _on_timer_timeout():
	READY = true
	ATTACKPHASE = false
func kill():
	DEAD = true
	$deathsound.play()
	#$AnimatedSprite3D.play("dead")
	$AnimatedSprite3D.visible = false
	$laser.visible = false
	$CollisionShape3D.disabled = true
	get_tree().call_group("level", "enemykilled")
	queue_free()
