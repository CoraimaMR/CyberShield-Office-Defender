extends CanvasLayer #HUB

@onready var points_label = %counter_points 
@onready var lifes_container = %counter_lifes

func _ready() -> void:
	# Connect to the Autoload signals
	Autoload.points_updated.connect(_on_points_updated)
	Autoload.lifes_updated.connect(_on_lifes_updated)
	
	# Initial UI sync with current Autoload values
	_on_points_updated(Autoload.current_points)
	_on_lifes_updated(Autoload.current_lifes)

func _on_points_updated(value: int) -> void:
	if is_instance_valid(points_label): # verify that label is not null
		points_label.text = str(value).pad_zeros(2)

func _on_lifes_updated(value: int) -> void:
	# if the lives container doesn't exist or isn't ready, do nothing
	if not is_instance_valid(lifes_container):
		return

	for i in lifes_container.get_child_count():
		var heart = lifes_container.get_child(i)
		if heart:
			heart.visible = value > i

func _exit_tree():
	# Disconnect signals on exit to prevent the Autoload
	# from trying to communicate with a HUD that no longer exists
	if Autoload.points_updated.is_connected(_on_points_updated):
		Autoload.points_updated.disconnect(_on_points_updated)
	if Autoload.lifes_updated.is_connected(_on_lifes_updated):
		Autoload.lifes_updated.disconnect(_on_lifes_updated)
