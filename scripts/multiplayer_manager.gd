extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"
var multiplayer_scene = preload("res://scenes/Multiplayer_Player.tscn") 
var _player_spawn_node: Node3D
func become_host():
	print("hosting")
	
	_player_spawn_node = get_tree().get_current_scene().get_node("Players")
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	remove_singleplayer()
	
	_add_player_to_game(1)
func join_game():
	print("joining")
	
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	
	multiplayer.multiplayer_peer = client_peer
	remove_singleplayer()
	
func _add_player_to_game(id: int):
	print("Player %s has connected" % id)
	
	var player_to_add = multiplayer_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	
	_player_spawn_node.add_child(player_to_add, true)
func _del_player(id: int):
	print("Player %s has disconnected" % id)
	if not _player_spawn_node.has_node(str(id)):
		print("ID %s not found" % id)
		return
	_player_spawn_node.get_node(str(id)).queue_free()
	
func remove_singleplayer():
	print("Singleplayer Removed")
	var player_to_remove = get_tree().get_current_scene().get_node("Player")
	player_to_remove.queue_free()
