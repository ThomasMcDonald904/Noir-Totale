extends Area3D

@export var repulsion_strength := 2
@export var inner_boost := 250.0   # strong snap near the center

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.has_method("apply_repulsion"):
			var to_body = body.global_position - global_position
			
			#var dist = to_body.length()
			var dir = to_body.normalized()

			## Non-linear falloff: weak far away, brutal up close
			#var strength = repulsion_strength / max(dist, 0.2)

			## Extra punch if very close
			#if dist < 1.5:
				#strength += inner_boost

			body.apply_repulsion(dir*repulsion_strength)
