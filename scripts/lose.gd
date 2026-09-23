extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Buttons/RetryButton.pressed.connect(retry)
	$Buttons/QuitButton.pressed.connect(return_to_menu)

func retry() -> void:
	$Fade.color.a = 0.0
	$Click.play(0.1)
	await create_tween().tween_property($Fade, "color:a", 1.0, 0.5).finished
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func return_to_menu() -> void:
	$Click.play(0.1)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_button_hovered() -> void:
	$Hover.play()
