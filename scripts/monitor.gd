extends Node2D

@onready var main = get_parent()
@onready var label: RichTextLabel = $MonitorText
@onready var counter: RichTextLabel = $CounterText
@onready var key_sounds = [$Key4, $Key5, $Key7, $Key8, $Key9]

const sentences = [
	"Something's here",
	"We have to leave",
	"Dear mother, I'm sorry but we have created something much worse",
	"Keep typing keep typing keep typing keep typing",
	"10101111100010101101010110000100111010110011011011",
	"011011010110111101101110011000010111001101101000",
	"Error 4044444444",
	"Hey, you have to check this out, I think we just created a new species",
	"Please help I'm trapped, I'm on the east side at zone 0, we found a way to ...",
	"Initiate self-destruct? initiating self-destruct in T minus 10",
	"Somethings here. Stay calm and finish your task to escape",
	"Make sure to check your surroundings, you don't know what's lurking in the shadows",
	"Stay calm and collected, do not make any sudden movements or sounds",
	"Keep typing. Finish the override… while you still can",
	"If you're still inside the facility. GET OUT",
	"Make sure to finish the override. Or you'll be stuck in here, for good",
	"If you see anything, run, that's not human anymore",
	"Whatever you do. Make sure they don't get out",
	"If the sounds are getting clearer, it means they're getting closer",
	"If they get close, zap them, it'll buy you more time",
	"Do you smell that? Something is rotting behind one of the doors",
	"We didn't intend for this to happen, but now we can't let them escape",
	"We were trying to solve human error, instead we ending up contributing to it",
	"Don't forget to zap, that's the only thing that can buy you some time",
	"We have created something sinister, far beyond our understanding",
	"Be careful what you wish for, often the end result isn't ...",
	"When in doubt. RUN",
	"Stay ALIVE"
	"Stay calm, follow the instructions, and you MAY just make it out alive",
	"Remember, you can't afford to let them out",
	"Somethings here. Worry not, zap to keep them away",
	"What happened here? How did everything go so terribly wrong?",
	"Sometimes while trying to solve something, one ends up creating a new problem",
	"If you make it out alive, don't tell anyone about this, it must be kept secret",
	"Whatever you do. DONT let them out",
	"What are you doing here? You should never have come",
	"If you value living, don't enter any containment areas ...",
	"If you hear any sound, ignore it, walk the other way",
]

var previous = ""
var target = ""
var typed = ""
var sentences_completed = 0
var monitor = true

var cursor_timer = 0.0
var cursor_blink = true

func _ready() -> void:
	if main.has_signal("facing_emit"):
		main.facing_emit.connect(on_facing_changed)

	counter.clear()
	counter.push_color(Color.GREEN)
	counter.add_text(str(sentences_completed) + "/" + "30")
	counter.pop()

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
			if cursor_blink == true:
				label.push_underline() 
				label.add_text(target_letter)
				label.pop()
			else:
				label.add_text(target_letter)
		else:
			label.push_color("#3f4d44")
	
		if target_pos != typed.length():
			label.add_text(target_letter)
		label.pop()


func _unhandled_input(event: InputEvent) -> void:
	if not monitor or not event is InputEventKey or not event.pressed or (event.unicode == 0 and event.keycode != KEY_BACKSPACE):
		return

	cursor_timer = 0.6
	cursor_blink = true

	if event.keycode == KEY_BACKSPACE:
		typed = typed.left(-1)
	elif event.keycode != KEY_SPACE and typed.length() < target.length() and target[typed.length()] == " ":
		typed += " "
	elif typed.length() < target.length():
		var letter = char(event.unicode).to_upper()
		typed += letter
	
	key_sounds.pick_random().play()
	label.clear()
	screen_text_display()

	get_viewport().set_input_as_handled()

	if typed == target:
		sentences_completed += 1
		
		counter.clear()
		counter.push_color(Color.GREEN)
		counter.add_text(str(sentences_completed) + "/" + "30")
		counter.pop()

		if sentences_completed >= 30:
			main.game_win()
		else:
			generate_new_sentence()

func _process(delta: float) -> void:
	cursor_timer -= delta
	if cursor_timer <= 0.0:
		cursor_timer = 0.45
		cursor_blink = not cursor_blink
		label.clear()
		screen_text_display()
