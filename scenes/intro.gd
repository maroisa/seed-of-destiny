extends Control

func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(func(animation_name):
		get_tree().change_scene_to_file("res://scenes/world.tscn"))
