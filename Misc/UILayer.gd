extends CanvasLayer

onready var game_timer := $"../GameTimer"

onready var timer_label := $HUD/VBoxContainer/TimerLabel
onready var battle_label := $HUD/VBoxContainer/BattleLabel
onready var powerups = $HUD/VBoxContainer/Powerups
onready var hud = $HUD
onready var pause_menu = $PauseMenu
onready var help_menu = $PauseMenu/HelpMenu
onready var pause_main = $PauseMenu/PauseMain
onready var over_label = $EndMenu/MarginContainer/VBoxContainer/OverLabel
onready var time_label = $EndMenu/MarginContainer/VBoxContainer/TimeLabel
onready var end_menu = $EndMenu

func gameover(lost):
	var time_spent=game_timer.wait_time-game_timer.time_left
	game_timer.stop()
	var mins:=int(time_spent/60)
	var secs:=int(time_spent)%60
	if lost:
		over_label.text='Defeat'
		time_label.text="You lost in "+str(mins)+" minutes and "+str(secs)+" seconds."
	else:
		over_label.text='Victory'
		time_label.text="You won in "+str(mins)+" minutes and "+str(secs)+" seconds."
	hud.hide()
	end_menu.show()

func update_battle(value):
	battle_label.text="Battle: "+str(value)+" / 4"

func update_powerups(type):
	for child in powerups.get_children():
		if !child.visible:
			child.texture=load("res://Sprites/Powerups/"+type+".png")
			child.show()
			break

func _physics_process(_delta):
	if Input.is_action_just_pressed("pause"):
		hud.hide()
		pause_menu.show()
		get_tree().paused=true
	if !game_timer.is_stopped():
		var mins:=int(game_timer.time_left/60)
		var secs:=int(game_timer.time_left)%60
		timer_label.text=str(mins)+' : '+str(secs)

func _on_ContinueButton_pressed():
	AudioManager.play_sound("UI")
	pause_menu.hide()
	hud.show()
	get_tree().paused=false

func _on_RestartButton_pressed():
	AudioManager.play_sound("UI")
	get_tree().paused=false
	get_tree().reload_current_scene()

func _on_HelpButton_pressed():
	AudioManager.play_sound("UI")
	pause_main.hide()
	help_menu.show()

func _on_HomeButton_pressed():
	AudioManager.play_sound("UI")
	get_tree().paused=false
	get_tree().change_scene("res://Rooms/Home.tscn")

func _on_ReturnButton_pressed():
	AudioManager.play_sound("UI")
	pause_main.show()
	help_menu.hide()
