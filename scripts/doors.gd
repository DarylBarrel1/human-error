extends Node2D

@onready var main = get_parent()

const UNLIT = preload("res://assets/objects/Door.png")
const LIT1S0 = preload("res://assets/objects/stage_0_room_1.png")

const LIT3S0 = preload("res://assets/objects/stage_0_room_3.png")
const LIT3S1 = preload("res://assets/objects/stage_1_room_3.png")
const LIT3S2 = preload("res://assets/objects/stage_2_room_3.png")
const LIT3S3 = preload("res://assets/objects/stage_3_room_3.png")

var monster_door = 0
var monster_stage = 0

func _process(_delta: float) -> void:
	if Input.is_action_pressed("Door1_Lit"):
		$Door1.texture = LIT1S0
	else:
		$Door1.texture = UNLIT

	if Input.is_action_pressed("Door3_Lit"):
		if monster_door == 3:
			if monster_stage == 0:
				$Door3.texture = LIT3S0
			elif monster_stage == 1:
				$Door3.texture = LIT3S1
			elif monster_stage == 2:
				$Door3.texture = LIT3S2
			elif monster_stage == 3:
				$Door3.texture = LIT3S3
		else:
			$Door3.texture = LIT3S0
	else:
		$Door3.texture = UNLIT
