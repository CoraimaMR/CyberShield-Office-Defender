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
	points_label.text = str(value).pad_zeros(2)

func _on_lifes_updated(value: int) -> void:
	for i in lifes_container.get_child_count():
		var life_icon = lifes_container.get_child(i)
		life_icon.visible = i < value
