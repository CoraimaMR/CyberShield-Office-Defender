extends Node

# Archivo donde se guardará la información de forma permanente
const SAVE_PATH = "user://highscore_ranking.save"

# Límite de personas en la tabla
const MAX_SCORES: int = 10

var last_player_name: String = ""
# Nuestra lista de diccionarios (Array of Dictionaries)
# El orden aquí no importa mucho ahora, porque luego aprenderemos a ordenarlos por puntos
var high_scores: Array = [
	{"name": "Sergio", "score": 5000, "rank": "The Boss"},
	{"name": "Irene", "score": 4000, "rank": "Security Expert"},
	{"name": "Admin", "score": 3000, "rank": "Security Expert"},
	{"name": "User_Alpha", "score": 2000, "rank": "Junior Technician"},
	{"name": "User_Beta", "score": 1500, "rank": "Junior Technician"},
	{"name": "Student_01", "score": 1000, "rank": "Junior Technician"},
	{"name": "Player_X", "score": 500, "rank": "Intern"},
	{"name": "Newbie", "score": 250, "rank": "Intern"},
	{"name": "Guest_1", "score": 100, "rank": "Intern"},
	{"name": "Guest_2", "score": 50, "rank": "Intern"}
]

func _ready():
	load_scores()

# Función para guardar el ranking en el disco
func save_scores():
	# 1. Abrimos el archivo para ESCRITURA (FileAccess.WRITE)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if file:
		# 2. Convertimos la Array de diccionarios a una cadena de texto (JSON)
		# y la escribimos en el archivo.
		var json_string = JSON.stringify(high_scores)
		file.store_string(json_string)
		
		# 3. Cerramos el archivo (¡Muy importante en programación!)
		file.close()
		print("Ranking guardado con éxito en: ", SAVE_PATH)
	else:
		print("ERROR: No se pudo abrir el archivo para guardar.")

# Función para cargar el ranking desde el disco
func load_scores():
	# 1. Comprobamos si el archivo existe antes de intentar abrirlo
	if not FileAccess.file_exists(SAVE_PATH):
		print("No hay archivo de guardado previo. Usando datos por defecto.")
		return # Salimos de la función
	
	# 2. Abrimos el archivo para LECTURA (FileAccess.READ)
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	
	if file:
		# 3. Leemos todo el contenido del archivo
		var json_string = file.get_as_text()
		file.close() # Cerramos el archivo al terminar de leer
		
		# 4. Convertimos el texto (JSON) de nuevo a una Array de Godot
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			# Actualizamos nuestra variable con los datos reales del disco
			high_scores = json.get_data()
			print("Ranking cargado con éxito.")
		else:
			print("ERROR: Al leer los datos del archivo JSON.")
# Función para intentar añadir una nueva puntuación
func add_new_score(p_name: String, p_score: int, p_rank: String):
	
	last_player_name = p_name # Guardamos el nombre antes de añadirlo
	
	# 1. Creamos el nuevo diccionario con los datos del jugador
	var new_entry = {"name": p_name, "score": p_score, "rank": p_rank}
	
	# 2. Lo añadimos a la lista actual
	high_scores.append(new_entry)
	
	# 3. ORDENAR: Usamos una función personalizada para que ordene por puntos
	high_scores.sort_custom(sort_by_score)
	
	# 4. LIMITAR: Si ahora hay 11, borramos el último (el que tiene menos puntos)
	if high_scores.size() > MAX_SCORES:
		high_scores.resize(MAX_SCORES)
	
	# 5. GUARDAR: Como la lista ha cambiado, la grabamos en el disco
	save_scores()

# Función auxiliar para comparar dos puntuaciones (necesaria para sort_custom)
func sort_by_score(a, b):
	return a["score"] > b["score"] # Devuelve 'true' si el primero es mayor que el segundo

func reset_scores():
	# 1. Borramos el archivo físico del disco
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	
	# 2. Podríamos reiniciar la lista a vacía o a los valores por defecto
	# Por ahora, la dejamos vacía para notar el cambio
	high_scores.clear()
	
	# 3. Guardamos la lista vacía (opcional)
	save_scores()
