extends Sprite3D

var closenough := false

func _on_area_3d_body_entered(body):
	closenough = true
func _on_area_3d_body_exited(body):
	closenough = false

func _physics_process(_delta):
	if Input.is_action_just_pressed("interact") and closenough == true:
		$"../MeshInstance3D/StaticBody3D".collision_layer = 1
		$"../MeshInstance3D".visible = true
		queue_free()
