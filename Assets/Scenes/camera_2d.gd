extends Camera2D

@export var player : CharacterBody2D

func _physics_process(delta: float) -> void:
	position = position.lerp(player.global_position + Vector2(150,0).rotated(player.rotation),8*delta)
	var zoom_level = lerp(0.8-(player.velocity.length()/875)/3,zoom[0],0.5*delta)
	zoom = Vector2(zoom_level,zoom_level)
	print(zoom_level)
