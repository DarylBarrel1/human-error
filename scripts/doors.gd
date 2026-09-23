extends Node2D

@onready var main = get_parent()
@onready var status: Label = $Status
@onready var light_sound = $LightDecomposed
@onready var zap_sound = $Zap

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
var cooldown = 0
var zap_flickering = 0
var zap_door = 0
var pulse = 0.0
var previous = 0
var doors = false

func _ready() -> void:
	if main.has_signal("facing_emit"):
		main.facing_emit.connect(on_facing_changed)

func on_facing_changed(facing: Node) -> void:
	doors = (facing == self)

func _input(event: InputEvent) -> void:
	if doors and cooldown <= 0.0 and event.is_action_pressed("Zap"):
		zap_door = 0
		if Input.is_action_pressed("Door1_Lit"):
			zap_door = 1
		elif Input.is_action_pressed("Door2_Lit"):
			zap_door = 2
		elif Input.is_action_pressed("Door3_Lit"):
			zap_door = 3
		
		if zap_door > 0:
			zap_sound.play()
			zap_flickering = 1.8
			cooldown = 10.0


func _process(_delta: float) -> void:
	pulse += _delta
	if cooldown > 0.0:
		cooldown -= _delta
		status.text = "%.1f" % cooldown
		status.modulate = Color("#f29a42").lerp(Color("#d26f0c"), sin(pulse * 7.0))
	else:
		status.text = "ZAP READY"
		status.modulate = Color("#6f92ec").lerp(Color("#d7e963"), sin(pulse * 2.0))

	var zap_flash = false
	if zap_flickering > 0:
		if zap_flickering > 1.79:
			zap_flash = true
		elif zap_flickering > 1.75:
			zap_flash = false
		elif zap_flickering > 1.70:
			zap_flash = true
		elif zap_flickering > 1.60:
			zap_flash = false
		elif zap_flickering > 1.50:
			zap_flash = true
		elif zap_flickering > 1.40:
			zap_flash = false
		elif zap_flickering > 1.30:
			zap_flash = true
		elif zap_flickering > 1.20:
			zap_flash = false
		elif zap_flickering > 1.10:
			zap_flash = true
		elif zap_flickering > 1.00:
			zap_flash = false
		elif zap_flickering > 0.85:
			zap_flash = true
		elif zap_flickering > 0.70:
			zap_flash = false
		elif zap_flickering > 0.55:
			zap_flash = true
		elif zap_flickering > 0.45:
			zap_flash = false
		elif zap_flickering > 0.35:
			zap_flash = true
		else:
			zap_flash = false 

			if monster_door == zap_door:
				monster_door = 0
				monster_stage = 0
				main.timer = randf_range(5, 20)

		zap_flickering -= _delta

	if doors:
		var input = 0
		if Input.is_action_pressed("Door1_Lit"):
			input = 1
		elif Input.is_action_pressed("Door2_Lit"):
			input = 2
		elif Input.is_action_pressed("Door3_Lit"):
			input = 3

		var condition = false
		if zap_flickering > 0 and zap_door == 1:
			condition = zap_flash
		else:
			condition = input == 1
		if condition:
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
		
		if zap_flickering > 0 and zap_door == 2:
			condition = zap_flash
		else:
			condition = input == 2
		if condition:
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

		if zap_flickering > 0 and zap_door == 3:
			condition = zap_flash
		else:
			condition = input == 3
		if condition:
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
		
		if input != 0 and previous == 0:
			light_sound.play()
		elif input == 0 and previous != 0:
			light_sound.stop()
		previous = input
