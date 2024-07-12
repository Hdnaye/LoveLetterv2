extends MultiplayerSynchronizer

@export var state := {}

func _ready():
	if is_multiplayer_authority():
		set_process(true)
	else:
		set_process(false)

func _process(delta):
	# Capture the current state
	state["position"] = get_parent().transform.origin
	state["rotation"] = get_parent().rotation_degrees
	rpc("sync_state", state)

@rpc("any_peer")
func sync_state(new_state):
	if not is_multiplayer_authority():
		get_parent().transform.origin = new_state["position"]
		get_parent().rotation_degrees = new_state["rotation"]
