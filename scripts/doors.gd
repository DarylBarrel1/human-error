extends Node2D

@onready var main = get_parent()

const UNLIT = preload("res://assets/objects/Door.png")
const LIT1S0 = preload("res://assets/objects/stage_0_room_1.png")
const LIT1S1 = preload("res://assets/objects/stage_1_room_1.png")
const LIT1S2 = preload("res://assets/objects/stage_2_room_1.png")
const LIT1S3 = preload("res://assets/objects/stage_3_room_1.png")

const LIT2S0 = preload("res://assets/objects/stage_0_room_2.png")
const LIT2S1 = preload("res://assets/objects/stage_1_room_2.png")
const LIT2S2 = preload("res://assets/objects/stage_2_room_2.png")
const LIT2S3 = preload("res://assets/objects/stage_3_room_2.png")

const LIT3S0 = preload("res://assets/objects/stage_0_room_3.png")
const LIT3S1 = preload("res://assets/objects/stage_1_room_3.png")
const LIT3S2 = preload("res://assets/objects/stage_2_room_3.png")
const LIT3S3 = preload("res://assets/objects/stage_3_room_3.png")

var monster_door = 0
var monster_stage = 0
var doors = false

func _ready() -> void:
	if main.has_signal("facing_emit"):
		main.facing_emit.connect(on_facing_changed)

func on_facing_changed(facing: Node) -> void:
	doors = (facing == self)

func _process(_delta: float) -> void:
	if doors:
		if Input.is_action_pressed("Door1_Lit"):
			if monster_door == 1:
				if monster_stage == 0:
					$Door1.texture = LIT1S0
				elif monster_stage == 1:
					$Door1.texture = LIT1S1
				elif monster_stage == 2:
					$Door1.texture = LIT1S2
				elif monster_stage == 3:
					$Door1.texture = LIT1S3
			else:
				$Door1.texture = LIT1S0
		else:
			$Door1.texture = UNLIT
		
		if Input.is_action_pressed("Door2_Lit"):
			if monster_door == 2:
				if monster_stage == 0:
					$Door2.texture = LIT2S0
				elif monster_stage == 1:
					$Door2.texture = LIT2S1
				elif monster_stage == 2:
					$Door2.texture = LIT2S2
				elif monster_stage == 3:
					$Door2.texture = LIT2S3
			else:
				$Door2.texture = LIT2S0
		else:
			$Door2.texture = UNLIT

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
