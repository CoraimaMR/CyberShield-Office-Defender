extends CanvasLayer # HUB

# --- ONREADY NODES ---
@onready var points_label = %counter_points 
@onready var lifes_container = %counter_lifes
@onready var counnter_label = %counter_level
@onready var level_label = %level_label

# --- VARIABLES ---
var time_bar

# --- INITIALIZATION ---
func _ready() -> void:
	# Attempt to find the TimeBar node within the hub structure
	time_bar = get_node_or_null("%hub/%TimeBar")
	
	# Connect global signals from the Autoload singleton
	Autoload.points_updated.connect(_on_points_updated)
	Autoload.lifes_updated.connect(_on_lifes_updated)
	Autoload.level_up.connect(_on_level_updated)

	# Initialize UI with current global values
	_on_points_updated(Autoload.current_points)
	_on_lifes_updated(Autoload.current_lifes)
	_on_level_updated(Autoload.current_level, Autoload.current_rank)

# --- SCORE UI ---
# Updates the points display with leading zeros
func _on_points_updated(value: int) -> void:
	if is_instance_valid(points_label):
		points_label.text = str(value).pad_zeros(2)

# --- LIVES UI ---
# Updates the heart icons based on current player health
func _on_lifes_updated(value: int) -> void:
	if not is_instance_valid(lifes_container):
		return

	for i in range(lifes_container.get_child_count()):
		var heart = lifes_container.get_child(i)
		if heart:
			# Hide hearts that exceed the current life count
			heart.visible = value > i

# --- PROGRESS UI ---
# Updates the level number and the player's rank title
func _on_level_updated(level: int, rank: String) -> void:
	if is_instance_valid(level_label):
		counnter_label.text = str(level).pad_zeros(2) + ". "
		level_label.text = rank

# --- TIMER UI ---
# Calculates and updates the percentage value of the progress bar
func update_time_bar(current_time: float, max_time: float) -> void:
	if is_instance_valid(time_bar):
		time_bar.value = (current_time * 100.0) / max_time

# Toggles the visibility of the timer (e.g., hidden in Level 1)
func set_time_bar_visible(visib: bool) -> void:
	if is_instance_valid(time_bar):
		time_bar.visible = visib

# --- CLEANUP ---
# Disconnect signals when the HUB is removed to prevent memory leaks or errors
func _exit_tree():
	if Autoload.points_updated.is_connected(_on_points_updated):
		Autoload.points_updated.disconnect(_on_points_updated)

	if Autoload.lifes_updated.is_connected(_on_lifes_updated):
		Autoload.lifes_updated.disconnect(_on_lifes_updated)

	if Autoload.level_up.is_connected(_on_level_updated):
		Autoload.level_up.disconnect(_on_level_updated)
