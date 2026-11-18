extends Control
signal play_pressed

func _on_play_button_pressed() -> void:
	play_pressed.emit()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
