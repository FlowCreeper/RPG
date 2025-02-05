extends CharacterBody3D

@export var SPEED: float = 1.0
@export var player_id: int = 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

var target_position: Vector3
var moving: bool = false
var initial_position: Vector3
var next_path: Vector3
var mouse_click: bool

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var camera: Camera3D = get_tree().get_current_scene().get_node("Gymbal").get_child(0)

func apply_movement(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	next_path = navigation_agent_3d.get_next_path_position()
	
	if moving and is_on_floor():
		velocity = global_position.direction_to(next_path) * SPEED
		
		if position.distance_to(target_position) < 0.1:  # Stop when close to target
			velocity = Vector3.ZERO
			moving = false
	
	move_and_slide()

@rpc("any_peer", "reliable") # Allows clients to send input to the server
func request_move(event_position: Vector2) -> void:
	if not multiplayer.is_server():
		return  # Only the server should process movement

	var space_state = get_world_3d().direct_space_state
	var from: Vector3 = camera.project_ray_origin(event_position)
	var to: Vector3 = from + camera.project_ray_normal(event_position) * 1000
	var result: Dictionary = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to, 2))

	if result:
		target_position = result.position
		moving = true
		navigation_agent_3d.set_target_position(target_position)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		if multiplayer.is_server():
			request_move(event.position)
		else:
			request_move.rpc_id(1, event.position)  # Send input to the server

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		apply_movement(delta)
