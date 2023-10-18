extends Node

@export var player_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = player_scene.instantiate()
	player.position = Vector3(0, 0, 0)
	add_child(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restart():
	get_tree().reload_current_scene()
