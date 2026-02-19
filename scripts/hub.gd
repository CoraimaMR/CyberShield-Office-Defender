extends CanvasLayer # HUB

@onready var points_label = %counter_points 
@onready var lifes_container = %counter_lifes

var counnter_label
var level_label
var time_bar


func _ready() -> void:
	time_bar = get_node_or_null("%hub/%TimeBar")
	counnter_label = get_node_or_null("%hub/%counter_level")
	level_label = get_node_or_null("%hub/%level_label")
	
	Autoload.points_updated.connect(_on_points_updated)
	Autoload.lifes_updated.connect(_on_lifes_updated)
	Autoload.level_up.connect(_on_level_updated)

	# init UI
	_on_points_updated(Autoload.current_points)
	_on_lifes_updated(Autoload.current_lifes)
	_on_level_updated(Autoload.current_level, Autoload.current_rank)

# ---------------- POINTS ----------------
func _on_points_updated(value: int) -> void:
	if is_instance_valid(points_label):
		points_label.text = str(value).pad_zeros(2)

# ---------------- LIFES ----------------
func _on_lifes_updated(value: int) -> void:
	if not is_instance_valid(lifes_container):
		return

	for i in range(lifes_container.get_child_count()):
		var heart = lifes_container.get_child(i)
		if heart:
			heart.visible = value > i

# ---------------- LEVEL + RANK ----------------
func _on_level_updated(level: int, rank: String) -> void:
	if is_instance_valid(level_label):
		counnter_label.text = str(level).pad_zeros(2) +". "
		level_label.text = rank

# ---------------- TIMER ----------------
func update_time_bar(current_time: float, max_time: float) -> void:
	if is_instance_valid(time_bar):
		time_bar.value = (current_time * 100.0) / max_time

func set_time_bar_visible(visib: bool) -> void:
	if is_instance_valid(time_bar):
		time_bar.visible = visib

# ---------------- CLEANUP ----------------
func _exit_tree():
	if Autoload.points_updated.is_connected(_on_points_updated):
		Autoload.points_updated.disconnect(_on_points_updated)

	if Autoload.lifes_updated.is_connected(_on_lifes_updated):
		Autoload.lifes_updated.disconnect(_on_lifes_updated)

	if Autoload.level_up.is_connected(_on_level_updated):
		Autoload.level_up.disconnect(_on_level_updated)
