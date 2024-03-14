extends Node3D

var enemies_killed: int = 0
var tempkills: int
var CRAWL = preload("res://ENEMYTSCN/crawl.tscn")
var BAT = preload("res://ENEMYTSCN/bat.tscn")
var EYELESS = preload("res://ENEMYTSCN/eyeless.tscn")
var SILENT = preload("res://ENEMYTSCN/silent.tscn")
var WARRIOR = preload("res://ENEMYTSCN/warrior.tscn")

var AREA1 := true
var activearea1 := false
var AREA2 := true
var activearea2 := false
var AREA31 := true
var AREA32 := true
var activearea3 := false

@onready var player = $Player


func enemykilled():
	print ("enemy killed!")
	enemies_killed += 1


func _physics_process(_delta):
	get_tree().call_group("enemies", "update_target_location", player.global_position)
	if activearea1 == true and (enemies_killed - tempkills) == 10:
		print ("suck sess")
		$enemyactivationzones/area1.queue_free()
		activearea1 = false
	if activearea2 == true and (enemies_killed - tempkills) == 5:
		print ("guh")
		$enemyactivationzones/area2/area2lock1.queue_free()
		$enemyactivationzones/area2/area2lock2.queue_free()
		activearea2 = false




func _on_activatearea_1_body_entered(body):
	if AREA1:
		AREA1 = false
		tempkills = enemies_killed
		activearea1 = true
		$AudioStreamPlayer.play()
		$enemyactivationzones/area1/area1lock/StaticBody3D.collision_layer = 1
		$enemyactivationzones/area1/area1lock.visible = true
		crawlspawn($enemyactivationzones/area1/crawl1.global_position)
		crawlspawn($enemyactivationzones/area1/crawl3.global_position)
		crawlspawn($enemyactivationzones/area1/crawl4.global_position)
		crawlspawn($enemyactivationzones/area1/crawl5.global_position)
		crawlspawn($enemyactivationzones/area1/crawl6.global_position)
		batspawn($enemyactivationzones/area1/bat1.global_position)
		batspawn($enemyactivationzones/area1/bat2.global_position)
		warriorspawn($enemyactivationzones/area1/warrior1.global_position)
		warriorspawn($enemyactivationzones/area1/warrior2.global_position)
		eyelessspawn($enemyactivationzones/area1/eyeless.global_position)

func _on_activatearea_2_body_entered(body):
	if AREA2:
		AREA2 = false
		tempkills = enemies_killed
		activearea2 = true
		$AudioStreamPlayer.play()
		$enemyactivationzones/area2/area2lock1.visible = true
		$enemyactivationzones/area2/area2lock1/StaticBody3D.collision_layer = 1
		crawlspawn($enemyactivationzones/area2/crawl1.global_position)
		crawlspawn($enemyactivationzones/area2/crawl2.global_position)
		warriorspawn($enemyactivationzones/area2/warrior1.global_position)
		eyelessspawn($enemyactivationzones/area2/eyeless.global_position)
		silentspawn($enemyactivationzones/area2/silent.global_position)

func _on_activatearea_31_body_entered(body):
	if AREA31:
		eyelessspawn($enemyactivationzones/area3/Marker3D.global_position)
		AREA31 = false
		$AudioStreamPlayer.play()

func _on_area_3d_body_exited(body):
	if AREA32:
		AREA32 = false
		tempkills = enemies_killed
		activearea3 = true
		$AudioStreamPlayer.play()
		$enemyactivationzones/area3/area3lock.visible = true
		$enemyactivationzones/area3/area3lock/StaticBody3D.collision_layer = 1
		silentspawn($enemyactivationzones/area3/silent.global_position)
		crawlspawn($enemyactivationzones/area3/crawl1.global_position)
		warriorspawn($enemyactivationzones/area3/warrior1.global_position)
		warriorspawn($enemyactivationzones/area3/warrior2.global_position)
		batspawn($enemyactivationzones/area3/bat1.global_position)
		batspawn($enemyactivationzones/area3/bat2.global_position)







# all of my silly spawning scripts!
func crawlspawn(crawlpos):
	var crawlinst = CRAWL.instantiate()
	crawlinst.position = crawlpos
	add_child(crawlinst)
func batspawn(batpos):
	var batinst = BAT.instantiate()
	batinst.position = batpos
	add_child(batinst)
func eyelessspawn(eyelesspos):
	var eyelessinst = EYELESS.instantiate()
	eyelessinst.position = eyelesspos
	add_child(eyelessinst)
func silentspawn(silentpos):
	var silentinst = SILENT.instantiate()
	silentinst.position = silentpos
	add_child(silentinst)
func warriorspawn(warriorpos):
	var warriorinst = WARRIOR.instantiate()
	warriorinst.position = warriorpos
	add_child(warriorinst)

func _ready():
	get_tree().call_group("player", "movementupdate")













func _on_boing_body_entered(body):
	get_tree().call_group("player", "boing")
