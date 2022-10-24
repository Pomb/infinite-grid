extends Camera2D

var dir = Vector2.ZERO
var velocity = Vector2.ZERO
var acceleration = 0.1
var decelleration = 3.0
var max_speed = 50.0
var zoom_level = 1.0

func _ready() -> void:
	pass  # Replace with function body.


func _process(delta: float):
	dir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	dir.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	global_position += dir * max_speed * zoom_level * delta
	
	if Input.is_action_pressed("x"):
		zoom_level += 0.1
		zoom = Vector2.ONE * zoom_level
	if Input.is_action_pressed("z"):
		zoom_level -= 0.1
		zoom = Vector2.ONE * zoom_level
	if Input.is_action_pressed("ui_cancel"):
		zoom_level = 1.0
		zoom = Vector2.ONE
