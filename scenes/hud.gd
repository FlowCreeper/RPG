extends CanvasLayer


func host_game():
	MultiplayerManager.become_host()
	$MarginContainer/VBoxContainer/HBoxContainer.visible = false
func join_game():
	MultiplayerManager.join_game()
	$MarginContainer/VBoxContainer/HBoxContainer.visible = false
