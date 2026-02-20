extends Control

# 1. Cargamos el molde de la fila (asegúrate de que la ruta sea correcta)
var row_scene = preload("res://scenes/ScoreRow.tscn")

# 2. Referencias a los nodos de esta escena
@onready var score_list = %ScoreList
@onready var reset_button: TextureButton = %ResetButton

func _ready():
	# Al abrir la pantalla, mostramos los datos
	display_scores()
	# Si el nombre del último jugador está vacío, significa que venimos 
	# del Menú Principal (Escritorio), así que mostramos el Reset.
	if ScoreManager.last_player_name == "":
		reset_button.visible = true
	else:
		reset_button.visible = false
		# Limpiamos el nombre para la próxima vez que entremos desde el menú
		ScoreManager.last_player_name = ""

func display_scores():
	# 1. Limpiamos la lista actual
	for child in score_list.get_children():
		child.queue_free()
	
	# 2. Recorremos SIEMPRE 10 posiciones (del 0 al 9)
	for i in range(10):
		var row = row_scene.instantiate()
		score_list.add_child(row)
		
		# Ponemos el número de posición (i + 1 para que empiece en 1)
		row.get_node("PosLabel").text = str(i + 1) + "."
		
		# 3. Comprobamos si hay datos reales para esta posición
		if i < ScoreManager.high_scores.size():
			var entry = ScoreManager.high_scores[i]
			row.get_node("NameLabel").text = entry["name"]
			row.get_node("RankLabel").text = entry["rank"]
			row.get_node("ScoreLabel").text = str(entry["score"])
			
			# Resaltado si es el último jugador
			if entry["name"] == ScoreManager.last_player_name:
				var highlight_color = Color(1, 0.84, 0) # Dorado
				row.modulate = highlight_color
		else:
			# 4. Si NO hay datos, rellenamos con guiones o lo dejamos vacío
			row.get_node("NameLabel").text = "---"
			row.get_node("RankLabel").text = "---"
			row.get_node("ScoreLabel").text = "0"
			# Opcional: bajar la opacidad de las filas vacías para que se noten menos
			row.modulate.a = 0.3

# --- SEÑALES DE LOS BOTONES ---

func _on_reset_button_pressed():
	print("Botón Reset pulsado - Iniciando borrado...")
	ScoreManager.reset_scores() # Llamamos a la lógica
	display_scores() # Refrescamos la pantalla para que se vea vacía

func _on_back_button_pressed() -> void:
	print("Botón Volver pulsado - Cambiando de escena...")
	get_tree().change_scene_to_file("res://scenes/Desktop.tscn")
