extends Line2D

var enabled:=true
export var length:=16

func _ready():
	set_as_toplevel(true)
	modulate=get_parent().self_modulate
	length*=get_parent().scale.x
	width*=get_parent().scale.x

func _physics_process(_delta):
	if enabled:
		add_point(get_parent().position)
	while get_point_count()>length:
		remove_point(0)
