extends Node3D

@export var max_balls: int = 3

@onready var crosshair = $UI/Crosshair
@onready var crosshair_hit = $UI/CrosshairHit
@onready var hit_sound = $HitSound

var all_balls: Array = []
var active_balls: Array = []


func _ready() -> void:
	add_to_group("Game")

	# Center the crosshairs
	var screen_size = get_viewport().get_visible_rect().size
	crosshair.position.x = (screen_size.x / 2.0) - (crosshair.size.x / 2.0)
	crosshair.position.y = (screen_size.y / 2.0) - (crosshair.size.y / 2.0)
	crosshair_hit.position.x = (screen_size.x / 2.0) - (crosshair_hit.size.x / 2.0)
	crosshair_hit.position.y = (screen_size.y / 2.0) - (crosshair_hit.size.y / 2.0)
	crosshair_hit.visible = false

	# Find all balls using the group we already set up in ball.gd
	all_balls = get_tree().get_nodes_in_group("Balls")
	print("Found balls: ", all_balls.size())
		
	for ball in all_balls:
		ball.ball_hit.connect(_on_ball_hit.bind(ball))

	# Activate 3 random balls
	for i in max_balls:
		activate_random_ball()

func activate_random_ball() -> void:
	var inactive = all_balls.filter(func(b): return not b.visible)
	if inactive.is_empty():
		return
	
	var ball = inactive.pick_random()
	ball.activate()
	
	# Only add to active_balls if it's not already there
	if not active_balls.has(ball):
		active_balls.append(ball)

func _on_ball_hit(ball) -> void:
	active_balls.erase(ball)
	activate_random_ball()
	hit_sound.play()          
	show_hit_marker() 

func show_hit_marker() -> void:
	crosshair_hit.visible = true
	await get_tree().create_timer(0.1).timeout
	crosshair_hit.visible = false
	
