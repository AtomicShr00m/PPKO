extends Node2D

var roster:=[]
onready var cam = $Cam
onready var player = $Puncher
onready var enemy_loader = $EnemyLoader
onready var spawn_timer = $SpawnTimer

func _ready():
	randomize()
	setup_roster()

func setup_roster():
	var full_list=Array(enemy_loader.get_resource_list())
	full_list.shuffle()
	for n in 4:
		roster.append(full_list.pop_front())

func enemy_popped():
	if roster.empty():
		#win
		pass
	else:
		spawn_timer.start()

func spawn_enemy():
	var enemy_name=roster.pop_front()
	var enemy:Boomer=enemy_loader.get_resource(enemy_name).instance()
	enemy.position.x=rand_range(-320,320)
	while abs(player.position.x-enemy.position.x)<160:
		enemy.position.x=rand_range(-320,320)
	add_child(enemy)
	enemy.connect("popped",self,"enemy_popped")
	cam.enemy=enemy
	enemy.target=player
	player.target=enemy
