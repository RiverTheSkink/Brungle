extends RayCast3D
@onready var laser = $"."
@onready var mesh_instance_3d = $MeshInstance3D

func _process(_delta):
	
	var contactPoint
	force_raycast_update()
	
	if is_colliding():
		contactPoint = to_local(get_collision_point())
		mesh_instance_3d.mesh.height = contactPoint.y
		mesh_instance_3d.position.y = contactPoint.y/2
