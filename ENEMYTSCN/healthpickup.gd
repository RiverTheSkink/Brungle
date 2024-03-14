extends AnimatedSprite3D



func _on_area_3d_body_entered(body):
	get_tree().call_group("player", "healthpickup")
	queue_free()
