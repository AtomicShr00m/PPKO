extends Node2D

onready var cam = $Cam
onready var player = $Puncher

onready var boomerScn=preload("res://Objects/Enemies/Boomer.tscn")

func spawn_enemy():
	var enemy=boomerScn.instance()
	player.target=enemy
	cam.enemy=enemy
	enemy.position.x=rand_range(-320,320)
	enemy.target=player
	add_child(enemy)
