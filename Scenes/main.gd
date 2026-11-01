extends Node2D

@onready var ui: Control = $UI
@onready var level_holder: Node2D = $LevelHolder
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D

@onready var music_player: AudioStreamPlayer2D = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
@onready var uisfx_player: AudioStreamPlayer2D = $UISFXPlayer

var cutscene_scene: PackedScene = preload("res://Scenes/cutscene.tscn")
var level_0_scene: PackedScene = preload("res://Levels/level_0.tscn")

func _ready() -> void:
	player.hide()
	player.set_physics_process(false)
	
	if ui.has_node("MainMenu"):
		var main_menu = ui.get_node("MainMenu")

		main_menu.play_pressed.connect(_on_play_pressed)
