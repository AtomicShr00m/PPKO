extends Node2D

var draw_color:Color
var value:=100.0
export var size:=48

func _ready():
	modulate=Color.white
	draw_color=get_parent().self_modulate

func _draw():
	var angle:=TAU*(value/100)
	draw_arc(Vector2.ZERO,size,0,angle,int(size/2.0),draw_color,size/8.0,true)

func _physics_process(delta):
	if value!=get_parent().health:
		value=move_toward(value,get_parent().health,delta*50)
		update()
