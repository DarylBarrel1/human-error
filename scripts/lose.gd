extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Buttons/RetryButton.pressed.connect(retry)
	$Buttons/QuitButton.pressed.connect(return_to_menu)

func retry() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func return_to_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
