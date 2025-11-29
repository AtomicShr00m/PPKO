extends CPUParticles2D


func _ready():
	emitting=true
	var timer=create_tween().tween_interval(lifetime)
	yield(timer,"finished")
	queue_free()
