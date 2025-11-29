extends Node2D

var value:=100.0
export var size:=48
export var theme:Color

func _draw():
	draw_arc(Vector2.ZERO,size,0,TAU*(value/100),int(size/2.0),theme,size/8.0,true)

func _physics_process(delta):
	if value!=get_parent().health:
		value=move_toward(value,get_parent().health,delta*50)
		update()
