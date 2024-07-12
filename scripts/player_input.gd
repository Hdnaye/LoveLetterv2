extends MultiplayerSynchronizer

@export var look_direction := Vector2.ZERO

func _ready():
	set_process(true)

func _process(delta):
	if multiplayer.get_unique_id() == multiplayer.get_multiplayer_authority():
		var direction = Vector2.ZERO
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
		if Input.is_action_pressed("ui_up"):
			direction.y -= 1
		if Input.is_action_pressed("ui_down"):
			direction.y += 1
		
		if direction != look_direction:
			look_direction = direction
			rpc("sync_look_direction", look_direction)

@rpc("any_peer")
func sync_look_direction(direction: Vector2):
	look_direction = direction
