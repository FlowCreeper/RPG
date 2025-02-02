extends Node3D
var smooth_rotation: Vector3
var target_rotation = Vector3(0,0,0)
var current_rotation = Vector3(0,0,0)
@export var Speed = float(10)
var dir: Vector3
var velocity: Vector3
var cam_rotation = int(0) 

func  _ready() -> void:
	$Camera3D
func _process(delta: float) -> void:
	smooth_rotation = smooth_rotation.lerp(target_rotation, delta * 10)
	rotation = smooth_rotation
	velocity += Speed * dir * delta
	position = velocity
	
	
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("RotateCamL"):
		target_rotation.y = current_rotation.y + deg_to_rad(-90)
		current_rotation = target_rotation
		cam_rotation += -1
		if cam_rotation > 3 or cam_rotation < -3:
			cam_rotation = 0
		
		
	if Input.is_action_just_pressed("RotateCamR"):
		target_rotation.y = current_rotation.y + deg_to_rad(90)
		current_rotation = target_rotation
		cam_rotation += +1
		if cam_rotation > 3 or cam_rotation < -3:
			cam_rotation = 0
	if cam_rotation == 0:
		#360
		if Input.is_action_pressed("CamDown"):
			dir.x = -1 
		elif  Input.is_action_pressed("CamUp"):
			dir.x = 1 
		else:
			dir.x = 0 
		if Input.is_action_pressed("CamL"):
			dir.z = -1 
		elif  Input.is_action_pressed("CamR"):
			dir.z = 1 
		else:
			dir.z = 0 
	if cam_rotation == -1 or cam_rotation == 3: 
		if Input.is_action_pressed("CamDown"):
			dir.z = -1 
		elif  Input.is_action_pressed("CamUp"):
			dir.z = 1 
		else:
			dir.z = 0 
		if Input.is_action_pressed("CamL"):
			dir.x = 1 
		elif  Input.is_action_pressed("CamR"):
			dir.x = -1 
		else:
			dir.x = 0 
	if cam_rotation == -2 or cam_rotation == 2:
		if Input.is_action_pressed("CamDown"):
			dir.x = 1 
		elif  Input.is_action_pressed("CamUp"):
			dir.x = -1 
		else:
			dir.x = 0 
		if Input.is_action_pressed("CamL"):
			dir.z = 1 
		elif  Input.is_action_pressed("CamR"):
			dir.z = -1 
		else:
			dir.z = 0 
	if cam_rotation == -3 or cam_rotation == 1:
		if Input.is_action_pressed("CamDown"):
			dir.z = 1 
		elif  Input.is_action_pressed("CamUp"):
			dir.z = -1 
		else:
			dir.z = 0 
		if Input.is_action_pressed("CamL"):
			dir.x = -1 
		elif  Input.is_action_pressed("CamR"):
			dir.x = 1 
		else:
			dir.x = 0 
	if Input.is_action_just_pressed("ZoomIn"):
		
		
		if !$Camera3D.position.x > -0.75:
			$Camera3D.position.x += 0.05
			$Camera3D.position.y -= 0.05
		   
	if Input.is_action_just_pressed("ZoomOut"):
		if !$Camera3D.position.x < -1:
			$Camera3D.position.x -= 0.05
			$Camera3D.position.y += 0.05
