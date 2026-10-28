extends Node3D

@onready var auto_anim = $CharacterBody3D/Neck/Camera3D/Gun/AnimationPlayer
@onready var aim_ray = $CharacterBody3D/Neck/Camera3D/AimRay

func _ready() -> void:
	aim_ray.collision_mask = 0xFFFFFFFF
	aim_ray.collide_with_areas = true
	aim_ray.collide_with_bodies = true
	aim_ray.exclude_parent = true
	aim_ray.hit_from_inside = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		_shoot_auto()

func _shoot_auto():
	if auto_anim.is_playing():
		return

	auto_anim.play("Shoot")
	aim_ray.force_raycast_update()

	if not aim_ray.is_colliding():
		return

	var collider = aim_ray.get_collider()
	var ball = collider if collider.is_in_group("Balls") else collider.get_parent()

	# Check if it's a ball AND if it's currently visible!
	if ball and ball.is_in_group("Balls") and ball.has_method("hit") and ball.visible:
		ball.hit()
		var game = get_tree().get_first_node_in_group("Game")
		if game:
			game.show_hit_marker()
