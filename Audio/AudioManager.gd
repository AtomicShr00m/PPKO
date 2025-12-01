extends Node

onready var soundScn=preload("res://Audio/SoundPlayer.tscn")

func play_sound(sound:String,vol:=1.0):
	var player=soundScn.instance()
	player.volume_db=linear2db(vol)
	player.stream=load("res://Audio/"+sound+".wav")
	add_child(player)
