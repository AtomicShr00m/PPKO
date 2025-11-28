extends KinematicBody2D

var health:=100.0
var motion:Vector2

const SPEED=200.0
const FRICTION=7.0
const ACCEL=10.0

var target:Node2D
onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var blast_spawn = $Sprite/BlastSpawn
onready var blastScn = preload("res://Objects/Enemies/Blast.tscn")

func _ready():
	choose_shot()

func shoot(charged:=false):
	for n in 4:
		var blast=blastScn.instance()
		blast.position=blast_spawn.global_position
		blast.dir=Vector2(1,0).rotated(sprite.rotation).rotated(rand_range(-PI/4,PI/4))
		blast.scale=Vector2.ONE*(int(charged) + 1)
		get_parent().add_child(blast)

func hit(dmg,from):
	health-=dmg
	if health<=0:
		queue_free()
	motion=from*400

func _physics_process(delta):
	var dir:=Vector2.ZERO
	if is_instance_valid(target):
		sprite.look_at(target.position)
	elif dir!=Vector2.ZERO:
		sprite.rotation=dir.angle()
	if dir==Vector2.ZERO:
		motion=lerp(motion,Vector2.ZERO,FRICTION*delta)
	else:
		motion=lerp(motion,dir*SPEED,ACCEL*delta)
	motion=move_and_slide(motion)

func choose_shot():
	anim.play(["Regular","Triple","Charged"].pick_random())

func _on_shoot_animation_finished(anim_name):
	match anim_name:
		'Regular':
			shoot()
			choose_shot()
		'Triple':
			var timer=create_tween().set_loops(3)
			timer.tween_callback(self,"shoot").set_delay(0.2)
			yield(timer,"finished")
			choose_shot()
		'Charged':
			shoot(true)
			choose_shot()
