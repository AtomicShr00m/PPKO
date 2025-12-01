extends Camera2D

var enemy:Node2D
onready var player = $"../Puncher"

func shake():
	var tweener=create_tween()
	tweener.tween_property(self,'offset:x',16.0,0.1)
	tweener.tween_property(self,'offset:x',-16.0,0.1)
	tweener.tween_property(self,'offset:x',0.0,0.1)

func _physics_process(delta):
	var zoom_value:=1.0
	if is_instance_valid(enemy):
		position.x=(player.position.x+enemy.position.x)/2.0
		var distance=abs(enemy.position.x-player.position.x)
		zoom_value=clamp(distance / 480.0,1,1.5)
	else:
		position.x=player.position.x
		zoom_value=clamp(abs(position.x) / 480,1.0,1.5)
	zoom=lerp(zoom,Vector2.ONE*zoom_value,10*delta)


func _on_Puncher_popped():
	set_physics_process(false)
