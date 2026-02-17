extends CanvasLayer #HUB

var current_points: int = 00
var current_lifes: int = 3
var max_lifes: int = 3

@onready var points_label: Label = $Control/points/HBoxContainer/counter_points
@onready var lifes_container: HBoxContainer = $Control/lifes/counter_lifes

# =====================
# POINTS
# =====================

func add_points(points: int) -> void:
	current_points += points
	update_points_ui()

func remove_points(points: int) -> void:
	current_points = max(0, current_points - points)
	update_points_ui()

func update_points_ui() -> void:
	points_label.text = str(current_points).pad_zeros(2) # 00, 01, 02...

# =====================
# LIFES
# =====================

func add_lifes(lifes: int) -> void:
	current_lifes = min(max_lifes, current_lifes + lifes)
	update_lifes_ui()

func remove_lifes(lifes: int) -> void:
	current_lifes = max(0, current_lifes - lifes)
	update_lifes_ui()

func update_lifes_ui() -> void:
	for i in lifes_container.get_child_count():
		var life_icon = lifes_container.get_child(i)
		life_icon.visible = i < current_lifes
