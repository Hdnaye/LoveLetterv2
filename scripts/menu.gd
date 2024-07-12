extends Control

func _ready():
	$HBoxContainer/Host.connect("pressed", Callable(self, "_on_HostServer_pressed"))
	$HBoxContainer/Join.connect("pressed", Callable(self, "_on_JoinServer_pressed"))

func _on_HostServer_pressed():
	print("HOST PRESSED")
	if !get_tree().root.has_node("world"):
		var main_scene = preload("res://scenes/world.tscn").instantiate()
		get_tree().root.add_child(main_scene)
		main_scene.name = "world"
		main_scene.start_hosting()
	get_tree().root.remove_child(self)

func _on_JoinServer_pressed():
	print("JOIN PRESSED")
	if !get_tree().root.has_node("world"):
		var main_scene = preload("res://scenes/world.tscn").instantiate()
		get_tree().root.add_child(main_scene)
		main_scene.name = "world"
		main_scene.join_server()
	get_tree().root.remove_child(self)
