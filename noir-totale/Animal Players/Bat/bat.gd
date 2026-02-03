extends CharacterBody3D

@export var forward_speed := 12.0
@export var turn_speed := 3.0
@export var tilt_amount := 20.0

@export var flap_force := 14.0        # much stronger upward burst
@export var flap_cooldown := 0.18     # faster, more rhythmic flaps
@export var gravity_strength := 22.0  # strong downward pull
@export var max_vertical_speed := 10.0

var flap_timer := 0.0

func _physics_process(delta):
	flap_timer -= delta

	# --- MOUSE AIMING ---
	var viewport_center = get_viewport().size / 2.0
	var mouse = get_viewport().get_mouse_position()
	var offset = (mouse - viewport_center) / viewport_center

	var yaw_input = -offset.x
	var pitch_input = -offset.y

	rotation.y += yaw_input * turn_speed * delta
	rotation.x = lerp(rotation.x, pitch_input * 0.3, delta * 2.0)
	rotation.z = lerp(rotation.z, yaw_input * deg_to_rad(tilt_amount), delta * 3.0)

	# --- GRAVITY ---
	velocity.y -= gravity_strength * delta

	# --- FLAPPING ---
	if Input.is_action_just_pressed("ui_accept") and flap_timer <= 0.0:
		flap_timer = flap_cooldown
		velocity.y = flap_force   # instant upward punch

	# clamp vertical speed
	velocity.y = clamp(velocity.y, -max_vertical_speed, max_vertical_speed)

	# --- CONSTANT FORWARD MOVEMENT ---
	var forward_dir = -transform.basis.z
	velocity.x = forward_dir.x * forward_speed
	velocity.z = forward_dir.z * forward_speed

	move_and_slide() 
