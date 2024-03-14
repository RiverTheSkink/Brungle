extends CharacterBody3D


var SPEED = 6.0
var JUMP_VELOCITY = 5.5
var SENSITIVITY = 0.01
var gravity = 9.8
var CANSHOOT := true
var DEAD := false
var HEALTH := 3
var IFRAMES := false
var WEAPON := "clawarm"
var CLAWRANGE := []
var triplejump := 0
var lvl2 := false
var menuopen := false

@onready var neck = $Neck
@onready var camera = $Neck/Camera3D
@onready var claw = $Neck/Camera3D/CanvasLayer/Claw/AnimatedSprite2D
@onready var raycast = $Neck/Camera3D/RayCast3D
@onready var clawsound = $Neck/Camera3D/CanvasLayer/Claw/clawgrab

func _ready():
	print ("ready")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	claw.animation_finished.connect(anim_done)
func _unhandled_input(event):
	if DEAD:
		return
	if event is InputEventMouseMotion:
		neck.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _physics_process(delta):
	if DEAD:
		return
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if lvl2:
			triplejump = 3
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif triplejump > 1:
			velocity.y = JUMP_VELOCITY
			triplejump -= 1
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0


func _process(_delta):
	move_and_slide()
	if Input.is_action_just_pressed("restart"):
		restart()
		kill()
	if Input.is_action_just_pressed("menu"):
		if menuopen == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			menuopen = true
			$Neck/Camera3D/CanvasLayer/menu.visible = true
		else:
			menuopen = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$Neck/Camera3D/CanvasLayer/menu.visible = false
	if DEAD:
		return
	if Input.is_action_just_pressed("shoot"):
		shoot()


func shoot():
	if !CANSHOOT:
		return
	CANSHOOT = false
	if WEAPON == "clawarm":
		claw.play("shoot")
		clawsound.play()
		if raycast.is_colliding() and raycast.get_collider().has_method("kill") and CLAWRANGE.has(raycast.get_collider()):
			print (raycast.get_collider())
			raycast.get_collider().kill()
			$AudioStreamPlayer.play()
			$Neck/Camera3D/CanvasLayer/AnimatedSprite2D.play("hit")
			$Neck/Camera3D/CanvasLayer/AnimatedSprite2D/hitmarker.start()

func anim_done():
	CANSHOOT = true
func restart():
	get_tree().reload_current_scene()
func _on_area_3d_body_entered(body):
	print (body)
	CLAWRANGE.append(body)
func _on_area_3d_body_exited(body):
	CLAWRANGE.erase(body)


func kill():
	if IFRAMES:
		return
	if HEALTH == 1 and !DEAD:
		DEAD = true
		$"Neck/Camera3D/CanvasLayer/Death Screen".show()
		$Neck/Camera3D/CanvasLayer/health.hide()
		$AudioStreamPlayer4.play()
	else:
		IFRAMES = true
		HEALTH -= 1
		print ("damage taken")
		$Timer.start()
		if HEALTH == 2:
			$Neck/Camera3D/CanvasLayer/health.play("idle2health")
		if HEALTH == 1:
			$Neck/Camera3D/CanvasLayer/health.play("idle1health")
func _on_timer_timeout():
	IFRAMES = false
	$Neck/Camera3D/CanvasLayer/Claw/RichTextLabel.visible = false


func silentmarked():
	$Neck/Camera3D/CanvasLayer/marked.show()
	$marked.start()
func _on_marked_timeout():
	$Neck/Camera3D/CanvasLayer/marked.hide()

func levelcomplete1():
	velocity.y = 100

func blindness():
	$Neck/Camera3D/CanvasLayer/blindness.visible = true
func eyeregained():
	$Neck/Camera3D/CanvasLayer/blindness.visible = false

func movementupdate():
	SPEED = 9.0
	JUMP_VELOCITY = 7.5
	gravity = 15
	lvl2 = true
	$Neck/Camera3D/CanvasLayer/Claw/RichTextLabel.visible = true
	$Timer.start()
	$AudioStreamPlayer3.play()

func healthpickup():
	$Neck/Camera3D/CanvasLayer/health.play("idle")
	HEALTH = 3

func boing():
	velocity.y = 50

func win():
	$AudioStreamPlayer2.play()
	$AudioStreamPlayer3.queue_free()
	$Neck/Camera3D/CanvasLayer/RichTextLabel.visible = true


func _on_hitmarker_timeout():
	$Neck/Camera3D/CanvasLayer/AnimatedSprite2D.play("default")
