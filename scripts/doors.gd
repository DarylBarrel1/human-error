extends Node2D

const LIT := preload("res://assets/objects/Door-Lit.png")
const UNLIT := preload("res://assets/objects/Door.png")

@onready var doors: Array[Sprite2D] = [$Door1, $Door2, $Door3]


func _process(_delta: float) -> void:
	# Keys 1-3 are consecutive keycodes, so KEY_1 + i maps door i to its key.
	for i in doors.size():
		doors[i].texture = LIT if Input.is_key_pressed(KEY_1 + i) else UNLIT
