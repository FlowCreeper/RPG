extends CharacterBody3D

@export var SPEED: float = 1.0
@export var player_id: int = 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)
@onready var camera: Camera3D = null
@export var target_position: Vector3
var moving: bool = false
var initial_position: Vector3
var next_path: Vector3
var mouse_click: bool
var result

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	if is_multiplayer_authority():
		camera = $Gymbal/Camera3D
	if multiplayer.get_unique_id() == player_id:
		$Gymbal/Camera3D.make_current()
	else:
		$Gymbal/Camera3D.set_process(false)
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
func ray_cast(event_position):
	var space_state = get_world_3d().direct_space_state
	var from = $Gymbal/Camera3D.project_ray_origin(event_position)
	var to = from + $Gymbal/Camera3D.project_ray_normal(event_position) * 1000
	result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to, 2))
@rpc("any_peer", "reliable") # Allows clients to send input to the server
func request_move(result) -> void:
	if  not multiplayer.is_server():
		return # Only the server should process movement
	if not camera:
		return
	#var space_state = get_world_3d().direct_space_state
	#var from: Vector3 = $/Gymbal/Camera3D.project_ray_origin(event_position)
	#var to: Vector3 = from + $/Gymbal/Camera3D.project_ray_normal(event_position) * 1000
	#var result: Dictionary = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to, 2))
	
	if result:
		target_position = result.position
		moving = true
		navigation_agent_3d.set_target_position(target_position)
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse and %InputSynchronizer.mouse:
		ray_cast(event.position)
		if multiplayer.is_server():
			request_move(result)
		else:
			request_move.rpc_id(1,result)  # Send input to the server

func _physics_process(delta: float) -> void:
	
	if multiplayer.is_server():
		apply_movement(delta)
