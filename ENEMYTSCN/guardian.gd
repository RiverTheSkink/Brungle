extends CharacterBody3D

var HEALTH = 1

func kill():
	print ("dead")
	if HEALTH == 1:
		#$death.play()
		#animated_sprite_3d.play("dead")
		visible = false
		get_tree().call_group("player", "win")
	else:
		HEALTH -= 1
