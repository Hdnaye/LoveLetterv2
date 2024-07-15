extends Node

var ip = "127.0.0.1"
var port = 4242
var players_connected = 0
var spawn_points = [
	Vector3(6.5, 2, -4),
	Vector3(6.5, 2, -12.5),
	Vector3(10.5, 2, -4),
	Vector3(10.5, 2, -12.5),
	Vector3(2.5, 2, -4),
	Vector3(2.5, 2, -12.5)
]
var players_node: Node = null
var enet_peer = ENetMultiplayerPeer.new()
const character = preload("res://scenes/player.tscn")

func _ready():
	print("World node ready")
	players_node = get_node("Players")
	if not players_node:
		print("Error: Players node not found")

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_host_button_pressed():
	print("Starting Hosting...")
	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())

func _on_join_button_pressed():
	print("Joining Server...")
	enet_peer.create_client(ip, port)
	multiplayer.multiplayer_peer = enet_peer

func add_player(id: int):
	print("Adding player: %s" % id)
	if players_node.has_node(str(id)):
		print("Player %s already exists" % id)
		return
	var player = character.instantiate()
	player.player = id
	player.name = str(id)
	var position_index = players_connected % spawn_points.size()
	player.transform.origin = spawn_points[position_index]
	players_connected += 1
	players_node.add_child(player, true)
	if (id != 1):
		player._set_position.rpc_id(id, spawn_points[position_index])

func del_player(id: int):
	if not players_node.has_node(str(id)):
		return
	players_node.get_node(str(id)).queue_free()
	players_connected -= 1

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)
