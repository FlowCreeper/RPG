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
		 # Exit early if not the authority

	mouse = Input.is_action_pressed("Walk")

func _unhandled_input(_event: InputEvent) -> void:
	mouse = Input.is_action_pressed("Walk")


func _process(_delta: float) -> void:
	pass
