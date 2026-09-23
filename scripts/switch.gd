extends Node2D


signal facing_emit(facing)

@onready var steps = [$StepLth1, $StepLth2, $StepLth3, $StepLth4]
@onready var jumpscare = $Jumpscare
@onready var researcher = $Researcher
@onready var background = $Background

var facing: Node2D
var opposite: Node2D

var timer = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jumpscare.visible = false
	facing = $Monitor
	$Monitor.visible = true
	$Doors.visible = false
	$Fade.color.a = 1.0
	await get_tree().create_timer(0.5).timeout 
	researcher.play()
	background.play()
	create_tween().tween_property($Fade, "color:a", 0.0, 2.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Doors.zap_flickering > 0:
		return

	timer -= delta
	if timer <= 0.0:
		timer = randf_range(5, 20)
		if $Doors.monster_stage < 3:
			# TODO: PLAY MONSTER AUDIO HERE
			if $Doors.monster_door == 0:
				$Doors.monster_door = randi_range(1, 3)
			$Doors.monster_stage += 1
		else:
			game_over()
			
func game_over() -> void:
	set_process(false)
	jumpscare.visible = true
	var starting_position = jumpscare.position
	Jumpscare.jumpscare()
	
	for i in range(32):
		jumpscare.position = starting_position + Vector2(randf_range(-28, 28), randf_range(-15, 15))
		await get_tree().create_timer(0.05).timeout
	
	jumpscare.position = starting_position
	await get_tree().create_timer(0.35).timeout
	
	get_tree().change_scene_to_file("res://scenes/lose.tscn")

func game_win() -> void:
	get_tree().change_scene_to_file("res://scenes/win.tscn")
	
func step_sound() -> void:
	for step in steps:
		step.play()
		await get_tree().create_timer(0.22).timeout
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Look"):
		set_process_input(false)
		facing_emit.emit(null)
		if facing == $Monitor:
			opposite = $Doors
		else:
			opposite = $Monitor
		
		step_sound()
		await create_tween().tween_property(facing, "position:y", -300.0, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).finished

		facing.visible = false
		facing.position.y = 0
		opposite.visible = true
		opposite.position.y = -300

		await get_tree().create_timer(0.3).timeout

		await create_tween().tween_property(opposite, "position:y", 0.0, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).finished

		facing = opposite
		facing_emit.emit(facing)
		set_process_input(true)
	elif event.is_action_pressed("Mute"):
		researcher.stop()
		$MuteText.hide()
