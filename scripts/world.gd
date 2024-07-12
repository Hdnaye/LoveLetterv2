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

func _ready():
	print("World node ready")
	players_node = get_node("Players")
	if not players_node:
		print("Error: Players node not found")
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

func start_hosting():
	print("Starting Hosting...")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	add_player(multiplayer.get_unique_id())

func join_server():
	print("Joining Server...")
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)

func add_player(id: int):
	print("add player: %s" % id)
	if not players_node:
		print("Players node not found")
		return
	var character = preload("res://scenes/player.tscn").instantiate()
	character.player = id
	character.name = str(id)

	var position_index = players_connected % spawn_points.size()
	character.transform.origin = spawn_points[position_index]
	players_connected += 1

	players_node.add_child(character, true)

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
