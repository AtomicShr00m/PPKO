extends Area2D

var dir:Vector2

const SPEED=600
export var power:=5.0

func bounce():
	dir*=-1
	collision_mask=0b110

func _physics_process(delta):
	position+=dir*SPEED*delta

func _on_Blast_body_entered(body:Node2D):
	if body.is_in_group('hittables'):
		body.hit(power,dir)
	queue_free()
