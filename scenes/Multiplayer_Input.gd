extends MultiplayerSynchronizer
var mouse
var id
@onready var player = $".."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process_unhandled_input(false)
		set_physics_process(false)
		set_process(false)
		
	mouse = Input.is_action_pressed("Walk")
	id = multiplayer.get_unique_id()


func _unhandled_input(event: InputEvent) -> void:
	player.navigation_agent_3d.set_target_position(player.target_position)

	
func _physics_process(delta: float) -> void:
	mouse = Input.is_action_pressed("Walk")
	id = multiplayer.get_unique_id()
	if id != 1:
		print(id)
func _process(delta: float) -> void:
	pass
