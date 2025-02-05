extends CharacterBody3D
@export var SPEED = 1.0
var target_position: Vector3
var moving = false
var initial_position: Vector3
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
var next_path 
var mouse_click
@onready var camera = get_tree().get_current_scene().get_node("Gymbal").get_child(0)
var ray_origin
var ray_end
var space_state
var from
var to
var result
@export var player_id := 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

	
func apply_input(event):
	
	if event is InputEventMouse and get_node("InputSynchronizer").mouse:
		
		space_state = get_world_3d().direct_space_state
		
		from = camera.project_ray_origin(event.position)
		#print(from)
		to = from + camera.project_ray_normal(event.position) * 1000
		#print(to)
		result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to, 2))
		#print(result)
		initial_position = position
		
		if result:
			target_position = result.position
			moving = true
			
		navigation_agent_3d.set_target_position(target_position)
	mouse_click = false
func apply_movement(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	next_path = navigation_agent_3d.get_next_path_position()
	if moving and is_on_floor():
		velocity = global_position.direction_to(next_path) * SPEED
		#print(player_id)
		if position.distance_to(target_position) < 0.1:  # Parar ao chegar
			velocity = Vector3.ZERO
			moving = false
	move_and_slide()
	
func _unhandled_input(event: InputEvent):
	if multiplayer.is_server():
		apply_input(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		apply_movement(delta)
