extends CanvasLayer # HUB

@onready var points_label = %counter_points 
@onready var lifes_container = %counter_lifes
@onready var time_bar = %TimeBar 

func _ready() -> void:
	Autoload.points_updated.connect(_on_points_updated)
	Autoload.lifes_updated.connect(_on_lifes_updated)
	_on_points_updated(Autoload.current_points)
	_on_lifes_updated(Autoload.current_lifes)

func _on_points_updated(value: int) -> void:
	if is_instance_valid(points_label):
		points_label.text = str(value).pad_zeros(2)

func _on_lifes_updated(value: int) -> void:
	if not is_instance_valid(lifes_container):
		return

	for i in lifes_container.get_child_count():
		var heart = lifes_container.get_child(i)
		if heart:
			heart.visible = value > i

func update_time_bar(current_time: float, max_time: float) -> void:
	if is_instance_valid(time_bar):
		time_bar.value = (current_time * 100) / max_time

func set_time_bar_visible(is_visible: bool) -> void:
	if is_instance_valid(time_bar):
		time_bar.visible = is_visible

func _exit_tree():
	if Autoload.points_updated.is_connected(_on_points_updated):
		Autoload.points_updated.disconnect(_on_points_updated)
	if Autoload.lifes_updated.is_connected(_on_lifes_updated):
		Autoload.lifes_updated.disconnect(_on_lifes_updated)
