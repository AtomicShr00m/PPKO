extends Node2D

var value:=100.0
export var size:=48
export var theme:Color
var val_tween:SceneTreeTween

func _draw():
	draw_arc(Vector2.ZERO,size,0,TAU*(value/100),int(size/2.0),theme,size/8.0,true)

func update_value(new_val):
	var tween=create_tween()
	val_tween=tween
	tween.tween_property(self,"value",new_val,0.5).set_trans(Tween.TRANS_BOUNCE)

func _physics_process(_delta):
	if is_instance_valid(val_tween):
		update()
