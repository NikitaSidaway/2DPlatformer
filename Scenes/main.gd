extends Node2D

@onready var ui: Control = $UI
@onready var level_holder: Node2D = $LevelHolder
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D

@onready var music_player: AudioStreamPlayer2D = $AudioManager/MusicPlayer
@onready var sfx_player: AudioStreamPlayer2D = $AudioManager/SFXPlayer
@onready var ui_sfx_player: AudioStreamPlayer2D = $AudioManager/UISFXPlayer

var cutscene_scene: PackedScene = preload("res://Scenes/cutscene.tscn")
var level_0_scene: PackedScene = preload("res://Levels/level_0.tscn")

func _ready() -> void:
	# 1. Disable player movement and hide sprite during initial menu phase
	player.hide()
	player.set_physics_process(false)
	
	# 2. Connect MainMenu signal if present inside UI
	if ui.has_node("MainMenu"):
		var main_menu = ui.get_node("MainMenu")
		if main_menu.has_signal("play_pressed"):
			main_menu.play_pressed.connect(_on_play_pressed)

func _physics_process(_delta: float) -> void:
	# Smoothly track player with camera during gameplay
	if player.visible:
		camera.position = player.position

# --- SCENE TRANSITIONS ---

func _on_play_pressed() -> void:
	# Clear Main Menu UI
	_clear_container(ui)
	
	# Instantiate and show Cutscene inside UI layer
	var cutscene = cutscene_scene.instantiate()
	ui.add_child(cutscene)
	
	if cutscene.has_signal("cutscene_finished"):
		cutscene.cutscene_finished.connect(_on_cutscene_finished.bind(cutscene))

func _on_cutscene_finished(cutscene_node: Node) -> void:
	# Unload Cutscene from UI
	if is_instance_valid(cutscene_node):
		cutscene_node.queue_free()
	_clear_container(ui)
	
	# Instantiate Level 0 inside LevelHolder
	var level_0 = level_0_scene.instantiate()
	level_holder.add_child(level_0)
	
	# Activate Player and sync Camera position
	player.show()
	player.set_physics_process(true)
	camera.position = player.position

func _clear_container(container: Node) -> void:
	for child in container.get_children():
		child.queue_free()

# --- GLOBAL AUDIO MANAGEMENT ---

func play_music(stream: AudioStream) -> void:
	if music_player.stream != stream:
		music_player.stream = stream
		music_player.play()

func stop_music() -> void:
	music_player.stop()

func play_sfx(stream: AudioStream) -> void:
	sfx_player.stream = stream
	sfx_player.play()

func play_ui_sfx(stream: AudioStream) -> void:
	ui_sfx_player.stream = stream
	ui_sfx_player.play()
