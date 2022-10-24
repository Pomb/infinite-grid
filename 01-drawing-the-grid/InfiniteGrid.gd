# Make it run at editor time
tool
# Extending Node2d for the draw callback
extends Node2D
# Toggle to switch updates on of off
export(bool) var on = true

# The logical size of a cell
export(int) var cell_size = 16
export(int) var cell_padding = 4
export(int) var wall_size = 2

onready var camera = get_parent().get_node("Camera2D")

# The viewport size
onready var view_size = get_viewport_rect().size
onready var half_view_size = view_size / 2
var size


func _draw() -> void:
	if not on:
		return

	var half_cell_size = cell_size / 2
	var half_cell_padding = cell_padding / 2
	var half_wall_size = wall_size / 2

	var cam = camera.position
	size = (view_size * camera.zoom) - (half_view_size * camera.zoom)
	var offset = (Vector2.ONE * half_cell_size) + (half_view_size * camera.zoom)
	# Setup the range: The grids center at the center of the screen
	# Start end for the number of columns
	var x_start = int((cam.x - size.x) / cell_size) - 2
	var x_end = int((size.x + cam.x) / cell_size) + 1
	# Start end for the number of rows
	var y_start = int((cam.y - size.y) / cell_size) - 2
	var y_end = int((size.y + cam.y) / cell_size) + 1

	for x in range(x_start, x_end):
		for y in range(y_start, y_end):
			# The offset must be added so we end up with a cell center in the middle of the screen
			# The rect drawing has the position at the top left
			# The bottom right corner position is found with pos + size
			# One can adjust the offset based on what the engine considers [0,0]
			var cell_top_left = Vector2(x, y) * cell_size + offset
			var center_size = cell_size - cell_padding
			var wall_padding = cell_size - half_wall_size

			# Center
			_draw_rect_outline(
				cell_top_left + (Vector2.ONE * half_cell_padding), Vector2.ONE * center_size
			)

			# Vertical
			_draw_rect_outline(
				cell_top_left + Vector2(wall_padding, half_cell_padding),
				Vector2(wall_size, center_size)
			)

			# Horizontal
			_draw_rect_outline(
				cell_top_left + Vector2(half_cell_padding, wall_padding),
				Vector2(center_size, wall_size)
			)

			# Cross / Corner
			_draw_rect_outline(cell_top_left + Vector2.ONE * wall_padding, Vector2.ONE * wall_size)


func _draw_rect_outline(origin, rect_size):
	draw_rect(Rect2(origin, rect_size), Color.black, false, .5, true)


func _process(_delta: float) -> void:
	# Force grid redraw
	update()
