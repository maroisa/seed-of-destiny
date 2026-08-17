extends CanvasLayer


func _ready() -> void:
	$AnimationPlayer.play("fade")

func to(scene_name: String):
	$AnimationPlayer.play_backwards("fade")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(scene_name)
	$AnimationPlayer.play("fade")
