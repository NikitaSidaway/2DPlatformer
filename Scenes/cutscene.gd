extends Control

signal cutscene_finished

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var _is_finished: bool = false

func _ready() -> void:
	anim.animation_finished.connect(_finish_cutscene)
	anim.play("default")

func _unhandled_input(event: InputEvent) -> void:
	# Optional: Allow skipping the cutscene with Jump or Escape
	if event.is_action_pressed("Jump") or event.is_action_pressed("Escape"):
		_finish_cutscene()

func _finish_cutscene() -> void:
	if _is_finished:
		return
	_is_finished = true
	cutscene_finished.emit()
