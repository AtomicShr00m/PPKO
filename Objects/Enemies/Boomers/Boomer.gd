extends KinematicBody2D
class_name Boomer

#White-Regular,Pink-Shrinker,Blue-Freezer,Yellow-Superforce,Green-Drain,cyan-StopsDashes

var atk_num:=1
var health:=100.0
var motion:Vector2

const SPEED=200.0
const FRICTION=7.0
const ACCEL=10.0

var target:Node2D
var is_safe:=false
export var blastScn : PackedScene
onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var health_bar = $HealthBar
onready var blast_spawn = $Sprite/BlastSpawn
onready var popParticles = preload("res://Objects/Deco/HitParticles.tscn")
onready var cover_sprite = $CoverSprite

signal popped

func pop():
	emit_signal("popped")
	var particles=popParticles.instance()
	particles.lifetime=1
	particles.initial_velocity*=2
	particles.position=global_position
	particles.spread=180
	particles.color=self_modulate
	particles.scale_amount=10
	get_parent().add_child(particles)

func _ready():
	choose_shot()

func shoot(charged:=false):
	for n in atk_num:
		var blast=blastScn.instance()
		blast.position=blast_spawn.global_position
		var aim=Vector2.RIGHT.rotated(sprite.rotation)
		var turn=n-int(atk_num/2.0)
		blast.dir=aim.rotated(turn * (PI/8))
		blast.scale=Vector2.ONE*(int(charged) + 1)
		get_parent().add_child(blast)

func hit(dmg,from):
	if !is_safe:
		health-=dmg
		if health<=0:
			pop()
			queue_free()
		else:
			is_safe=true
			motion=from*500
			var tween=create_tween()
			tween.tween_property(cover_sprite,"modulate:a",1.0,0.1)
			tween.tween_property(cover_sprite,"modulate:a",0.0,0.1)
			yield(tween,"finished")
			is_safe=false

func _physics_process(delta):
	var dir:=Vector2.ZERO
	if is_instance_valid(target):
		if anim.is_playing():
			sprite.look_at(target.position)
	elif dir!=Vector2.ZERO:
		sprite.rotation=dir.angle()
	if dir==Vector2.ZERO:
		motion=lerp(motion,Vector2.ZERO,FRICTION*delta)
	else:
		motion=lerp(motion,dir*SPEED,ACCEL*delta)
	motion=move_and_slide(motion)

func choose_shot():
	anim.play("RESET")
	yield(create_tween().tween_interval(1),"finished")
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
