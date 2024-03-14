extends RayCast3D

func _process(_delta):
	look_at(get_node("/root/Level/Player").global_position)
	#print (get_collider())
	print (get_node("/root/Level/Player"))
