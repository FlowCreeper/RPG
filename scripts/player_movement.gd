extends CharacterBody3D

@export var SPEED = 1.0
var target_position: Vector3
var moving = false

func _unhandled_input(event: InputEvent):
	if event is InputEventMouse and Input.is_action_pressed("Walk"):
		var space_state = get_world_3d().direct_space_state
		var from = get_viewport().get_camera_3d().project_ray_origin(event.position)
		var to = from + get_viewport().get_camera_3d().project_ray_normal(event.position) * 1000

		var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to, 2))

		if result:
			target_position = result.position
			moving = true

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if moving:
		var direction = (target_position - position).normalized()
		velocity = velocity.lerp(direction * SPEED, 0.1)  # Faz a velocidade mudar suavemente

		if position.distance_to(target_position) < 0.75:  # Parar ao chegar
			velocity = Vector3.ZERO
			moving = false

	move_and_slide()
