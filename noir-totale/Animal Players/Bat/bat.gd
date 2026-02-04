extends CharacterBody3D

@export var forward_speed := 5
@export var turn_speed := 3.0
@export var tilt_amount := 10

@export var flap_force := 2
@export var flap_cooldown := 0.18
@export var gravity_strength := 5
@export var max_vertical_speed := 10.0

var pulse_active := false
var pulse_radius := 0.0
@export var pulse_speed := 10.0
@export var pulse_max_radius := 15

var hunger := 100.0
@export var hunger_rate := 5.0
@export var hunger_gain := 20.0


var flap_timer := 0.0
var crashed := false

func _physics_process(delta):
	flap_timer -= delta

	hunger -= hunger_rate * delta
	hunger = clamp(hunger, 0, 100)

	if hunger <= 0:
		print("You starved")


	# --- MOUSE AIMING ---
	var viewport_center = get_viewport().size / 2.0
	var mouse = get_viewport().get_mouse_position()
	var offset = (mouse - viewport_center) / viewport_center

	var yaw_input = -offset.x
	var pitch_input = -offset.y

	rotation.y += yaw_input * turn_speed * delta
	rotation.x = lerp(rotation.x, pitch_input * 0.6, delta * 2.0)
	rotation.z = lerp(rotation.z, yaw_input * deg_to_rad(tilt_amount), delta * 3.0)

	# --- GRAVITY ALWAYS APPLIES ---
	velocity.y -= gravity_strength * delta
	velocity.y = clamp(velocity.y, -max_vertical_speed, max_vertical_speed)

	# --- FLAPPING (ALSO RECOVERS FROM CRASH) ---
	if Input.is_action_just_pressed("ui_accept") and flap_timer <= 0.0:
		flap_timer = flap_cooldown

		# FIX #2: recover from crash when flapping
		if crashed:
			crashed = false

		velocity.y = flap_force

	# --- FORWARD MOVEMENT ONLY IF NOT CRASHED ---
	if not crashed:
		var forward_dir = -transform.basis.z
		velocity.x = forward_dir.x * forward_speed
		velocity.z = forward_dir.z * forward_speed
	else:
		# Smooth stop instead of freezing
		velocity.x = lerp(velocity.x, 0.0, delta * 5.0)
		velocity.z = lerp(velocity.z, 0.0, delta * 5.0)

	move_and_slide()

	# --- COLLISION DETECTION ---
	var collision = get_last_slide_collision()
	if collision:
		_on_hit_obstacle(collision)
	
	# --- ECHOLOCATION ---
	if Input.is_action_just_pressed("mouse_right") and not pulse_active:
		pulse_active = true
		pulse_radius = 0.8
		$EcholocationPulse.visible = true

	if pulse_active:
		pulse_radius += pulse_speed * delta
		$EcholocationPulse.scale = Vector3.ONE * pulse_radius

		# reveal insects inside radius
		for insect in get_tree().get_nodes_in_group("insects"):
			if insect.global_position.distance_to(global_position) < pulse_radius:
				if insect.has_method("reveal"):
					insect.reveal()

		if pulse_radius >= pulse_max_radius:
			pulse_active = false
			$EcholocationPulse.visible = false


func _on_hit_obstacle(_collision):
	crashed = true
	velocity *= 0.01

func eat_insect():
	$Node/EatingSound.play()
	hunger += hunger_gain
	hunger = clamp(hunger, 0, 100)
	print("Ate insect! Hunger:", hunger)
