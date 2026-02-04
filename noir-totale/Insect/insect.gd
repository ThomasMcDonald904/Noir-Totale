extends Area3D

@export var wander_speed := 3
@export var wander_radius := 1

var direction := Vector3.ZERO
var center_position := Vector3.ZERO

func _ready():
	center_position = global_position
	_pick_new_direction()
	connect("body_entered", _on_body_entered)

func _physics_process(delta):
	translate(direction * wander_speed * delta)

	# keep insect near its spawn point
	if global_position.distance_to(center_position) > wander_radius:
		direction = (center_position - global_position).normalized()

	# random wandering
	if randf() < 0.01:
		_pick_new_direction()

func _pick_new_direction():
	direction = Vector3(
		randf_range(-1, 1),
		randf_range(-0.3, 0.3),
		randf_range(-1, 1)
	).normalized()

func _on_body_entered(body):
	if body.has_method("eat_insect"):
		body.eat_insect()
		queue_free()
		
func reveal():
	$MeshInstance3D.mesh.material.emission = Color(1, 1, 1)
	$MeshInstance3D.mesh.material.emission_energy_multiplier = 30

	# fade back after a moment
	await get_tree().create_timer(0.5).timeout
	$MeshInstance3D.mesh.material.emission = Color('a8a800')
	$MeshInstance3D.mesh.material.emission_energy_multiplier = 13
	
