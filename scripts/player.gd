extends Node3D

@export var player: int:
	set(id):
		player = id
@onready var camera = $Camera3D

var rotation_speed := 0.005

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * rotation_speed)
		camera.rotate_x(-event.relative.y * rotation_speed)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

@rpc("any_peer", "call_remote", "reliable")
func _set_position(pos):
	print_server("position set")
	position = pos
	
func print_server(msg):
	print("SERVER: " + msg)
