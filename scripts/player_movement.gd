extends CharacterBody3D

@export var SPEED = 1.0
var target_position: Vector3
var moving = false
var initial_position: Vector3
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
var next_path

func _unhandled_input(event: InputEvent):
	if event is InputEventMouse and Input.is_action_pressed("Walk"):
		var space_state = get_world_3d().direct_space_state
		var from = get_viewport().get_camera_3d().project_ray_origin(event.position)
		var to = from + get_viewport().get_camera_3d().project_ray_normal(event.position) * 1000
		var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to, 2))
		initial_position = position
		if result:
			target_position = result.position
			moving = true
		navigation_agent_3d.set_target_position(target_position)
		

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	next_path = navigation_agent_3d.get_next_path_position()
	if moving:
		velocity = global_position.direction_to(next_path) * SPEED
		print(position.direction_to(next_path))
		if position.distance_to(target_position) < 0.1:  # Parar ao chegar
			velocity = Vector3.ZERO
			moving = false
	move_and_slide()
