extends Node3D

@export var player: int:
	set(id):
		player = id
		$PlayerInput.set_multiplayer_authority(id)
		$ServerSynchronizer.set_multiplayer_authority(id)

var rotation_speed := 0.1
var look_direction := Vector2.ZERO

func _ready():
	if is_multiplayer_authority():
		set_process(true)
	else:
		set_process(false)

	# Ensure camera is set to current for each player
	$Camera3D.current = true

func _process(delta):
	handle_input(delta)
	if multiplayer.is_server():
		# Call the RPC function on all peers
		rpc("send_look_direction", look_direction)

func handle_input(delta):
	look_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		look_direction.x -= rotation_speed * delta
	if Input.is_action_pressed("ui_right"):
		look_direction.x += rotation_speed * delta
	if Input.is_action_pressed("ui_up"):
		look_direction.y -= rotation_speed * delta
	if Input.is_action_pressed("ui_down"):
		look_direction.y += rotation_speed * delta

	rotate_y(look_direction.x)
	$Camera3D.rotate_x(look_direction.y)

@rpc("any_peer")
func send_look_direction(direction: Vector2):
	if not multiplayer.is_server():
		look_direction = direction
		rotate_y(look_direction.x)
		$Camera3D.rotate_x(look_direction.y)
