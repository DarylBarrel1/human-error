extends Node2D

signal facing_emit(facing)

var facing: Node2D
var opposite: Node2D

var timer = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	facing = $Monitor
	$Monitor.visible = true
	$Doors.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Doors.zap_flickering > 0:
		return

	timer -= delta
	if timer <= 0.0:
		timer = randf_range(10, 30)
		if $Doors.monster_stage < 3:
			# TODO: PLAY MONSTER AUDIO HERE
			if $Doors.monster_door == 0:
				$Doors.monster_door = randi_range(1, 3)
			$Doors.monster_stage += 1
		else:
			game_over()
			
func game_over() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Look"):
		facing_emit.emit(null)
		if facing == $Monitor:
			opposite = $Doors
		else:
			opposite = $Monitor
		
		await create_tween().tween_property(facing, "position:y", -300.0, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).finished

		facing.visible = false
		facing.position.y = 0
		opposite.visible = true
		opposite.position.y = -300

		await get_tree().create_timer(0.3).timeout

		await create_tween().tween_property(opposite, "position:y", 0.0, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).finished

		facing = opposite
		facing_emit.emit(facing)
