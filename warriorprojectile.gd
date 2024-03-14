extends RigidBody3D
var direction
var dead := false
func collisionpoint(collisionpoint):
	direction = collisionpoint.normalized()

func _ready():
	$Timer.start()

func _on_timer_timeout():
	linear_velocity = (direction * 15)

func killed():
	dead = true


func _on_area_3d_body_entered(body):
	if dead:
		queue_free()
		return
	if body.is_in_group("player"):
		get_tree().call_group("player", "kill")
		queue_free()
	else:
		queue_free()
