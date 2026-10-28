extends Node3D

signal ball_hit

var _active := false

func _ready() -> void:
	add_to_group("Balls")
	print("[BALL] _ready called, name=", name, " parent=", get_parent())
	deactivate()

func activate() -> void:
	_active = true
	show()
	for child in find_children("*", "VisualInstance3D", true, false):
		child.show()
	for c in find_children("*", "CollisionShape3D", true, false):
		c.set_deferred("disabled", false)

func deactivate() -> void:
	_active = false
	hide()
	for child in find_children("*", "VisualInstance3D", true, false):
		child.hide()
	for c in find_children("*", "CollisionShape3D", true, false):
		c.set_deferred("disabled", true)

func hit() -> void:
	if not _active:
		return
	print("Ball was hit!")
	emit_signal("ball_hit")
	deactivate()
