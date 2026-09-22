extends Node2D

var facing: Node2D
var opposite: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	facing = $Monitor
	$Monitor.visible = true
	$Doors.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# I think i'll add monster logic here later
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Look"):
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
