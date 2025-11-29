extends Area2D

var dir:Vector2

const SPEED=600
const POWER=10
onready var particleScn=preload("res://Objects/Deco/HitParticles.tscn")

func bounce():
	dir*=-1
	collision_mask=0b110

func _physics_process(delta):
	position+=dir*SPEED*delta

func _on_Blast_body_entered(body:Node2D):
	var particles=particleScn.instance()
	particles.position=position
	particles.scale_amount*=scale.x
	particles.direction=-dir
	get_parent().add_child(particles)
	if body.is_in_group('hittables'):
		body.hit(POWER*scale.x,dir)
	queue_free()
