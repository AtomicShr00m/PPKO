extends Area2D

var dir:Vector2
export var power=10
export var effect:String

const SPEED=800
onready var particleScn=preload("res://Objects/Deco/HitParticles.tscn")
onready var sprite = $Sprite

func bounce():
	dir*=-1
	collision_mask=0b110

func _ready():
	sprite.rotation=dir.angle()

func _physics_process(delta):
	position+=dir*SPEED*delta

func _on_Blast_body_entered(body:Node2D):
	var particles=particleScn.instance()
	particles.position=position
	particles.color=modulate
	particles.scale_amount*=scale.x
	particles.direction=-dir
	get_parent().add_child(particles)
	if body.is_in_group('hittables'):
		body.hit(power*scale.x,dir,effect)
	queue_free()
