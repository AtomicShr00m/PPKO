extends Node2D

var roster:=['White']
const POWERUPS=['dash','regen','defence','shield','speed','strength']
onready var cam = $Cam
onready var player = $Puncher
onready var enemy_loader = $EnemyLoader
onready var spawn_timer = $SpawnTimer
onready var powerupScn = preload("res://Objects/Powerups/Powerup.tscn")

func _ready():
	randomize()
	setup_roster()

func setup_roster():
	var full_list=Array(enemy_loader.get_resource_list())
	full_list.erase('White')
	full_list.shuffle()
	for n in 3:
		roster.append(full_list.pop_front())

func enemy_popped():
	player.effect_manager.end_effect()
	if roster.empty():
		#win
		pass
	else:
		spawn_powerups()

func clear_powerups():
	for obj in get_tree().get_nodes_in_group("powerups"):
		obj.close()
	yield(create_tween().tween_interval(1.0),"finished")
	spawn_enemy()

func spawn_powerups():
	var spawned:=[]
	var manager=player.powerup_manager
	for n in 3:
		var powerup=powerupScn.instance()
		powerup.position.x=(n-1)*128
		powerup.type=POWERUPS.pick_random()
		powerup.connect("popped",self,'clear_powerups')
		while spawned.has(powerup.type) or manager.powers.has(powerup.type):
			powerup.type=POWERUPS.pick_random()
		call_deferred("add_child",powerup)
		spawned.append(powerup.type)

func spawn_enemy():
	var enemy_name=roster.pop_front()
	var enemy:Boomer=enemy_loader.get_resource(enemy_name).instance()
	enemy.atk_num=1+2*(3-roster.size())
	enemy.position.x=rand_range(-320,320)
	while abs(player.position.x-enemy.position.x)<160:
		enemy.position.x=rand_range(-320,320)
	add_child(enemy)
	enemy.connect("popped",self,"enemy_popped")
	cam.enemy=enemy
	enemy.target=player
	player.target=enemy
