extends Node2D

@onready var main = get_parent()
@onready var label: RichTextLabel = $MonitorText

const sentences = [
	"Something's here",
	"We have to leave",
	"Dear mother, I'm sorry but we have created something much worse",
	"Keep typing keep typing keep typing keep typing",
	"101011111000101011010101100001001110101100",
	"Error 4044444444",
	"Hey, you have to check this out, I think we just created a new species",
	"Please help I'm trapped, I'm on the east side at zone 0, we found a way to ...",
	"Initiate self-destruct? initiating self-destruct in T minus 10"
]

var previous = ""
var target = ""
var typed = ""
var monitor = true

func _ready() -> void:
	if main.has_signal("facing_emit"):
		main.facing_emit.connect(on_facing_changed)
	return generate_new_sentence()

func on_facing_changed(facing: Node) -> void:
	monitor = (facing == self)

func generate_new_sentence() -> void:
	previous = target
	target = sentences.pick_random().to_upper()
	while target == previous:
		target = sentences.pick_random().to_upper()
	typed = ""
	label.clear()
	screen_text_display()

func screen_text_display() -> void:
	for target_pos in target.length():
		var target_letter = target[target_pos]
		
		if target_pos < typed.length():
			if typed[target_pos] == target_letter:
				label.push_color(Color.GREEN)
			else:
				label.push_color(Color.RED)
		elif target_pos == typed.length():
			label.push_color(Color.WHITE)
			label.push_underline() 
			label.add_text(target_letter)
			label.pop()
		else:
			label.push_color("#3f4d44")
	
		if target_pos != typed.length():
			label.add_text(target_letter)
		label.pop()


func _unhandled_input(event: InputEvent) -> void:
	if not monitor or not event is InputEventKey or not event.pressed or (event.unicode == 0 and event.keycode != KEY_BACKSPACE):
		return

	if event.keycode == KEY_BACKSPACE:
		typed = typed.left(-1)
	elif typed.length() < target.length():
		var letter = char(event.unicode).to_upper()
		typed += letter

	label.clear()
	screen_text_display()

	get_viewport().set_input_as_handled()

	if typed == target:
		generate_new_sentence()
