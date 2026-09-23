extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Buttons/QuitButton.pressed.connect(return_to_menu)

func return_to_menu() -> void:
	$Click.play(0.1)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_button_hovered() -> void:
	$Hover.play()
