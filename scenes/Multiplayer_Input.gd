extends MultiplayerSynchronizer

var mouse: bool
var id: int

@onready var player = $".."

func _ready() -> void:
	id = multiplayer.get_unique_id()
	
	if get_multiplayer_authority() != id:
		set_process_unhandled_input(false)
		set_physics_process(false)
		set_process(false)
		return  # Exit early if not the authority

	mouse = Input.is_action_pressed("Walk")

func _unhandled_input(event: InputEvent) -> void:
	player.navigation_agent_3d.set_target_position(player.target_position)

func _physics_process(delta: float) -> void:
	mouse = Input.is_action_pressed("Walk")
	
	if id != 1:
		print(id)

func _process(delta: float) -> void:
	pass
