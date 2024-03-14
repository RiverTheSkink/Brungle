extends Node3D

@onready var player = $Player
var CRAWL = preload("res://ENEMYTSCN/crawl.tscn")
var BAT = preload("res://ENEMYTSCN/bat.tscn")
var SILENT = preload("res://ENEMYTSCN/silent.tscn")
var AREA1 := true
var activearea1 := false
var AREA2 := true
var activearea2 := false
var AREA2_5 := true
var activearea2_5 := false
var AREA3 := true
var activearea3 := false
var enemies_killed: int = 0
var tempkills: int
var levelcomplete = preload("res://final_level.tscn").instantiate()



func enemykilled():
	print ("enemy killed!")
	enemies_killed += 1

func _physics_process(_delta):
	get_tree().call_group("enemies", "update_target_location", player.global_position)
	if activearea1 == true and (enemies_killed - tempkills) == 3:
		$enemyactivationzones/AREA1/arealock1.visible = false
		$enemyactivationzones/AREA1/arealock1/StaticBody3D.collision_layer = 0
		activearea1 = false
	if activearea2 == true and (enemies_killed - tempkills) == 3:
		$enemyactivationzones/AREA2/arealock2.visible = false
		$enemyactivationzones/AREA2/arealock2/StaticBody3D.collision_layer = 0
		activearea2 = false	
	if activearea2_5 == true and (enemies_killed - tempkills) == 3:
		$enemyactivationzones/AREA2_5/arealock2_5.visible = false
		$enemyactivationzones/AREA2_5/arealock2_5/StaticBody3D.collision_layer = 0

func _on_areaactivate_1_body_entered(_body):
	if AREA1:
		AREA1 = false
		tempkills = enemies_killed
		activearea1 = true
		$AudioStreamPlayer.play()
		$enemyactivationzones/AREA1/arealock1.visible = true
		crawlspawn($enemyactivationzones/AREA1/crawl1spawnpoint.global_position)
		crawlspawn($enemyactivationzones/AREA1/crawl2spawnpoint.global_position)
		crawlspawn($enemyactivationzones/AREA1/crawl3spawnpoint.global_position)

func _on_areaactivate_2_body_entered(_body):
	if AREA2:
		AREA2 = false
		tempkills = enemies_killed
		print (tempkills)
		activearea2 = true
		$AudioStreamPlayer.play()
		$enemyactivationzones/AREA2/arealock2.visible = true
		batspawn($enemyactivationzones/AREA2/batspawn1.global_position)
		batspawn($enemyactivationzones/AREA2/batspawn2.global_position)
		crawlspawn($enemyactivationzones/AREA2/crawlspawn1.global_position)

func _on_areaactivate_2_5_body_entered(_body):
	if AREA2_5:
		AREA2_5 = false
		tempkills = enemies_killed
		activearea2_5 = true
		$AudioStreamPlayer.play()
		$enemyactivationzones/AREA2_5/arealock2_5.visible = true
		$enemyactivationzones/AREA2_5/arealock2_5/StaticBody3D.collision_layer = 1
		crawlspawn($enemyactivationzones/AREA2_5/area2_5enemyspawn2.global_position)
		silentspawn($enemyactivationzones/AREA2_5/area2_5enemyspawn3.global_position)



func _on_areaactivate_3_body_entered(_body):
	if AREA3:
		AREA3 = false
		tempkills = enemies_killed
		activearea2 = true
		$AudioStreamPlayer.play()
		crawlspawn($enemy1.global_position)
		crawlspawn($enemy3.global_position)
		crawlspawn($enemy4.global_position)
		batspawn($enemy2.global_position)
		batspawn($enemy5.global_position)







func crawlspawn(crawlpos):
	var crawlinst = CRAWL.instantiate()
	crawlinst.position = crawlpos
	add_child(crawlinst)
func batspawn(batpos):
	var batinst = BAT.instantiate()
	batinst.position = batpos
	add_child(batinst)
func silentspawn(silentpos):
	var silentinst = SILENT.instantiate()
	silentinst.position = silentpos
	add_child(silentinst)

func _on_audio_stream_player_finished():
	$baseaudio.play()
	if activearea1 == true or activearea2 == true or activearea2_5 == true or activearea3 == true:
		$drums.play()


func _on_level_complete_body_entered(_body):
	get_tree().call_group("player", "levelcomplete1")
	$Timer.start()
func _on_timer_timeout():
	get_tree().change_scene_to_file("res://final_level.tscn")
