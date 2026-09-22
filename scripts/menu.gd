extends Control
## Main menu: start the game, adjust settings, or read the credits.

const GAME_SCENE := "res://scenes/main.tscn"

@onready var main_buttons: Control = $MainButtons
@onready var credits_panel: Control = $CreditsPanel


func _ready() -> void:
	_show_main()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_credits_pressed() -> void:
	_show(credits_panel)


func _on_back_pressed() -> void:
	_show_main()

func _show_main() -> void:
	main_buttons.show()
	credits_panel.hide()


func _show(panel: Control) -> void:
	main_buttons.hide()
	credits_panel.hide()
	panel.show()
