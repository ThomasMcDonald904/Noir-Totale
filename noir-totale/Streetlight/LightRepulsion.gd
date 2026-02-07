extends Area3D

@export var repulsion_strength := 2
@export var inner_boost := 250.0   # strong snap near the center

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.has_method("apply_repulsion_reversal"):
			var to_body = body.global_position - global_position
			var dir = to_body.normalized()
			body.apply_repulsion_reversal(dir)
			
			
