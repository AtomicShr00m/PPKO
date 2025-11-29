extends Node2D

onready var cam = $Cam
onready var player = $Puncher

onready var boomerScn=preload("res://Objects/Enemies/Boomer.tscn")

func _ready():
	randomize()

func spawn_enemy():
	var enemy=boomerScn.instance()
	enemy.position.x=rand_range(-320,320)
	while abs(player.position.x-enemy.position.x)<160:
		enemy.position.x=rand_range(-320,320)
	add_child(enemy)
	cam.enemy=enemy
	enemy.target=player
	player.target=enemy
