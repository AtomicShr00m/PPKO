extends Control

onready var main_menu = $MainMenu
onready var help_menu = $HelpMenu

func _on_PlayButton_pressed():
	AudioManager.play_sound('UI')
	get_tree().change_scene("res://Rooms/Stage.tscn")

func _on_HelpButton_pressed():
	AudioManager.play_sound('UI')
	main_menu.hide()
	help_menu.show()

func _on_QuitButton_pressed():
	AudioManager.play_sound('UI')
	get_tree().quit()

func _on_ReturnButton_pressed():
	AudioManager.play_sound('UI')
	help_menu.hide()
	main_menu.show()
