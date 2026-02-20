extends Control

# 1. Cargamos el molde de la fila (asegúrate de que la ruta sea correcta)
var row_scene = preload("res://scenes/ScoreRow.tscn")

# 2. Referencias a los nodos de esta escena
@onready var score_list = $VBoxContainer/ScoreList
@onready var reset_button: TextureButton = $ResetButton

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
	# A. Limpiamos la lista (por si acaso se llama varias veces)
	for child in score_list.get_children():
		child.queue_free()
	
	# B. Leemos los datos del Autoload 'ScoreManager'
	var pos = 1
	for entry in ScoreManager.high_scores:
		var row = row_scene.instantiate()
		
		# C. Rellenamos los datos de la fila
		# Asegúrate de que los nombres de los nodos coincidan con los de tu ScoreRow.tscn
		row.get_node("PosLabel").text = str(pos) + "."
		row.get_node("NameLabel").text = entry["name"]
		row.get_node("RankLabel").text = entry["rank"]
		row.get_node("ScoreLabel").text = str(entry["score"])
		
		# --- RESALTADO ---
		if entry["name"] == ScoreManager.last_player_name:
			# Cambiamos el color de los textos a dorado o verde hacker
			var highlight_color = Color(1, 0.84, 0) # Dorado
			row.get_node("PosLabel").modulate = highlight_color
			row.get_node("NameLabel").modulate = highlight_color
			row.get_node("RankLabel").modulate = highlight_color
			row.get_node("ScoreLabel").modulate = highlight_color
		
		# D. Añadimos la fila a la tabla visual
		score_list.add_child(row)
		pos += 1

# --- SEÑALES DE LOS BOTONES ---

func _on_reset_button_pressed():
	print("Botón Reset pulsado - Iniciando borrado...")
	ScoreManager.reset_scores() # Llamamos a la lógica
	display_scores() # Refrescamos la pantalla para que se vea vacía

func _on_back_button_pressed() -> void:
	print("Botón Volver pulsado - Cambiando de escena...")
	get_tree().change_scene_to_file("res://scenes/Desktop.tscn")
